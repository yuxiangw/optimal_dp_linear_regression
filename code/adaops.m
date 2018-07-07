function [thetahat] =  adaops(X,y,opts)

    epsilon=opts.eps;
    delta=opts.delta;
    
    % bound of variables
    BY=1;
    BX =1;
    
    [n,d]= size(X);
    XTy = X'*y;
    XTX = X'*X + eye(d);
    
    
    % eps/4 for releasing eigenvalue lamb_min
    % eps/4 for releasing local Lipschitz constant for the chosen lamb 
    % eps/2 for doing OPS in the end.
    
    % lamb_min + lamb  >  (1+log(2/\delta))BX^2/ [2(eps/2)] otherwise  even
    % if \gamma = 0, we won't get the privacy level.
    % so we set a bar at 2 times that much.  (1+log(2/\delta))BX^2/ [2(eps/2)]
    % then when that's the case, it doesn't make sense to take gamma to be
    % very small you know as it won't matter... choose gamma such that 
    
    % DP release the smallest eigenvalue
    S=svd(XTX);
    S=diag(S);
    logsod = log(6/delta);
    
    lamb_min = S(end)+ randn()*BX^2*sqrt(logsod)/(epsilon/4) - logsod/(epsilon/4);%eigs(XTX,1,'sa');
    lamb_min = max(lamb_min,0);
    
    % how much to allocate for the part that does not depend on \gamma
    alpha = 1/2;
    lamb_target = BX^2*(1+log(6/delta))/2/(epsilon/2*alpha);
    lamb_target = max(lamb_target-lamb_min,0);
    
    
    % solve the quadratic equation to get epsilonbar, when we take
    % gamma  =  (lamb+lamb_min) * epsilonbar^2 /L^2/logsod 
    
    % solve the quadratic equation w.r.t. the epsilonbar.
    % 
    a=1/2*logsod;
    b=1;
    c=-epsilon/2*(1-alpha);
    epsilonbar = (-b + sqrt(b^2-4*a*c))/(2*a);
    
    C1_fun = @(eps,del,rho,dd) (dd/2+sqrt(dd*log(1/rho)) + log(1/rho))*log(2/del)/eps^2;
    C2_fun = @(eps,del) log(2/del)/eps;
    
    varrho = 0.05;
    C1=C1_fun(epsilonbar,delta/3,varrho,d);
    C2=C2_fun(epsilon/4,delta/3);
    
    
    fun_obj =@(t) C1*BX^4*(1+BX^2./(t+lamb_min)).^(2*C2)./(t+lamb_min) + t;
    grad_obj = @(t) 1 - (2*BX^6*C1*C2*(BX^2/(lamb_min + t) + 1)^(2*C2 - 1))/(lamb_min + t)^3 ...
        - (BX^4*C1*(BX^2/(lamb_min + t) + 1)^(2*C2))/(lamb_min + t)^2;
 
    fun = @(t) deal(fun_obj(t),grad_obj(t));
    options = optimoptions('fmincon','Display','off','SpecifyObjectiveGradient',true);
    
    %fun = @(t) fun_obj(t);
    %options = optimoptions('fmincon','Display','off','SpecifyObjectiveGradient',false);
    
    lamb = fmincon(fun,2*C2,-1,-lamb_target,[],[],[],[],[],options);
    
    % solve the nonlinear equation
    %lamb = fsolve(grad_obj, 2*C2);
    if lamb < 0
        fprintf('AdaOPS Optimization error!\n')
    end
    
    
    

    
    

    H = XTX + lamb*eye(d);
    
    % now get an estimate of the magnitude of theta
    R=chol(H);% do cholesky decomposition H = R'*R
    theta = R\((R')\XTy);
    %theta = H\XTy;
    
    thetanorm = norm(theta);
    sigma = log(1+BX^2/(lamb+lamb_min))/(epsilon/4);
    Delta = log(BY + BX*thetanorm) + randn()*sigma*sqrt(logsod) + sigma*logsod;
    
    % estimate \|hat(theta)\| and the Lipschiz constant.
    L = BX*min(exp(Delta),BY+BX*sqrt(2*sqrt(n*BY)/(lamb+lamb_min)));
    
    
    h=lamb+lamb_min;

    % This ensures that the variance is at most as big as the intrinsic
    % variance.
        
   % solve the quadratic equation to get the actual epsilontilde
   a= L^2/2/(h + BX^2);
   b= sqrt(L^2*logsod/(h));
   c=BX^2*(1+logsod)/2/(h) - epsilon/2;
   %epsilontilde = (-b + sqrt(b^2-4*a*c))/(2*a);
   sqrtgamma = (-b + sqrt(b^2-4*a*c))/(2*a);
    
    % calibrate gamma
    %sqrtgamma = sqrt(lamb_min+lamb)*epsilontilde/sqrt(logsod)/L;
    
    % output the OPS sample
    thetahat =  theta + (R')\randn(d,1)/sqrtgamma;
    
   
end