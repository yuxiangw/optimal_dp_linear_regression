rand('seed', 100000);
randn('seed', 100000);
data = textread('parkinsons.txt');
y = data(:, 6);
data(:, 5:6) = [];
data = [data, y];
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
save parkinsons.mat data cvo