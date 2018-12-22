<<<<<<< HEAD
function [A, C, C_hat] = coupling_matrixC(mechanism, q)
=======
function [A, C, Chat] = coupling_matrixC(mechanism, q)
>>>>>>> 7c70559cb71243c91bd5d9fc8e8791e53a3a6a0c
    n_bullet = length(mechanism.eqdyn.q_bullet);
    n_circ = length(mechanism.eqdyn.q_circ);
    
    if(n_bullet + n_circ ~= length(q))
        error('The dimensions of q_bullet plus q_circ MUST be equal to dimension of provided q')        
    end

    % Jacobians
    Jac_bullet = double(subs(mechanism.eqdyn.Jac_bullet, ...
                             [mechanism.eqdyn.q_bullet, ...
                              mechanism.eqdyn.q_circ], q));
    Jac_circ = double(subs(mechanism.eqdyn.Jac_circ, ...
                           [mechanism.eqdyn.q_bullet, ...
                            mechanism.eqdyn.q_circ], q));
   
    % Generalized speed to coordinates derivatives
    D_bullet = double(subs(mechanism.eqdyn.D_bullet, ...
                    mechanism.eqdyn.q_bullet, q(1:n_bullet)));
    D_circ = double(subs(mechanism.eqdyn.D_circ, ...
                  mechanism.eqdyn.q_circ, q(n_bullet+1:end)));
    
    % Coupling matrix
    Chat = -(D_circ\Jac_circ)*Jac_bullet*pinv(D_bullet);

    C = [eye(n_bullet); Chat];
    A = [Jac_bullet*pinv(D_bullet), Jac_circ*pinv(D_circ)];
end