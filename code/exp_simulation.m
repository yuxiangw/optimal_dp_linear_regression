%% This script runs the DPLinReg on simulated linear Gaussian model generated data.

epslist = [0.01,0.1,1];
methodslist = {@trivial_predictor,@linreg,@suffstats_perturb,@ObjPert,...
    @OPS_epsdelta_balanced,@adaops,@adassp,@OPS_epsdelta_concentrated,...
    @OPS_epsdelta_diffused,@OPS_epsdelta_balanced,@OPS_epsdelta_conservative};
methodsNamelist = {'trivial','non-private', 'SSP','ObjPert','OPS','AdaOPS',...
    'AdaSSP','OPS-concentrated','OPS-diffused','OPS-balanced','OPS-worstcase'};

d= 10;

nlist= 20*2.^[1:1:20];



 colorlist  =  [
     0,0,0; % trivial
     0.4660    0.6740    0.1880; % non-private
     0    0.4470    0.7410; % AdaOPS
    0.8500    0.3250    0.0980; % AdaSSP
         0    0.4470    0.7410; % OPS
    0.8500    0.3250    0.0980; % SSP
    0.9290    0.6940    0.1250; % ObjPert
    0.4940    0.1840    0.5560; % 
    0.3010    0.7450    0.9330;
    0.6350    0.0780    0.1840];

stylelist = {
    ':', ':', '-o', '-o', '--', '--','-'
    };


num_eps= length(epslist);
num_method = length(methodsNamelist);
num_n = length(nlist);

%%
results_err= zeros(num_method,num_eps,num_n);
results_std = zeros(num_method,num_eps,num_n);
results_time = zeros(num_method,num_eps,num_n);

sigma = 1;

theta = randn(d,1);
theta = theta/norm(theta)/sqrt(2);

for i = 1:num_n
    n=nlist(i);
    X=randn(n,d);
    X = bsxfun(@rdivide, X,sqrt(sum(X.^2,2)));
    y = X*theta + 0.1*sigma*(rand(n,1)-0.5);
    cvo = cvpartition(length(y),'KFold',10);
    
    
    for j=1:length(epslist)
    % set parameters of the algorithm
        opts.eps = epslist(j);
        opts.delta =1/n^(1.1);

        for k=1:num_method
            fun = methodslist{k};
            tic
            %[err,cvErr,cvStd] = test_models(X,y,cvo, opts, fun,@linreg_pred, @linreg_err);
            [err,cvErr,cvStd] = test_recovery(X,y,cvo, opts, fun, theta);
            t_run=toc;
            fprintf('%s at eps = %f: Test err = %.2f, std = %.2f, runtime = %.2f s.\n', methodsNamelist{k}, opts.eps, cvErr,cvStd,t_run)
            results_err(k,j,i) = cvErr;
            results_std(k,j,i) = cvStd;
            results_time(k,j,i)=t_run;
        end

         %[cvErr,cvStd]
         
        
   
    end
    
    % do private linear regression with AdaOPS / how to evaluate accuracies
    
    % compare to noisy SGD
    % compare to objective perturbation
    % compare to sufficient statistics perturbation.
    
    % these methods are not adaptive and should perform poorly.
    %save('exp_gaussian.mat','results_err','results_std')
end

save('exp_gaussian.mat','results_err','results_std')


%%  draw figures
load exp_gaussian.mat

%idx=[1,2,8,3,6,7];
RelEfficiency =  bsxfun(@rdivide,results_err,results_err(2,:,:));

idx=[1,2,6,7,10,3,4];

methodsNamelist = {'trivial','non-private', 'SSP','ObjPert','OPS','AdaOPS',...
    'AdaSSP','OPS-concentrated','OPS-diffused','OPS-balanced','OPS-worstcase'};


%%
%,squeeze(results_std(idx,i,:))
    for i=1:num_eps
        close all
        fig = figure(1);
        hold all
        
        
        for j = 1:length(idx)
            errorbar(nlist',squeeze(results_err(idx(j),i,:))',squeeze(results_std(idx(j),i,:))',...
            stylelist{j},'color',colorlist(j,:),'linewidth',2,'markersize',10)
        end
        
       legend(methodsNamelist{idx},'location','southwest')
    set(gca,'fontsize',14)
    set(gca,'yscale','log')
    set(gca,'xscale','log')
    grid on
    xlabel('n')
    ylabel('MSE')
    if i==2
        ylim([1e-10,1e5])
    end
    %ylim([0.5,1e8])
    xlim([nlist(1),nlist(end)])
                tightfig;
    saveas(fig,['figs/','Gaussian_MSE_','eps_',num2str(epslist(i)),'.pdf'])
    %pause;
    end
    
    
    %%

    for i=1:num_eps
       close all    
    fig = figure(1);
        hold all
        
        for j = 1:length(idx)
            errorbar(nlist',squeeze(RelEfficiency(idx(j),i,:))',squeeze(results_std(idx(j),i,:))',...
            stylelist{j},'color',colorlist(j,:),'linewidth',2,'markersize',10)
        end
        
        
       legend(methodsNamelist{idx},'location','best')
    set(gca,'fontsize',14)
    set(gca,'yscale','log')
    set(gca,'xscale','log')
    grid on
    %pause;
    
        xlabel('n')
    ylabel('Relative-Efficiency')
            ylim([0.5,1e8])
             xlim([nlist(1),nlist(end)])
            tightfig;
    saveas(fig,['figs/','Gaussian_RelativeEfficiency_','eps_',num2str(epslist(i)),'.pdf'])


    end