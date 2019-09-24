function result = invtriang_ineq(expr, x, label, symbs, params_lims, is_min)
    expr = expand(expr);
    expr_strip = strsplit(char(expr));
    
    i = 1:length(expr_strip);

    goal = 'Minoration';
    
    exprs = expr_strip(mod(i, 2) ~= 0);
    bounded_funcs = {'sin', 'cos'};
    wb_outer = my_waitbar([label, ' - ', goal]);
    
    expr_x_ = sym(1);
    exprs_x_acc = sym([]);
    
    params_1 = sym(0);
    params_others = sym(0);
    
    funcs_base = [];
    exprs_i_acc = [];
    
    % Numerator expression
    expr_inf = sym(0);
    for i = 1:length(exprs)
        expr_ = exprs(i);
        monomes = strsplit(char(expr_), '*');

        expr_sym = sym(1);
        expr_x = sym(1);
        
        no_x = true;
        
        i = 1;
        for monome = monomes
            monome_sym = sym(monome);
            monome_vars = symvar(monome_sym);
            
            is_not_x = ~all(ismember(monome_vars, x));
            
            % Parameters of the plant
            if(is_not_x || isempty(monome_vars))
                expr_sym = sym(expr_sym*monome);
            
            else
                expr_x = sym(expr_x*monome_sym);      
                no_x = false;
            end
        end
        
        expr_i = abs(sym(expr_sym)*sym(expr_x));
        expr_x_ = simplify_(expr_/expr_sym);
        
        if(isempty(find(funcs_base == simplify_(expr_x_), 1)))
            exprs_i_acc = [exprs_i_acc, sym(0)];
            funcs_base = [funcs_base, expr_x_];
        end
        
        idx = find(funcs_base == simplify_(expr_x_));
        
        exprs_i_acc(idx) = exprs_i_acc(idx) + expr_sym;
        wb_outer = wb_outer.update_waitbar(i, length(exprs));
        
        i = i+1;
        
        if(no_x)
            params_1 = params_1 + expr_sym;
        else
            params_others = params_others + expr_sym;
        end
    end
    
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    
    result = 0;
    
    func_opt = abs(abs(params_1) - abs(params_others));
    
    if(~is_min)
        func_opt = -func_opt;
    end
    
    func_obj = @(params) func_opt(params, func_opt, symbs);
    
    params0 = (params_min + params_max)/2;
    options = optimoptions('fmincon','Algorithm','interior-point');
    
    % run interior-point algorithm
    options = optimoptions('fmincon');
    [opt_params, result] = fmincon(func_obj_1, params0, [], [], [], [], ...
                                    params_min, params_max, func_cond, ...
                                    options);
    if(~is_min)
        result = -result;
    end
    
    wb_outer.close_window();
end

function obj = func_opt(params, fval, symbs)
    obj = double(subs(fval, symbs, params));
end

function [conds, ceq] = func_bounds(params, params_lims)
    params_min = params_lims(:, 1);
    params_max = params_lims(:, 2);
    conds = [params_min - params; params - params_max];
    ceq = [];
end
