rand('seed', 100000);
randn('seed', 100000);
data = textread('Concrete_Data.txt');
data(:, end) = [];
[m, n] = size(data)
p = randperm(m);
feature = data(:, 1:end-1);
feature = bsxfun(@minus, feature, mean(feature));
if normalize_coordinates
    feature = bsxfun(@rdivide, feature, std(feature));
end
y = data(:, end);
y = y - mean(y);
data = [feature, y];
k_cv_out = 10; % k fold cross validation
cvo = cvpartition(m, 'k', k_cv_out);
save concrete.mat data cvo