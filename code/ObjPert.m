function [thetahat] =  ObjPert(X,y,opts)
% this is the Algorithm 1 of Kifer Smith Thakurta
% generalized objective perturbation
% we divide the recommended standard deviation of the noise 
% by a factor of 2 so everything becomes comparable in the 
% "add-one" or "remove-one" notion of DP.


    epsilon=opts.eps;
    delta=opts.delta;
    [n,d]= size(X);
    
    % since we do not restrict the domain we optimize over

    
    % this is the upper bound of \|xx^T\|_2 given by the \|x\|_2 bound
    lambda = 1;
    Lambda = 2*lambda/epsilon;
    
    
    %L=1+sqrt(2*n/(Lambda+alpha_target));
    % this is the tightest upper bound of the Lipschitz constant that we can obtain
    % A uniform gradient upper bound does not exists.
    % But we know that the optimal solution must have magnitude smaller
    % than sqrt(2*n/(Lambda))
    % therefore we can w.l.o.g contraint us to be inside this ball.
    % Then it makes sense to set Lambda to something larger to reduce
    % variance, it is unclear which Lambda to set.
    % We will constrain the space to be something much more aggressive
    % directly without modifying Lambda.
    
    L=2; % Optimizing with in \|theta\|_2 \leq 1
    
    b = L*sqrt(4*log(2/delta) + 2*epsilon)/epsilon^2*randn(d,1);
    
    XTyhat = X'*y-b;
    H = X'*X + eye(d) + (Lambda/epsilon-1)*eye(d);
   
    R=chol(H);% do cholesky decomposition H = R'*R
    
    v=(R')\XTyhat;
    
    cvx_begin quiet
        variable theta(d)
        minimize( norm(R*theta-v/2))
        subject to 
            norm(theta) <= 1
    cvx_end
    
    thetahat = theta;