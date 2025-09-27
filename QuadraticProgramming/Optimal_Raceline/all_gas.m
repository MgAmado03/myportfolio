function gas = all_gas(critical_p, gas, arc_length, k_scalar, m, fn_ub, ft_ub, Cd, n)

gas(1) = 0;
for i = 2:critical_p(1)
    delta_arclen = arc_length(i) - arc_length(i-1);
    gas(i) = forwardstep(gas(i-1), ft_ub, fn_ub, Cd, k_scalar(i-1), m, delta_arclen);
end

for idx = 1:numel(critical_p)
    
    % critical velocity from lateral acceleration constraint
    v_crit = sqrt(fn_ub / (m * k_scalar(critical_p(idx))));
    
    % clamp velocity at curvature peaks
    if gas(critical_p(idx)) > v_crit
        gas(critical_p(idx)) = v_crit;
    end
    
    % propagate forward from this point
    cur_vel = gas(critical_p(idx));
    delta_arclen = arc_length(critical_p(idx)) - arc_length(critical_p(idx)-1);
    gas(critical_p(idx)) = forwardstep(cur_vel, ft_ub, fn_ub, Cd, k_scalar(critical_p(idx)-1), m, delta_arclen);
    
    % continue forward until next curvature peak
    if idx < numel(critical_p)
        for j = critical_p(idx)+2 : critical_p(idx+1)
            delta_arclen = arc_length(j) - arc_length(j-1);
            gas(j) = forwardstep(gas(j-1), ft_ub, fn_ub, Cd, k_scalar(j-1), m, delta_arclen);
        end
    else
        for j = critical_p(idx)+2 : n
            delta_arclen = arc_length(j) - arc_length(j-1);
            gas(j) = forwardstep(gas(j-1), ft_ub, fn_ub, Cd, k_scalar(j-1), m, delta_arclen);
        end
    end
end
