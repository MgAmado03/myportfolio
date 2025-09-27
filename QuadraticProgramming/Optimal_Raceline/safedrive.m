function brake = safedrive(critical_p, brake, arc_length, k_scalar, m, fn_ub, fb_ub, Cd)

n = numel(arc_length);      
brake(end) = 200;            

for j = n-1:-1:critical_p(end)
    delta_arclen = arc_length(j+1) - arc_length(j);
    brake(j) = backwardstep(brake(j+1), fb_ub, fn_ub, Cd, k_scalar(j+1), m, delta_arclen);
end

for idx = numel(critical_p):-1:1
    
    % critical velocity due to lateral acceleration
    v_crit = sqrt(fn_ub / (m * k_scalar(critical_p(idx))));
    
    % clamp velocity at peak
    if brake(critical_p(idx)) > v_crit
        brake(critical_p(idx)) = v_crit;
    end
    
    % propagate backward one step from the peak if possible
    cur_vel = brake(critical_p(idx));
    if critical_p(idx) > 1
        delta_arclen = arc_length(critical_p(idx)) - arc_length(critical_p(idx)-1);
        brake(critical_p(idx)-1) = backwardstep(cur_vel, fb_ub, fn_ub, Cd, k_scalar(critical_p(idx)), m, delta_arclen);
    end
    
    % propagate backward until previous critical point or start
    if idx > 1
        start_idx = critical_p(idx-1);
    else
        start_idx = 1;
    end
    
    for j = critical_p(idx)-2:-1:start_idx
        delta_arclen = arc_length(j+1) - arc_length(j);
        brake(j) = backwardstep(brake(j+1), fb_ub, fn_ub, Cd, k_scalar(j+1), m, delta_arclen);
    end
end