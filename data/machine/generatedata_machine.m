rand('seed', 100000);
randn('seed', 100000);
data = csvread('machine.data.txt');
data(:, end) = [];
[m, n] = size(data)
p = randperm(m);
data = data(p(1:m), :);
feature = data(:, 1:end-1);
feature = bsxfun(@minus, feature, mean(feature));
if normalize_coordinates
    feature = bsxfun(@rdivide, feature, std(feature));
end
y = data(:, end);
y = log(y);
y = y - mean(y);
data = [feature, y];
k_cv_out = 10; % k fold cross validation
cvo = cvpartition(m, 'k', k_cv_out);
save machine.mat data cvo