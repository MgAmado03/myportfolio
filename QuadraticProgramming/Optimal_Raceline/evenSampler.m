function [xf, yf, wrf, wlf, final_line] = evenSampler(line, wr, wl, num_points)

seg_lenght = sqrt(sum(diff(line, [], 1).^ 2, 2));
seg_length = [0;
              seg_lenght];
total_length = cumsum(seg_length);

steps_loc = linspace(0, total_length(end), num_points);
final_line = interp1(total_length, line, steps_loc);

xf = final_line(:, 1);
yf = final_line(:, 2);
wrf = interp1(total_length, wr, steps_loc, 'spline')';
wlf = interp1(total_length, wl, steps_loc, 'spline')';

end