    function [err,cvErr,cvStd] = test_recovery(X,y,cvo, opts,fun_train,theta0)
        err = zeros(cvo.NumTestSets,1);
        for j = 1:cvo.NumTestSets
            trIdx = cvo.training(j);
            teIdx = cvo.test(j);
            theta = fun_train(X(trIdx,:),y(trIdx,:),opts);

            err(j)= norm(theta-theta0)^2;
        end
        
        cvErr = mean(err);
        cvStd = std(err);
    
    end