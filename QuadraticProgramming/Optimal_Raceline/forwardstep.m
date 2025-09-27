function v_next = forwardstep(v_prev, ft_ub, fn_ub, Cd, k_scalar, m, delta_arclen)
    term = (ft_ub - Cd * v_prev ^ 2);
    lateral = m * k_scalar * ((term / fn_ub) ^ 2) * v_prev ^ 2;
    v_next = sqrt( 2 * sqrt(term ^ 2 - lateral ^ 2) * delta_arclen / m + v_prev ^ 2 );
end