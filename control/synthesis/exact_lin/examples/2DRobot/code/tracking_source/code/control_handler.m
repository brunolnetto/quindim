function [u, dz] = control_handler(t, q_p, sestimation_info, ...
                                   trajectory_info, control_info, sys_)
    xhat = source_estimation(t, q_p, sestimation_info, sys_);
    
    [u, dz] = run_control_law(t, q_p, xhat, sestimation_info, ...
                              trajectory_info, control_info, sys_);
end