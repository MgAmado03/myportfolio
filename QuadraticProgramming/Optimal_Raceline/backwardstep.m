function v_prev = backwardstep(v_next, fb_ub, fn_ub, Cd, k_scalar, m, delta_arclen)
    term = (fb_ub - Cd*v_next^2);
    lateral = m*k_scalar*((term/fn_ub)^2) * v_next^2;
    v_prev = sqrt( 2*sqrt(term^2 - lateral^2)*delta_arclen/m + v_next^2 );
end