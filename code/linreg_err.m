function [err] =  linreg_err(ypred,ytrue)

err = (ypred-ytrue)'*(ypred-ytrue)/length(ypred);

end