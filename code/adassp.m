function [thetahat] =  adassp(X,y,opts)
    BX = 1;
    BY = 1;
   
    epsilon=opts.eps;
    delta=opts.delta;
    
    [n,d]= size(X);
        
    varrho=0.05;
    
    % set the eigenvalue limit
    eta = sqrt(d*log(6/delta)*log(2*d^2/varrho))*BX^2/(epsilon/3);
    
    XTy = X'*y;
    XTX = X'*X + eye(d);
    
    S=svd(XTX);
    S=diag(S);
    logsod = log(6/delta);
    
    lamb_min = S(end)+ randn()*BX^2*sqrt(logsod)/(epsilon/3) - logsod/(epsilon/3);%eigs(XTX,1,'sa');
    lamb_min = max(lamb_min,0);
    
    lamb = max(0,eta - lamb_min);
    
    
    
    XTyhat = XTy + (sqrt(log(6/delta))/(epsilon/3))*BX*BY*randn(d,1);
    % generate symmetric gaussian noise
    Z=randn(d,d);
    Z=0.5*(Z+Z');
    XTXhat = XTX + (sqrt(log(6/delta))/(epsilon/3))*BX*BX*Z;
    
    thetahat = (XTXhat+lamb*eye(d))\XTyhat;
    
    