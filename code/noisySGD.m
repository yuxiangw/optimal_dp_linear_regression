function [thetahat] = noisySGD(X,y,opts)
    % due to computational limit we only want to run at most 2n iterations.
    % and we average the second pass to reduce variance
    % instead of n*epsilon^2 passes as suggested in theory.
    
    % 
    
    
    
    epsilon=opts.eps;
    delta=opts.delta;
    
    [n,d]= size(X);
    
    
    theta=zeros(d,1);
    
    % calibarate the amount of privacy by 
    % eps in each iteration is
    %  2*sz/n*base_eps   with  sigma =  sqrt(log(2/delta))*(1+\|theta\|_2)/base_eps
    % The previous iteration is already released, so we can calculate the
    % true Lipschitz constant 1+\|theta\|
    
    % CGF-composition gives something bigger than
    % 2*sqrt(T)sz/n* base_eps * log(2/delta)
    % but we want to make it more favorable for NoisySGD
    % so let's just take it as is.
    
    B=1; % assume initially \|theta^*\|\leq 1 
    
    T=n;
    base_eps=1; % adjust this if sz becomes smaller than 1. 
    sz  =  floor(epsilon / log(2/delta)/base_eps * n /sqrt(2*T)/2);
    if sz <1
        sz=1;
        base_eps = epsilon / log(2/delta)/sz * n /sqrt(2*T)/2;
    end
    
    % exploration
    for t=1:T
        idx = randi([1,n],1,sz);
        
        L=1+norm(theta);
        sigma =  sqrt(log(2/delta))*L/base_eps;
        eta = B/sqrt(2*T)/sqrt(sigma^2*log(2/delta)+L^2);
        
        theta = theta - eta * ( X(idx,:)'*(X(idx,:)*theta -y(idx,:))- theta  + sigma*randn(d,1));
        % the -theta comes from the small regularization added to avoid singular data.
    end
    
    % annealing to reduce variance: a well-known technique
    thetahat = zeros(d,1);
    for t=1:T
        idx = randi([1,n],1,sz);
        
        L=1+norm(theta);
        %eta = L/2/T;
        sigma =  sqrt(log(2/delta))*L/base_eps;
        eta = B/sqrt(2*T)/sqrt(sigma^2*log(2/delta)+L^2);
        
        theta = theta - eta/sz * ( X(idx,:)'*(X(idx,:)*theta -y(idx,:))- theta  + sigma*randn(d,1));
        thetahat= thetahat*((t-1)/t) + theta*(1/t);
    end
    
    fprintf(thetahat)

end