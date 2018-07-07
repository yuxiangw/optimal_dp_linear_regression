function [thetahat] =  suffstats_perturb(X,y,opts)

    epsilon=opts.eps;
    delta=opts.delta;
    
    
    [n,d]= size(X);
    XTy = X'*y;
    XTX = X'*X + eye(d);
    
    
    XTyhat = XTy + (sqrt(log(4/delta))/epsilon)*randn(d,1);
    XTXhat = XTX + (sqrt(log(4/delta))/epsilon)*randn(d,d);
    
    thetahat = XTXhat\XTyhat;
    
    
    
    