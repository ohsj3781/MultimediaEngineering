clear; clc;

% Load Original Image
img = imread("photo.jpg");

qfs = 1:2:99;
n   = numel(qfs);

file_size = zeros(n,1);
mse_vals  = zeros(n,1);
fnames    = strings(n,1);

for k = 1:n
    qf = qfs(k);

    % Save the file (Lossy compression with JPEG)
    fn = sprintf("temp_image_qf%03d.jpg", qf);
    fnames(k) = fn;
    imwrite(img, fn, "jpg", "Quality", qf);

    % File size Calculation
    info = dir(fn);
    file_size(k) = info.bytes;

    % MSE Calculation
    jpg = imread(fn);
    d = double(img) - double(jpg);
    mse_vals(k) = mean(d(:).^2);
end

figure;
plot(file_size/1024, mse_vals, '-o', 'LineWidth', 1.2, 'MarkerSize', 4);
grid on;
xlabel('File size [KB] (Rate)');
ylabel('MSE (Distortion)');
title('JPEG Rate–Distortion (File size (Rate) vs MSE (Distortion))');

% Delete the files
for k = 1:n
    if isfile(fnames(k)), delete(fnames(k)); end
end
