clear all
close all 
clc

filepath = '~/github/Robotics4fun/examples';
filenames_code = genpath_code(filepath);

CLEAR_ALL = false;

for i = 1:length(filenames_code)
    disp(filenames_code{i});
    run([filenames_code{i}, '/main.m']); 
end
