function [theta] =  linreg(X,y,opts)
    [n,d]= size(X);
    tmp = X'*y;
    tmp2 = X'*X + eye(d);
    theta = tmp2\tmp;
end