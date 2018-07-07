rand('seed', 100000);
randn('seed', 100000);
data = csvread('reaction_directed.txt');
[m, n] = size(data)
data(:, [10, 15]) = [];
p = randperm(m);
data = data(p(1:m), :);
feature = data(:, [1, 3:end]);
feature = bsxfun(@minus, feature, mean(feature));
if normalize_coordinates
    feature = bsxfun(@rdivide, feature, std(feature));
end
y = log(data(:, 2));
y = y - mean(y);
data = [feature, y];
k_cv_out = 10; % k fold cross validation
cvo = cvpartition(m, 'k', k_cv_out);
save keggdirected.mat data cvo
