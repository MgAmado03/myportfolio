function [L, R, k] = get_curvature(arc)
% k is the curvature vector, scalar is 1./R

N = size(arc, 1);
dims = size(arc, 2);

if dims ==2
    arc = [arc, zeros(N,1)];
end

L = zeros(N, 1);
R = NaN(N,1);
k = NaN(N, 3);

for i = 2:N-1
    [R(i),~,k(i,:)] = circumcenter(arc(i,:)',arc(i-1,:)',arc(i+1,:)');
    L(i) = L(i-1)+norm(arc(i,:)-arc(i-1,:));
end
if norm(arc(1,:)-arc(end,:)) < 1e-10 % Closed curve. 
  [R(1),~,k(1,:)] = circumcenter(arc(end-1,:)',arc(1,:)',arc(2,:)');
  R(end) = R(1);
  k(end,:) = k(1,:);
  L(end) = L(end-1) + norm(arc(end,:)-X(end-1,:));
end
i = N;
L(i) = L(i-1)+norm(arc(i,:)-arc(i-1,:));
if dims == 2
  k = k(:,1:2);
end
end

