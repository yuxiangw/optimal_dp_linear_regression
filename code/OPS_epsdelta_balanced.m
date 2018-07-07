function [thetahat] =  OPS_epsdelta_balanced(X,y,opts)
% OPS-balanced.


    epsilon=opts.eps;
    delta=opts.delta;
    [n,d]= size(X);
    XTy = X'*y;
    XTX = X'*X + eye(d);
    
    
    xb=1; yb=1;
    
    
    C1_fun = @(eps,del,rho,dd) (dd/2+sqrt(dd*log(1/rho)) + log(1/rho))*log(2/del)/eps^2;
    varrho = 0.05;
    C1=C1_fun(min(epsilon/2,sqrt(epsilon/2)),delta,varrho,d);
    
    thetastar_bound = 1;
    
    % calibrate noise by minimizing the prediction error
    lamb  =  ( C1 *xb^4*yb^2*n / 2 / thetastar_bound^2  )^(1/3);
    lamb = max(lamb,(1+log(2/delta))*xb^2/epsilon);
    
    % now, recalibrate.
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
