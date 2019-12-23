t = t';
sol = sol';

% Generalized coordinates
plot_info_q.titles = repeat_str('', 4);
plot_info_q.xlabels = {'$t$ [s]', '$t$ [s]', '$t$ [s]', '$t$ [s]'};
plot_info_q.ylabels = {'$x$', '$y$', '$\theta$', '$\phi$'};
plot_info_q.grid_size = [2, 2];

% States plot
hfigs_states = my_plot(t, sol(:, 1:4), plot_info_q);

% xy-coordinates
hfigs_states_xy = my_figure();
plot(sol(:, 1), sol(:, 2));
hold on;
plot(xhat_t(:, 1), xhat_t(:, 2), 'ko');
hold off;

xlabel('$x$ [m]', 'interpreter', 'latex');
ylabel('$y$ [m]', 'interpreter', 'latex');

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info_p.ylabels = {'$\omega_{\theta}$', '$\omega_{\phi}$'};
plot_info_p.grid_size = [2, 1];

% Speeds plot
hfigs_speeds = my_plot(t, sol(:, 5:6), plot_info_p);

plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = {'$t$ [s]', '$t$ [s]'};
plot_info_p.ylabels = {'$\tau_{\theta}$', '$\tau_{\phi}$'};
plot_info_p.grid_size = [2, 1];

% Control plot
hfigs_u = my_plot(tu_s, u_s, plot_info_p);

plot_info_p.titles = {''};
plot_info_p.xlabels = {'$t$ [s]'};
plot_info_p.ylabels = {'Sinal de campo []'};
plot_info_p.grid_size = [1, 1];

% Readings plot
hfigs_readings = my_plot(t_readings, readings, plot_info_p);

model_params = sys.descrip.model_params;
syms_plant = sys.descrip.syms;

q = sys.kin.q;
p = sys.kin.p{end};

H = sys.dyn.H;
C = sys.kin.C;
x = sys.kin.q(1:2);
h = sys.dyn.h;
u = sys.descrip.u;
Z = sys.dyn.Z;

x_hat = sym('xhat_', size(x));
p_hat = sym('phat_', size(x));
pp = inv(H)*(Z*u - h);

P = eye(length(x));

e_x = x - x_hat;
e_p = p - p_hat;

V = 0.5*e_p.'*H*e_p + 0.5*e_x.'*P*e_x;

qp_s = [q; p];

n_t = length(t_s);

Vs = zeros(n_t-1, 1);
for i = 1:(n_t-1)
    t_i = t_s(i);

    xhat_i = xhat_t(i, :);
    phat_i = phat_t(i, :);
    
    symbs = [qp_s; syms_plant.'; x_hat; p_hat];
    vals = [sol(i, :)'; model_params'; xhat_i'; phat_i'];
    
    Vs(i) = subs(V, symbs, vals);
end

% Readings plot
plot_info_p.titles = {''};
plot_info_p.xlabels = {'$t$ [s]'};
plot_info_p.ylabels = {'Ljapunov function $V(q, p)$'};
plot_info_p.grid_size = [1, 1];

t_V = t_s(1:end-1);
hfigs_ljapunov = my_plot(t_V, Vs, plot_info_p);

% Estimations plot
plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = repeat_str('$t$ [s]', 2);
plot_info_p.ylabels = {'$\hat{x}(t)$', '$\hat{y}(t)$'};
plot_info_p.grid_size = [2, 1];

tt = linspace(t(1), t(end), length(phat_t));
hfigs_xhat = my_plot(tt, xhat_t, plot_info_p);

% Estimation speed plot
plot_info_p.titles = repeat_str('', 2);
plot_info_p.xlabels = repeat_str('$t$ [s]', 2);
plot_info_p.ylabels = {'$\dot{\hat{x}}(t)$', '$\dot{\hat{y}}t)$'};
plot_info_p.grid_size = [2, 1];

tt = linspace(t(1), t(end), length(phat_t));
hfigs_phat = my_plot(tt, phat_t, plot_info_p);

saveas(hfig_states, './imgs/states.eps', 'epsc');
saveas(hfigs_states_xy, './imgs/states_xy.eps', 'epsc');
saveas(hfig_speeds, './imgs/speeds.eps', 'epsc');
saveas(hfigs_u, './imgs/control.eps', 'epsc');
saveas(hfigs_readings, './imgs/readings.eps', 'epsc');
saveas(hfigs_ljapunov, './imgs/ljapunov.eps', 'epsc');
saveas(hfigs_xhat, './imgs/xhats.eps', 'epsc');
saveas(hfigs_phat, './imgs/phats.eps', 'epsc');