%% This script runs the DPLinReg on UCI data sets


clear
allfolders = dir('../data/');
allfolders(1:2) = [];
dirindex = [allfolders(:).isdir];
allfolders = allfolders(dirindex);


%%



epslist = [0.01,0.02,0.05,0.1,0.2,0.5,1,2,5,10];
methodslist = {@trivial_predictor,@linreg,@suffstats_perturb,@ObjPert,...
    @OPS_epsdelta_balanced,@adaops,@adassp,@OPS_epsdelta_concentrated,...
    @OPS_epsdelta_diffused,@OPS_epsdelta_balanced,@OPS_epsdelta_conservative};
methodsNamelist = {'trivial','non-private', 'SSP','ObjPert','OPS','AdaOPS',...
    'AdaSSP','OPS-concentrated','OPS-diffused','OPS-balanced','OPS-worstcase'};
num_eps= length(epslist);
num_method = length(methodsNamelist);

%%

results_err= zeros(num_method,num_eps,length(allfolders));
results_std = zeros(num_method,num_eps,length(allfolders));
results_time = zeros(num_method,num_eps,length(allfolders));


for i = 1:length(allfolders)
    cd(['../data/',allfolders(i).name])
    load([allfolders(i).name,'.mat'])
    
    cd('../../code/')
    fprintf('Processing Data Set: %s.\n', allfolders(i).name)
    % this gives use a data matrix, each row is a data point, the last column
    % is the label
    % and a cvo file containing the cross validation partitions
    
    % normalize the data such that \|x\|_2 = 1
    
    data(isnan(data))=0; % remove nan
    X= data(:,1:end-1);
    y= data(:,end);
    y= y/max(abs(y));
    
    X = zscore(X);
    X = bsxfun(@rdivide, X,sqrt(sum(X.^2,2)));
    %X=X /  max(sqrt(sum(X.^2,2)));
    
    [n,d]=size(X);
    
    
    for j=1:length(epslist)
    % set parameters of the algorithm
        opts.eps = epslist(j);
        opts.delta = 1e-6;

        for k=1:num_method
            fun = methodslist{k};
            tic
            [err,cvErr,cvStd] = test_models(X,y,cvo, opts, fun,@linreg_pred, @linreg_err);
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
    
end

save('exp_results.mat','results_err','results_std')


  
%% Specify color coding for the plots

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

if  ~exist('figs','dir')
    mkdir figs
end

%%  draw figures for all methods
load exp_results.mat
idx=[1,2,6,7,10,3,4];

methodsNamelist = {'trivial','non-private', 'SSP','ObjPert','OPS','AdaOPS','AdaSSP','OPS-concentrated','OPS-diffused','OPS','OPS-worstcase'};


    for i=1:length(allfolders)
        close all
        fig = figure(1);
        hold all
        
        load(['../data/',allfolders(i).name,'/',allfolders(i).name,'.mat'])
        X= data(:,1:end-1);
        [n,d]=size(X);
        for j = 1:length(idx)
            %plot(epslist',results_err(idx(j),:,i)',...
            %stylelist{j},'color',colorlist(j,:),'linewidth',2,'markersize',10)
            errorbar(epslist',results_err(idx(j),:,i)',results_std(idx(j),:,i)',...
            stylelist{j},'color',colorlist(j,:),'linewidth',2,'markersize',10)
            %errorbar(repmat(epslist,[length(idx),1])',results_err(idx,:,i)',results_std(idx,:,i)','-','linewidth',2,'markersize',10)
        end
    
        legend(methodsNamelist{idx},'location','best')
        title([allfolders(i).name,'(n=',num2str(n),',d=',num2str(d),')'])
        set(gca,'fontsize',14)
        set(gca,'yscale','log')
        set(gca,'xscale','log')
        xlabel('\epsilon')
        ylabel('Prediction error')
        %xlim([1e-2,2])

        ratio = real(sqrt((results_err(1,1,i)+results_std(1,1,i))/(results_err(2,1,i)-results_std(2,1,i))));

        ylim([(results_err(2,1,i)-results_std(2,1,i)),(results_err(1,1,i)+results_std(1,1,i))*ratio*ratio])
        grid on
        tightfig;
        saveas(fig,['figs/results_',allfolders(i).name,'.pdf'])
        %pause;
        str = [allfolders(i).name,' (n=',num2str(n),',d=',num2str(d),')'];
        for j=1:length(idx)
            str = [str, '&',num2str(results_err(j,4,i)),'+/-',num2str(results_std(j,4,i))];
        end
            fprintf([str,'\\\\  \n'])

    end       
    
    
    %%  Compare different versions of OPS
load exp_results.mat
idx=[1,2,8,9,10,11];
methodsNamelist = {'trivial','non-private', 'SSP','ObjPert','AdaOPS_old','AdaOPS','AdaSSP','OPS-concentrated','OPS-diffused','OPS-balanced','OPS-conservative'};


    for i=1:length(allfolders)
        close all
        fig = figure(1);
        hold all
        load(['../data/',allfolders(i).name,'/',allfolders(i).name,'.mat'])
        X= data(:,1:end-1);
        [n,d]=size(X);
    
        
        
    errorbar(repmat(epslist,[length(idx),1])',results_err(idx,:,i)',results_std(idx,:,i)','-','linewidth',2,'markersize',10)
    
    legend(methodsNamelist{idx},'location','best')
    title([allfolders(i).name,'(n=',num2str(n),',d=',num2str(d),')'])
    set(gca,'fontsize',14)
    set(gca,'yscale','log')
    set(gca,'xscale','log')
    xlabel('\epsilon')
    ylabel('Prediction error')
    xlim([1e-2,2])
    
    %    ratio = real(sqrt((results_err(1,1,i)+results_std(1,1,i))/(results_err(2,1,i)-results_std(2,1,i))));

    %    ylim([(results_err(2,1,i)-results_std(2,1,i)),(results_err(1,1,i)+results_std(1,1,i))*ratio*ratio])
    grid on
    tightfig;
    saveas(fig,['figs/OPS_',allfolders(i).name,'.pdf'])
end

    
    %% draw the table for all methods in latex
    
    load exp_results.mat
idx=[1,2,4,10,3,6,7];
epsindex = 7 % epsilon = 0.1
    for i=1:length(allfolders)
        load(['../data/',allfolders(i).name,'/',allfolders(i).name,'.mat'])
        X= data(:,1:end-1);
        [n,d]=size(X);

    % find the best low variance estimate
    [tmp, ii]=min(results_err(idx(3:end),epsindex,i));
    boldset = find(results_err(idx(3:end),epsindex,i) - 2*results_std(idx(3:end),epsindex,i)/sqrt(10)<tmp & (results_std(idx(3:end),epsindex,i)<results_err(idx(3:end),epsindex,i)));
    
    
    str = [allfolders(i).name];%,' (n=',num2str(n),',d=',num2str(d),')'];
    for j=1:length(idx)
        if ismember(j,boldset+3-1)%j==ii+3-1%
                    str = [str, '&','\\textbf{',num2str(results_err(idx(j),epsindex,i),3),'}',...
                        '$\\pm$','\\textbf{',num2str(results_std(idx(j),epsindex,i),2),'}'];
        else
                str = [str, '&',num2str(results_err(idx(j),epsindex,i),3),'$\\pm$',num2str(2*results_std(idx(j),epsindex,i)/sqrt(10),2)];
        end
    end
        fprintf([str,'\\\\  \n'])
    
    end    
    
    