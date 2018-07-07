    function [err,cvErr,cvStd] = test_models(X,y,cvo, opts,fun_train,fun_pred, fun_err)
        err = zeros(cvo.NumTestSets,1);
        for j = 1:cvo.NumTestSets
            trIdx = cvo.training(j);
            teIdx = cvo.test(j);
            theta = fun_train(X(trIdx,:),y(trIdx,:),opts);
            ypred = fun_pred(X(teIdx,:),theta);

            err(j)= fun_err(ypred,y(teIdx));
        end
        
        cvErr = mean(err);
        cvStd = std(err);
    
    end