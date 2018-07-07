rand('seed', 100000);
randn('seed', 100000);
data = textread('flare.data2.txt');
[m, n] = size(data)
p = randperm(m);
data = data(p, :);
feature = data(:, 1:end-1);
feature = bsxfun(@minus, feature, mean(feature));
if normalize_coordinates
    tmp=std(feature(:, 1:end-2));
    tmp(isnan(tmp))=1;
    feature(:, 1:end-2) = bsxfun(@rdivide, feature(:, 1:end-2), tmp);
 %   feature(:, 1:end-2) = bsxfun(@rdivide, feature(:, 1:end-2), std(feature(:, 1:end-2)));
end
y = data(:, end);
y = y - mean(y);
data = [feature, y];
k_cv_out = 10; % k fold cross validation
cvo = cvpartition(m, 'k', k_cv_out);
save solar.mat data cvo