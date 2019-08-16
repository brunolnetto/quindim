function sys = constrain_system(sys, A)
    % Coupling matrix
    C = simplify_(null(A));

    [~, m] = size(C);
    
    % Velocities and accelerations
    p = sym('p', [m, 1]);
    pp = sym('pp', [m, 1]);
    
    % Previous and current constraints
    A0 = sys.kin.A;
    A1 = A;
    
    C0 = sys.kin.C;
    C1 = C;
    C0
    C1
    C = C0*C1;
    
    % qp and qpp in terms of quasi-velocities
    Cp = dmatdt(C, sys.kin.q, sys.kin.qp);
    
    sys.kin.A = {A0, A1};
    sys.kin.C = {C0, C1};
    sys.kin.Cp = Cp;
    
    C1p = dmatdt(C1, sys.kin.q, C*p);
    p1p = C1*p + C1p*pp;
    
    sys = update_jacobians(sys, C1);
    
    % Update energies
    sys.dyn.K = subs(sys.dyn.K, sys.kin.p, C1*p);
    sys.dyn.L = subs(sys.dyn.L, sys.kin.p, C1*p);
    sys.dyn.F = subs(sys.dyn.F, sys.kin.p, C1*p);
    sys.dyn.H = C1'*sys.dyn.H*C1;
    invH = inv(sys.dyn.H);
    sys.dyn.M = sys.dyn.H;
    
    sys.dyn.total_energy = subs(sys.dyn.total_energy, sys.kin.p, C1*p);
    sys.dyn.nu = subs(C1'*sys.dyn.nu, sys.kin.p, C1*p);
    sys.dyn.h = subs(C1'*sys.dyn.h, sys.kin.p, C1*p);
    sys.dyn.states = [sys.kin.q; p];
    sys.dyn.W = simplify_(chol(sys.dyn.H, 'lower', 'nocheck'));
    sys.dyn.Z = C1.'*sys.dyn.Z;
    sys.dyn.f = [C*p; -invH*sys.dyn.h + invH*sys.dyn.Z];
    
    sys.dyn.eqdyns = sys.dyn.H*pp + sys.dyn.h == sys.dyn.Z*sys.descrip.u;
    
    if(~iscell(sys.kin.p))
        sys.kin.p = {sys.kin.p};
    end
    
    if(~iscell(sys.kin.pp))
        sys.kin.pp = {sys.kin.pp};
    end
    
    sys.kin.p{end+1} = p;
    sys.kin.pp{end+1} = pp;
end