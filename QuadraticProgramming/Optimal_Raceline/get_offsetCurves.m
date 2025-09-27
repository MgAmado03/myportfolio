function [xin, yin, xout, yout] = get_offsetCurves(x, y, width_rf, width_lf)
n = numel(x);
dx = gradient(x);
dy = gradient(y);
dL = hypot(dx, dy); %for normalization

xin = zeros(n,1);
yin = zeros(n,1);
xout = zeros(n,1);
yout = zeros(n,1);

% get offset curves
for i = 1:n
    nx = -dy(i)/dL(i);   
    ny =  dx(i)/dL(i);  

    % inner
    xin(i) = x(i) + nx*width_rf(i);   
    yin(i) = y(i) + ny*width_rf(i);
    
    % outer
    xout(i) = x(i) - nx*width_lf(i);  
    yout(i) = y(i) - ny*width_lf(i);
end
end
