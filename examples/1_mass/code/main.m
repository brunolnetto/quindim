% Author: Senzu
% Date: 08/01/19
clear all
close all
clc

% Load model
run('./load_model.m');

% Run simulation
run('./run_sim.m');

% Run plot script
run('./run_plot.m');

% Run robot animation
run('./run_animation.m');
