rand('seed', 100000);
randn('seed', 100000);
data = csvread('3D_spatial_network.txt');
[m, n] = size(data)
p = randperm(m);
data = data(p(1:m), :);
feature = data(:, 1:end-1);
y = data(:, end);
y = y - mean(y);
feature = bsxfun(@minus, feature, mean(feature));
if normalize_coordinates
    tmp=std(feature);
    tmp(isnan(tmp))=1;
    feature = bsxfun(@rdivide, feature, tmp);
end
data = [feature, y];
k_cv_out = 10; % k fold cross validation
cvo = cvpartition(m, 'k', k_cv_out);
save 3droad.mat data cvo