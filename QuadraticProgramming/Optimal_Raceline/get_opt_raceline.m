function [raceline, final_centerline, x_in, y_in, x_out, y_out] = get_opt_raceline(track, track_name)
%% Data treatment
pos_x = track(:,1);
pos_y = track(:,2);
width_r = track(:,3);
width_l = track(:,4);

centerline = [pos_x pos_y];

num_segments = 1500;

[pos_xf, pos_yf, width_rf, width_lf, final_centerline] = evenSampler(centerline, width_r, width_l, num_segments);

[x_in, y_in, x_out, y_out] = get_offsetCurves(pos_xf, pos_yf, width_rf, width_lf);


%% Plot centerline and offset curves
plot(pos_xf, pos_yf,'g')
hold on

plot(x_in,y_in,'color','b','linew', 2)
plot(x_out,y_out,'color','r','linew',2)
hold off
axis equal

xlabel('x(m)','fontweight','bold','fontsize',14)
ylabel('y(m)','fontweight','bold','fontsize',14)
title(sprintf(track_name),'fontsize',16)

%% QP
x_range = x_out - x_in;
y_range = y_out - y_in;
n = numel(x_range); % number of segments between inner and outer offset curves

[H, B, Aeq, beq, lb, ub] = defineQP(x_in, y_in, x_range, y_range, n);

options = optimoptions('quadprog', 'Display','none');
opt_ratio = quadprog(2*H, B', [], [], Aeq, beq, lb, ub, [], options);

opt_x = x_in + opt_ratio(:).* x_range;
opt_y = y_in + opt_ratio(:).* y_range;

raceline = [opt_x opt_y];

%% Plot raceline
figure; hold on; axis equal
plot(raceline(:,1), raceline(:,2),'r','LineWidth',2)        
plot([x_in(1) x_out(1)], [y_in(1) y_out(1)],'g','LineWidth',2) 
plot(pos_xf,pos_yf,'k--')                     
plot(x_in,y_in,'k')                                        
plot(x_out,y_out,'k')                                       
xlabel('x (m)','FontWeight','bold','FontSize',14)
ylabel('y (m)','FontWeight','bold','FontSize',14)
title(sprintf('%s - Minimum Curvature Trajectory',track_name),'FontSize',16)
hold off
end


