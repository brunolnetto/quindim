ell_val = sqrt(ell2);

x_part = L_f*cos(beta_);
y_part = L_c*sin(beta_);
beta_g_val = atan2(y_part, x_part);

scaler_g_val = subs(simplify_(radius_s*sin(beta_)/ell), ell, ell_val);

sys.kin.As = {subs(sys.kin.As, ...
                   [ell, beta_g, scaler_g], ...
                   [ell_val, beta_g_val, scaler_g_val])};
sys.kin.Cs = {subs(sys.kin.Cs, ...
                   [ell, beta_g, scaler_g], ...
                   [ell_val, beta_g_val, scaler_g_val])};
sys.kin.A = subs(sys.kin.A, ...
                 [ell, beta_g, scaler_g], ...
                 [ell_val, beta_g_val, scaler_g_val]);
sys.kin.C = subs(sys.kin.C, ...
                 [ell, beta_g, scaler_g], ...
                 [ell_val, beta_g_val, scaler_g_val]);

sys = dynamic_model(sys);
