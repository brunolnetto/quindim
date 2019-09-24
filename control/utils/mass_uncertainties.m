function [D, I_m_tilde, Ms_hat] = mass_uncertainties(Ms, q_p, params_syms, params_lims)
    
    n = length(Ms);
    
    % Parameter boundaries
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    
    Ms_min = subs(Ms, params_syms, params_min);
    Ms_max = subs(Ms, params_syms, params_max);
    
    % inv(Mu) = I + inv(Ms_hat)
    % Mu = I + Ms_hat
    Mu = Ms_max/Ms_min;
    Mu_1 = inv(Mu);
    Ms_hat = sqrt(Ms_max*Ms_min);
    
    % D calculation
    D_Mu_sq_sup = supinf_matrix(Mu, q_p, params_syms, params_lims, 0);
    D_Mu_1_sq_sup = supinf_matrix(Mu_1, q_p, params_syms, params_lims, 0);
    
    D_Mu_sup = abs(-eye(n) + sqrt(D_Mu_sq_sup));
    D_Mu_1_sup = abs(-eye(n) + sqrt(D_Mu_1_sq_sup));
    D_Mu_sup = double(D_Mu_sup);
    D_Mu_1_sup = double(D_Mu_1_sup);
        
    for i = 1:n
        for j = 1:n
            if(D_Mu_sup(i, j) > D_Mu_1_sup(i, j))
                D(i, j) = D_Mu_sup(i, j);
            else
                D(i, j) = D_Mu_1_sup(i, j);
            end
        end
    end
    
    % Dtilde calculation
    D_Mu_sq_inf = supinf_matrix(Mu, q_p, params_syms, params_lims, 1);
    D_Mu_1_sq_inf = supinf_matrix(Mu_1, q_p, params_syms, params_lims, 1);
    
    D_Mu_inf = abs(sqrt(D_Mu_sq_inf));
    D_Mu_1_inf = abs(sqrt(D_Mu_1_sq_inf));
    D_Mu_inf = double(D_Mu_inf);
    D_Mu_1_inf = double(D_Mu_1_inf);
    
    for i = 1:n
        for j = 1:n
            if(D_Mu_inf(i, j) < D_Mu_1_inf(i, j))
                D(i, j) = D_Mu_inf(i, j);
            else
                D(i, j) = D_Mu_1_inf(i, j);
            end
        end
    end
end

function D = supinf_matrix(matrix, q_p, params_syms, params_lims, is_min)
    % Parameter limits
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    
    n = length(matrix);
    
    % Initialization
    D = sym(zeros(n));
    
    for i = 1:n
        for j = 1:n
            a_ij = matrix(i, j);

            [num, den] = numden(expand(a_ij));
            
            label = sprintf('(%d, %d)', i, j);
            
            if(is_min)
                % Numerator and denominator for D matriq_p
                num_lim = abs_func_min(num, q_p, label, params_syms);
                den_lim = abs_func_maj(den, q_p, label, ...
                                       params_lims, params_syms); 
            else
                % Numerator and denominator for D matriq_p
                num_lim = abs_func_max(num, q_p, label, params_syms);
                den_lim = abs_func_min(den, q_p, label, ...
                                       params_lims, params_syms);
            end
            
            D(i, j) = num_lim/den_lim;
        end
    end
end