function sim_ = update_sim(i, sim, mechanism, trajectory)   
    n_bullet = length(mechanism.eqdyn.q_bullet);
    n_circ = length(mechanism.eqdyn.q_circ);

    % First iteration
    if((i == 1) || (i == 2))
        % Instants
        [sim_(:).prev_t] = deal(trajectory.t(1));
        [sim_(:).curr_t] = deal(trajectory.t(2));

%         % Generalized variables
%         q_bullet_0 = trajectory.q(2, :);
%         qp_bullet_0 = trajectory.qp(2, :);
%         qpp_bullet_0 = trajectory.qpp(2, :);
%              
%         % Generalized variables
%         q_bullet_1 = trajectory.q(1, :);
%         qp_bullet_1 = trajectory.qp(1, :);
%         qpp_bullet_1 = trajectory.qp(1, :);
        
        % Generalized variables
        q0_circ = zeros(1, n_circ);
    else
        % Instants
        [sim_(:).prev_t] = deal(trajectory.t(i-1));
        [sim_(:).curr_t] = deal(trajectory.t(i));
        
%         % Generalized variables
%         q_bullet_0 = trajectory.q(i, :);
%         qp_bullet_0 = trajectory.qp(i, :);
%         qpp_bullet_0 = trajectory.qpp(i, :);
%              
%         % Generalized variables
%         q_bullet_1 = trajectory.q(i-1, :);
%         qp_bullet_1 = trajectory.qp(i-1, :);
%         qpp_bullet_1 = trajectory.qp(i-1, :);
%         
%         % Generalized variables
%         q_bullet_2 = trajectory.q(i-2, :);
%         qp_bullet_2 = trajectory.qp(i-2, :);
%         qpp_bullet_2 = trajectory.qp(i-2, :);
        
        q0_circ = sim.q(n_bullet+1:end);
    end
    
    % Current bullet
    q_bullet = trajectory.q(i, :);
    qp_bullet = trajectory.qp(i, :);
    qpp_bullet = trajectory.qp(i, :);
                                               
    [q, qp, p, pp, ~] = q_qp_p(mechanism, ...
                               q0_circ, ...
                               q_bullet, ...
                               qp_bullet, ...
                               qpp_bullet);

    % Main generalized variables
    [sim_(:).q] = deal(q);
    [sim_(:).qp] = deal(qp);
    [sim_(:).p] = deal(p);
    [sim_(:).pp] = deal(pp);

    q_sym = [mechanism.eqdyn.q_circ, mechanism.eqdyn.q_bullet];
    qp_sym = [mechanism.eqdyn.qp_circ, mechanism.eqdyn.qp_bullet];
    p_sym = [mechanism.eqdyn.p_circ, mechanism.eqdyn.p_bullet];
    
    q_num = q;
    qp_num = qp;
    p_num = p;

    
%     % Evaluated variables
%     [q_2, ~, ~, ~, ~] = q_qp_p(mechanism, ...
%                                q0_circ, ...
%                                q_bullet_2, ...
%                                qp_bullet_2, ...
%                                qpp_bullet_2);
%     
%     [q_1, ~, ~, ~, ~] = q_qp_p(mechanism, ...
%                                q0_circ, ...
%                                q_bullet_1, ...
%                                qp_bullet_1, ...
%                                qpp_bullet_1);
%     
%     [q_0, ~, ~, ~, ~] = q_qp_p(mechanism, ...
%                                q0_circ, ...
%                                q_bullet_0, ...
%                                qp_bullet_0, ...
%                                qpp_bullet_0);
    
%     % Cp - Euler approximation
%     [~, C_2, ~] = coupling_matrixC(mechanism, q_2);
%     [~, C_1, ~] = coupling_matrixC(mechanism, q_1);
%     [~, C_0, ~] = coupling_matrixC(mechanism, q_0);
% 
%     delta_t = sim_.curr_t - sim_.prev_t;
%     Cp = (1.5*C_2 - 2*C_1 + 0.5*C_0)/delta_t;

    [~, C, ~] = coupling_matrixC(mechanism, q);
    
    Jac_bullet = double(subs(mechanism.eqdyn.Jac_bullet, q_sym, q_num));
    Jacp_bullet = double(subs(mechanism.eqdyn.Jacp_bullet, ...
                         [q_sym, p_sym], [q_num, p_num]));
    Jac_circ = double(subs(mechanism.eqdyn.Jac_circ, q_sym, q_num));
    Jacp_circ = double(subs(mechanism.eqdyn.Jacp_circ, ...
                       [q_sym, p_sym], [q_num, p_num]));
    D_bullet = double(subs(mechanism.eqdyn.D_bullet, ....
                           q_sym, q_num));
    Dp_bullet = double(subs(mechanism.eqdyn.Dp_bullet, ....
                            [q_sym, p_sym], [q_num, p_num]));
    D_circ = double(subs(mechanism.eqdyn.D_circ, q_sym, q_num));
    Dp_circ = double(subs(mechanism.eqdyn.Dp_circ, ...
                          [q_sym, p_sym], [q_num, p_num]));   
    
    
    Cp = zeros(size(C));
    
    [sim_(:).C] = deal(C);
    [sim_(:).Cp] = deal(Cp);
    
    % Main points of mechanism
    sim_.points = eval_points(mechanism, q);
        
    % First iteration
    if(isempty(fieldnames(sim)))
        [sim_(:).q_error] = deal(0);
        [sim_(:).constraints_error] = deal(0);
    else
        sim_.q_error = deal(norm(sim.q - sim_.q));
    
        % Constraints error
        n = length(mechanism.constraints);

        consts = [];
        for j = 1:n
            consts = [consts; mechanism.constraints{j}];
        end
        
        [sim_(:).constraints_error] = deal(norm(double(subs(consts, q_sym, q_num))));

    end

    % Actions of actuators
    Mtilde = double(subs(mechanism.eqdyn.M_decoupled, q_sym, q_num));
    Utilde = double(subs(mechanism.eqdyn.U_decoupled, q_sym, q_num));
    nutilde = double(subs(mechanism.eqdyn.nu_decoupled, ...
                          [q_sym, qp_sym, p_sym], ...
                          [q_num, qp_num, p_num]));
    gtilde = double(subs(mechanism.eqdyn.g_decoupled, q_sym, q_num));
                                      
    M = double(Mtilde);
    U = double(Utilde);
    nu = double(nutilde);
    g = double(gtilde);
    
    p_bullet_ = p(1:n_bullet);
    pp_bullet_ = pp(1:n_bullet);
    
    % Main action variables
    H = double(C.'*M*C);
    Z = double(C.'*U);
        
    h = double(C.'*(M*Cp*p_bullet_.' + nu - g));
    
    u = double(pinv(Z)*(H*pp_bullet_.' + h));
    [sim_(:).u] = deal(u);
end