function [R,M,k] = circumcenter(A,B,C)
  D = cross(B-A,C-A);
  b = norm(A-C);
  c = norm(A-B);
  if nargout == 1
    a = norm(B-C);     % slightly faster if only R is required
    R = a*b*c/2/norm(D);
    return
  end
  E = cross(D,B-A);
  F = cross(D,C-A);  
  G = (b^2*E-c^2*F)/norm(D)^2/2;
  M = A + G;
  R = norm(G);  % Radius of curvature
  if R == 0
    k = G;
  else
    k = G'/R^2;   % Curvature vector
  end
end