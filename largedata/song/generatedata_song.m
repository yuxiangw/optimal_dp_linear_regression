rand('seed', 100000);
randn('seed', 100000);
data = csvread('YearPredictionMSD.txt');
[m, n] = size(data)
p = randperm(m);
data = data(p, :);
feature = data(:, [2:end]);
feature = bsxfun(@minus, feature, mean(feature));
if normalize_coordinates
    feature = bsxfun(@rdivide, feature, std(feature));
end
y = data(:, 1);
y = log(2015-y);
y = y - mean(y);
data = [feature, y];
k_cv_out = 10; % k fold cross validation
cvo = cvpartition(m, 'k', k_cv_out);
save song.mat data cvo