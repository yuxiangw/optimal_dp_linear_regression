rand('seed', 100000);
randn('seed', 100000);
data = csvread('reaction_undirected.txt');
index = find(data(:, 21) > 1);
data(index, :) = [];
[m, n] = size(data)
p = randperm(m);
data = data(p(1:m), :);
feature = data(:, 1:end-1);
feature = bsxfun(@minus, feature, mean(feature));
if normalize_coordinates
    feature = bsxfun(@rdivide, feature, std(feature));
end
y = log(data(:, end));
y = y - mean(y);
data = [feature, y];
k_cv_out = 10; % k fold cross validation
cvo = cvpartition(m, 'k', k_cv_out);
save keggundirected.mat data cvo