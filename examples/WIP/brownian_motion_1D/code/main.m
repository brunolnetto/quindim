% Minimal example
% @Author: Bruno Peixoto

if(exist('CLEAR_ALL'))
    if(CLEAR_ALL)
        clear all
    end
end

close all
clc

% The 'real' statement on end is important
% for inner simplifications
syms F x xp xpp real;
syms m b k g real;

% Paramater symbolics of the system
sys.descrip.syms = [m, b, k, g];

% Paramater symbolics of the system
sys.descrip.model_params = [1, 1, 9, 9.8];

% Gravity utilities
sys.descrip.gravity = [0; 0; -g];
sys.descrip.g = g;

% Body inertia
I = zeros(3, 3);

% Position relative to body coordinate system
L = zeros(3, 1);

% Bodies definition
T = {T3d(0, [0, 0, 1].', [x; 0; 0])};

damper = build_damper(b, [0; 0; 0], [xp; 0; 0]);
spring = build_spring(k, [0; 0; 0], [x; 0; 0]);
block = build_body(m, I, T, L, {damper}, {spring}, ...
                   x, xp, xpp, struct(''), []);

sys.descrip.bodies = {block};

% Generalized coordinates
sys.kin.q = x;
sys.kin.qp = xp;
sys.kin.qpp = xpp;

% External excitations
sys.descrip.Fq = F;
sys.descrip.u = F;

% Constraint condition
sys.descrip.is_constrained = false;

% Sensors
sys.descrip.y = x;

% State space representation
sys.descrip.states = [x; xp];

% Kinematic and dynamic model
sys = kinematic_model(sys);
sys = dynamic_model(sys);

% Decay time
m_num = sys.descrip.model_params(1);
b_num = sys.descrip.model_params(2);
k_num = sys.descrip.model_params(3);
T = m_num/b_num;

% Initia conditions [m; m/s]
x0 = [0; 1; 0; 0];

% Final time
tf = 2*pi*sqrt(m_num/k_num);
dt = 0.01;
tspan = 0:dt:tf;

u_eval = @(t, x) u_func(t, x, 1, sys);

% System modelling
sol = validate_model(sys, tspan, x0, u_eval, true);

tspan = tspan';
x = sol';
x = x(:, 1:2);

% Plot properties
titles = {'$x$', '$\dot x$'};
xlabels = {'$t$ [s]', '$t$ [s]'};
ylabels = {'$x$ [m]', '$\dot x$ [m/s]'};
grid_size = [2, 1];

plot_info.titles = titles;
plot_info.xlabels = xlabels;
plot_info.ylabels = ylabels;
plot_info.grid_size = grid_size;

[hfigs_states, hfig_energies] = plot_sysprops(sys, tspan, x, plot_info);

% Energies
saveas(hfig_energies, '../imgs/energies.eps', 'epsc');

% States
for i = 1:length(hfigs_states)
   saveas(hfigs_states(i), ['../imgs/states', num2str(i), '.eps'], 'epsc'); 
end

