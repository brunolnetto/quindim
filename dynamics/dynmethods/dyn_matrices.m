function sys = dyn_matrices(sys, helper)
    u = sys.descrip.u;
    
    % Nummerical energies 
    C = sys.kin.C;
    p = sys.kin.p{1};
    pp = sys.kin.pp{1};
    
    Cp = helper.Cp;
    
    % New and old time derivative variables
    qp_ = C*p;
    qpp_ = C*pp + Cp*p;
    
    qp = sys.kin.qp;
    qpp = sys.kin.qpp;
    
    % Dynamic matrices of a mechanical system
    sys.dyn.M = simplify_(mass_matrix(sys, helper));
    sys.dyn.g = simplify_(gravitational(sys, helper));
    sys.dyn.f = simplify_(friction(sys, helper));
    sys.dyn.U = simplify_(-jacobian(helper.l_r, u));
    
    temp = subs(C.'*(helper.ddt_dL_dqp - helper.dKdq), ...
                [qp; qpp], [qp_; qpp_]);
    
    
    sys.dyn.nu = simplify_(temp - sys.dyn.M*sys.kin.pp);
    
    % Control dynamic matrices
    sys.dyn.H = sys.dyn.M;
    sys.dyn.h = simplify_(sys.dyn.nu + sys.dyn.g + sys.dyn.f);
    sys.dyn.Z = simplify_(sys.dyn.U);
end
