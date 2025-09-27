function [H, B, Aeq, beq, lb, ub] = defineQP(xin, yin, delx, dely, n)

H = zeros(n);
B = zeros(1, n);

for i=2:n-1
       % Build Hessian H (quadratic cost terms)
       H(i-1,i-1) = H(i-1,i-1) + delx(i-1)^2 + dely(i-1)^2;
       H(i-1,i)   = H(i-1,i)   - 2*(delx(i-1)*delx(i) + dely(i-1)*dely(i));
       H(i-1,i+1) = H(i-1,i+1) + delx(i-1)*delx(i+1) + dely(i-1)*dely(i+1);
       H(i,i-1)   = H(i,i-1)   - 2*(delx(i-1)*delx(i) + dely(i-1)*dely(i));
       H(i,i)     = H(i,i)     + 4*(delx(i)^2 + dely(i)^2);
       H(i,i+1)   = H(i,i+1)   - 2*(delx(i)*delx(i+1) + dely(i)*dely(i+1));
       H(i+1,i-1) = H(i+1,i-1) + delx(i-1)*delx(i+1) + dely(i-1)*dely(i+1);
       H(i+1,i)   = H(i+1,i)   - 2*(delx(i)*delx(i+1) + dely(i)*dely(i+1));
       H(i+1,i+1) = H(i+1,i+1) + delx(i+1)^2 + dely(i+1)^2;

       % Build linear term B (gradient vector)      
       cx = xin(i+1)+xin(i-1)-2*xin(i);  % curvature approximation in x
       cy = yin(i+1)+yin(i-1)-2*yin(i);  % curvature approximation in y
       
       B(i-1) = B(i-1) + 2*(cx*delx(i-1) + cy*dely(i-1));
       B(i)   = B(i)   - 4*(cx*delx(i)   + cy*dely(i));
       B(i+1) = B(i+1) + 2*(cx*delx(i+1) + cy*dely(i+1));
end

%constraints
lb = zeros(n,1);               
ub = ones(n,1);                

Aeq      = zeros(1,n);         
Aeq(1)   = 1;                  
Aeq(end) = -1;                 
beq      = 0;    
end