function [thetahat] =  OPS_epsdelta_diffused(X,y,opts)
    % OPS-diffused. Choose the smallest possible lambda


    epsilon=opts.eps;
    delta=opts.delta;
    [n,d]= size(X);
    XTy = X'*y;
    XTX = X'*X + eye(d);
    
    
    xb=1; yb=1;
    % calibrate noise by minimizing the prediction error
    lamb = (1+log(2/delta))*xb^2/epsilon;
    
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
