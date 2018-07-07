function [thetahat] =  OPS_epsdelta_conservative(X,y,opts)
% eps,delta calibration for OPS 

    epsilon=opts.eps;
    delta=opts.delta;
    [n,d]= size(X);
    XTy = X'*y;
    XTX = X'*X + eye(d);
    
    
    xb=1; yb=1;
    
    
    C1_fun = @(eps,del,rho,dd) (dd/2+sqrt(dd*log(1/rho)) + log(1/rho))*log(2/del)/eps^2;
    varrho = 0.05;
    C1=C1_fun(min(epsilon/2,sqrt(epsilon/2)),delta,varrho,d);
    
    % calibrate noise by minimizing the worst case prediction error
    lamb = max(sqrt( C1* xb^2),(1+log(2/delta))*xb^2/epsilon);
    
    theta_bound = min(sqrt(n)*yb/sqrt(2*lamb), n*xb*yb/lamb);
    L = xb*(theta_bound*xb + yb);
    
    % quadratic coefficients
    a = L^2/(lamb+xb^2);
    b = L*sqrt(log(2/delta)/lamb);
    c = (1+log(2/delta))*xb^2/2/lamb - epsilon;
    
    % guaranteed to be positive by our choice of lamb.
    sqrtgamma = (-b + sqrt(b^2-4*a*c) )/(2*a);
    
    % solve ridge regression
    H = XTX + lamb*eye(d);
    R=chol(H);% do cholesky decomposition H = R'*R
    theta = R\((R')\XTy);
    
    % output the OPS sample within the bound
    thetahat =  theta + (R')\randn(d,1)/sqrtgamma;
