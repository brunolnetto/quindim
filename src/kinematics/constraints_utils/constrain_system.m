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
    C = C0*C1;
    
    % qp and qpp in terms of quasi-velocities
    Cp = dmatdt(C, sys.kin.q, sys.kin.qp);
    
    sys.kin.As{end+1} = A1;
    sys.kin.Cs{end+1} = C1;
    
    sys.kin.C = sys.kin.C*C1;
    
    sys.kin.Cp = Cp;
    
    C1p = dmatdt(C1, sys.kin.q, C*p);
    p1p = C1*p + C1p*pp;
    
    sys = update_jacobians(sys, C1);

    % Update energies
    sys.dyn.K = subs(sys.dyn.K, sys.kin.p{end}, C1*p);
    sys.dyn.L = subs(sys.dyn.L, sys.kin.p{end}, C1*p);
    sys.dyn.F = subs(sys.dyn.F, sys.kin.p{end}, C1*p);
    sys.dyn.total_energy = subs(sys.dyn.total_energy, sys.kin.p{end}, C1*p);
    
    sys.dyn.h = subs(C1'*sys.dyn.h, sys.kin.p{end}, C1*p);
    sys.dyn.H = C1'*sys.dyn.H*C1;
    sys.dyn.Hp = dmatdt(sys.dyn.H, sys.kin.q, C*p);
    invH = inv(sys.dyn.H);
    
    sys.dyn.states = [sys.kin.q; p];
    sys.dyn.W = simplify_(chol(sys.dyn.H, 'lower', 'nocheck'));
    sys.dyn.Z
    Z = C1.'*sys.dyn.Z;
    sys.dyn.Z = Z;
    
    identity = eye(size(sys.dyn.H));
    
    qp = C*p;
    pp_ = invH*(-sys.dyn.h + sys.dyn.Z*sys.descrip.u);
    dstates = [qp; pp_];
    
    f = [C*p; -invH*sys.dyn.h];
    G = equationsToMatrix(dstates, sys.descrip.u);
    u = sys.descrip.u;

    sys.dyn.plant = f + G*u;
    
    sys.dyn.f = f;
    sys.dyn.G = G;
    sys.dyn.u = u;
    
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