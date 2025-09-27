function [velseq, arc_length] = get_velseq(raceline, centerline, name, m, ft_max, fb_max, fn_max, trackData)

x_ref = raceline(:, 1);
y_ref = raceline(:, 2);
n = numel(x_ref); %number of points in the raceline

x_c = centerline(:,1);
y_c = centerline(:,2);
nc = numel(x_c);

gas = zeros(n, 1);
brake = zeros(n, 1);
arc_length = zeros(n, 1);

gas_c = zeros(n, 1);
brake_c = zeros(n, 1);
arc_length_c = zeros(n, 1);

ft_ub = ft_max * m;
fb_ub = - fb_max * m;
fn_ub = fn_max * m;

Cd = 0.0021 * m; %drag coeffecient

%% For raceline
for i =2:n
    delta_x = x_ref(i) - x_ref(i-1);
    delta_y = y_ref(i) - y_ref(i-1);
    arc_length(i) = arc_length(i-1) + hypot(delta_x, delta_y); %cumulative calc
end

[~, R, ~] = get_curvature([x_ref y_ref]);
k_scalar = 1./R;
k_scalar([1, end]) = 0;
[~, critical_p] = findpeaks(k_scalar);

gas = all_gas(critical_p, gas, arc_length, k_scalar, m, fn_ub, ft_ub, Cd, n);
brake = safedrive(critical_p, brake, arc_length, k_scalar, m, fn_ub, fb_ub, Cd);

velseq = min(gas, brake);

%Lap time calculation
time = zeros(n,1);
for i = 2:n
    delta_arclen = arc_length(i) - arc_length(i-1);   % distance step
    dv2 = velseq(i)^2 - velseq(i-1)^2;
    acc = dv2 / (2*delta_arclen);   % local acceleration
    time(i) = time(i-1) + (velseq(i)-velseq(i-1)) / acc; % integrate time
end

%% For centerline
for i =2:n
    delta_xc = x_c(i) - x_c(i-1);
    delta_yc = y_c(i) - y_c(i-1);
    arc_length_c(i) = arc_length_c(i-1) + hypot(delta_xc, delta_yc);
end

[~, Rc, ~] = get_curvature([x_c y_c]);
kc_scalar = 1./Rc;
kc_scalar([1, end]) = 0;
[~, critical_p_c] = findpeaks(kc_scalar);

gas_c = all_gas(critical_p_c, gas_c, arc_length_c, kc_scalar, m, fn_ub, ft_ub, Cd, nc);
brake_c = safedrive(critical_p_c, brake_c, arc_length_c, kc_scalar, m, fn_ub, fb_ub, Cd);

velseq_c = min(gas_c, brake_c);

%Lap time calculation
time_c = zeros(n,1);
for i = 2:n
    delta_arclen_c = arc_length_c(i) - arc_length_c(i-1);   
    dv2_c = velseq_c(i)^2 - velseq_c(i-1)^2;
    acc_c = dv2_c / (2*delta_arclen_c);   
    time_c(i) = time_c(i-1) + (velseq_c(i)-velseq_c(i-1)) / acc_c; 
end

%% Plot raceline vs centerline side by side
figure;

subplot(1,2,1);
scatter(x_ref, y_ref, 8, velseq, 'filled');
colormap('parula');
colorbar;
axis equal;
xlabel('X [m]'); ylabel('Y [m]');
title('Raceline');
lap_time_race = time(end);
avg_vel_race = mean(velseq);
legend_str = sprintf('Lap Time = %.2f s\nAvg Vel = %.2f m/s', lap_time_race, avg_vel_race);
legend(legend_str,'Location','best');

subplot(1,2,2);
scatter(x_c, y_c, 8, velseq_c, 'filled');
colormap('parula');
colorbar;
axis equal;
xlabel('X [m]'); ylabel('Y [m]');
title('Centerline');
lap_time_center = time_c(end);
avg_vel_center = mean(velseq_c);
legend_str_c = sprintf('Lap Time = %.2f s\nAvg Vel = %.2f m/s', lap_time_center, avg_vel_center);
legend(legend_str_c,'Location','best');


end