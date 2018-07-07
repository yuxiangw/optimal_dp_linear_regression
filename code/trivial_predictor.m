function [theta] =  trivial_predictor(X,y,opts)
    [n,d]= size(X);
    theta = zeros(d,1);
    %tmp = X'*y;
    %tmp2 = X'*X + eye(d);
    %theta = tmp2\tmp;
end