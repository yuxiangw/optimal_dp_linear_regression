function [thetahat] =  OPS_epsdelta_concentrated(X,y,opts)
% OPS-concentrated.


    epsilon=opts.eps;
    delta=opts.delta;
    [n,d]= size(X);
    XTy = X'*y;
    XTX = X'*X + eye(d);
    
    xb=1; yb=1;
    
    
    % calibrate noise by adding regularization
    gamma = 1;
    
    % quadratic coefficients
    a = epsilon;
    b = -  sqrt(gamma*2*n*xb^4*yb^2*log(2/delta)) - (1+log(2/delta))*xb^2/2;
    c = - 2*n*xb^4*yb^2;
    
    % solve for lambda
    lamb = (-b + sqrt(b^2-4*a*c) )/(2*a);
    
    % verify that the solution really is in the valid range, if not, do
    % something else.
    if lamb > n*xb^2/2
        L = 2*xb*yb;
        
        a = epsilon;
        b = -sqrt(gamma*L^2*log(2/delta));
        c = -gamma*L&2/2 - (1+log(2/delta))*xb^2/2;
        
        sqrtlamb = (-b + sqrt(b^2-4*a*c) )/(2*a);
        lamb = sqrtlamb^2;
        
    end
    
    % solve ridge regression
    H = XTX + lamb*eye(d);
    R=chol(H);% do cholesky decomposition H = R'*R
    theta = R\((R')\XTy);

    % output the OPS sample within the bound
    thetahat =  theta + (R')\randn(d,1)/sqrt(gamma);
     
