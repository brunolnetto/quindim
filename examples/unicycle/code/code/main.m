% Author: Bruno Peixoto
% Date: 08/01/19

% if(exist('CLEAR_ALL'))
%     if(CLEAR_ALL)
%         clear all
%     end
% end
 clear all
close all
clc

syms tau_1 tau_2;

% Body 1
syms m1 mc m2 R1 R2 Lc_x Lc_y Lc_z L2_x L2_y L2_z g real;
syms x y th psi phi1 phi2 real;
syms xp yp thp psip phi1p phi2p real;
syms xpp ypp thpp psipp phi1pp phi2pp real;

I1 = sym('I1_', [3, 1], 'real');
I1 = diag(I1);

Ic = sym('Ic_', [3, 1], 'real');
Ic = diag(Ic);

I2 = sym('I2_', [3, 1], 'real');
I2 = diag(I2);

% Rotations to body
T1 = T3d(0, [0; 0; 1], [x; y; 0]);
T2 = T3d(th, [0; 0; 1], [0; 0; 0]);
T3 = T3d(psi, [1; 0; 0], [0; 0; 0]);
T4 = T3d(0, [0; 1; 0], [0; 0; R1]);
T5 = T3d(phi1, [0; 1; 0], [0; 0; 0]);
T6 = T3d(phi2, [1; 0; 0], [L2_x; L2_y; L2_z]);

T1s = {T1, T2, T3, T4, T5};
Tcs = {T1, T2, T3, T4};
T2s = {T1, T2, T3, T4, T5, T6};

% CG position relative to body coordinate system
L1 = [0; 0; 0];
Lc = [Lc_x; Lc_y; Lc_z];
L2 = [0; 0; 0];

% Generalized coordinates
sys.kin.q = [x; y; th; psi; phi1; phi2];
sys.kin.qp = [xp; yp; thp; psip; phi1p; phi2p];
sys.kin.qpp = [xpp; ypp; thpp; psipp; phi1pp; phi2pp];

% Previous body
previous = struct('');

wheel = build_body(m1, I1, T1s, L1, {}, {}, ...
                   [x, y, th, psi, phi1], ...
                   [xp, yp, thp, psip, phi1p], ...
                   [xpp, ypp, thpp, psipp, phi1pp], ...
                   previous, []);
               
chassi = build_body(mc, Ic, Tcs, Lc, {}, {}, ...
                    [x, y, th, psi, phi1], ...
                    [xp, yp, thp, psip, phi1p], ...
                    [xpp, ypp, thpp, psipp, phi1pp], ...
                    wheel, []);
               
reaction_wheel = build_body(m2, I2, T2s, L2, {}, {}, ...
                            [x, y, th, psi, phi1, phi2], ...
                            [xp, yp, thp, psip, phi1p, phi2p], ...
                            [xpp, ypp, thpp, psipp, phi1pp, phi2pp], ...
                            chassi, []);

sys.descrip.bodies = {wheel, chassi, reaction_wheel};

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Paramater symbolics of the system
sys.descrip.syms = [m1 mc m2 R1 R2 Lc_x Lc_y Lc_z L2_x L2_y L2_z g];

% Penny data
m_num = 1;
R_num = 1;
sys.descrip.model_params = [m_num, R_num, ...
                            m_num*R_num^2/2, ...
                            m_num*R_num^2/4, ...
                            m_num*R_num^2/2, ...
                            9.8];

% External excitations
sys.descrip.Fq = [0; 0; 0; 0; tau_1; tau_2];
sys.descrip.u = [tau_1; tau_2];

% State space representation
sys.descrip.states = [x; y; th; psi; phi1; phi2];

% Constraint condition
sys.descrip.is_constrained = false;

% Kinematic and dynamic model
sys = kinematic_model(sys);

% Constraint condition
sys.descrip.is_constrained = true;

T1s = T1*T2*T3*T4;
R1s = T1s(1:3, 1:3);

v_cg = simplify_(sys.descrip.bodies{1}.v_cg);
omega_ = simplify_(omega(R1s, sys.kin.q, sys.kin.qp));

constraints = v_cg + cross(omega_, R1s*[0; 0; -R1]);
y1 = R1s(:, 2);

% Nonholonomic constraints
sys.descrip.unhol_constraints = simplify_(dot(v_cg, y1));

% Kinematic and dynamic model
sys = kinematic_model(sys);

sys = dynamic_model(sys);

% % Time [s]
% dt = 0.1;
% tf = 10;
% t = 0:dt:tf; 
% 
% % Initial conditions [m; m/s]
% % x = 1, y = 1, v = 1
% x0 = [1, 1, pi/4, 0, 1, 1]';
% 
% % System modelling
% sol = validate_model(sys, t, x0, [0; 0]);
% 
% x = t';
% y = sol';
% 
% % Generalized coordinates
% plot_info_q.titles = {'$x$', '$y$', '$\theta$', '$\phi$'};
% plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
% plot_info_q.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
% plot_info_q.grid_size = [2, 2];
% 
% hfigs_states = my_plot(x, y(:, 1:4), plot_info_q);
% 
% plot_info_p.titles = {'$\omega_{\theta}$', '$\omega_{\phi}$'};
% plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]'};
% plot_info_p.ylabels = {'$\omega_{\theta}$', '$\omega_{\phi}$'};
% plot_info_p.grid_size = [2, 1];
% 
% % States plot
% hfigs_speeds = my_plot(x, y(:, 5:6), plot_info_p);
% 
% % Energies plot
% hfig_energies = plot_energies(sys, x, y');
% hfig_consts = plot_constraints(sys, x, y);
% 
% % Images
% saveas(hfig_energies, '../images/energies', 'epsc');
% saveas(hfigs_states(1), ['../images/states', num2str(1)], 'epsc'); 
% saveas(hfigs_speeds(1), ['../images/speeds', num2str(1)], 'epsc'); 
% saveas(hfig_consts(1), ['../images/consts', num2str(1)], 'epsc'); 
