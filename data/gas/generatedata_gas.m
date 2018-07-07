rand('seed', 100000);
randn('seed', 100000);
i = 1;
data=cell(1, 258);
for j = 1:10
fileID = fopen(['batch', num2str(j), '.dat']);
tline = fgetl(fileID);
while ischar(tline)
    linearray = strsplit(tline, {' ', ':', ';'});
    data(i, :) = linearray(1, 1:258);
    i = i+1;
    tline = fgets(fileID);
end
end
data = cellfun(@str2num, data);
data = data(data(:, 1) == 1, :);
data = data(:, 2:2:258);
[m, n] = size(data)
p = randperm(m);
data = data(p(1:m), :);
feature = data(:, 2:end);
feature = bsxfun(@minus, feature, mean(feature));
if normalize_coordinates
    feature = bsxfun(@rdivide, feature, std(feature));
end
y = data(:, 1);
y = log(y+1);
y = y - mean(y);
data = [feature, y];
k_cv_out = 10; % k fold cross validation
cvo = cvpartition(m, 'k', k_cv_out);
save gas.mat data cvo