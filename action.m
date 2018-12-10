function u = action(mechanism, q_bullet, qp_bullet, qpp_bullet)
    
    % Speed to derivative coordinates conversion
    D_bullet = subs(mechanism.D_bullet, ...
                    mechanism.q_bullet, ...
                    q_bullet);
    
    Dp_bullet = subs(mechanism.Dp_bullet, ...
                     [mechanism.q_bullet, mechanism.qp_bullet], ...
                     [q_bullet, qp_bullet]);

    % Dependent coordinates
    q_circ_ = q_circ(mechanism, q_bullet);
    
    % Dependent speeds
    p_circ_ = p_circ(mechanism, q_bullet, qp_bullet);
    
    % Independent speed
    p_bullet = D_bullet*qp_bullet;
    
    % Indepedent acceleration
    pp_bullet = D_bullet*qpp_bullet.' + Dp_bullet*qp_bullet.';
    pp_bullet = pp_bullet.';
    
    % Main evaluation matrices
    C = mechanism.C;
    M = C.'*mechanism.eqdyn.M_uncoupled;
    U = C.'*mechanism.eqdyn.U_uncoupled;
    nu = C.'*mechanism.eqdyn.nu_uncoupled;
    g = C.'*mechanism.eqdyn.g_uncoupled;
    
    q_sym = [mechanism.q_bullet, mechanism.q_circ];
    q_num = [q_bullet_, q_circ_];
    
    qp_sym = [mechanism.qp_bullet, mechanism.qp_circ];
    qp_num = [qp_bullet_, qp_circ_];
        
    % Nummeric evaluation of Cp
    % Proposition: Change for other preciser derivatives
    t_prev = mechanism.simulation.previous_time;
    t_curr = mechanism.simulation.current_time;
    delta_t = t_curr - t_prev;
    
    % Euler approximation
    C_prev = mechanism.simulation.C_prev(end);
    C_curr = subs(mechanism.eqdyn.C, [q_sym, qp_sym], [q_num, qp_num]);
    Cp = (C_curr - C_prev)/delta_t;
    
    % Main action variables
    H = C.'*M*C;
    Z = C.'*U;
    h = C.'*(M*Cp*bullet + nu - g);
    
    u = pinv(Z)*(H*pp_bullet.' + h);
end