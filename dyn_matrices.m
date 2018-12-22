function [M, g, f, nu, U, H, h, Z] = dyn_matrices(sys)
    qpp = sys.qpp;
    u = sys.u;
    
    % Dynamic matriced of a mechanical system
    M = mass_matrix(sys);
    g = gravitational(sys);
    f = friction(sys);
    U = -jacobian(sys.l_r, u);
    nu = sys.l_r - M*qpp - g - f + U*u;
    
    % Control dynamic matrices
    H = M;
    h = nu + g + f;
    Z = U;
end