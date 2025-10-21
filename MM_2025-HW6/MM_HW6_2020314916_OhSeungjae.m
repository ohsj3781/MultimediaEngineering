% MM_HW6_2020314916_OhSeungjae.m %


%% 1: Understanding of entropy %%
clear; clc;
% 1-a: Entropy calculation of a black/white image with random binary number %


width = 100;
height = 100;

img_uniform_distributed = uint8(randi([0 255], width, height));

figure;
imshow(img_uniform_distributed);
title('Uniform Distribution Image');

figure;
histogram(img_uniform_distributed);

entropy_uniform = entropy(img_uniform_distributed);

fprintf('Entropy of Uniform Distribution Image: %.4f\n', entropy_uniform);

% 1-b :  Entropy calculation of an image %

total_pixels = width * height;

img_distributed = zeros(height, width, 'uint8');

random_indexes = randperm(total_pixels);

quarter = total_pixels / 4;

img_distributed(random_indexes(1:quarter)) = 50;

img_distributed(random_indexes(quarter+1:2*quarter)) = 100;

img_distributed(random_indexes(2*quarter+1:3*quarter)) = 150;

img_distributed(random_indexes(3*quarter+1:4*quarter)) = 200;

figure;
imshow(img_distributed);
title('Distributed Image');

figure;
histogram(img_distributed);

entropy_distributed = entropy(img_distributed);

fprintf('Entropy of Distributed Image: %.4f\n', entropy_distributed);

%% 2. Entropy calculation of an image with different probability distributions %%
clear; clc;

width = 100;
height = 100;
% 2-a
% images_gaussian=cell(1,4);
means=[60,128,128,128];
standard_deviations=[10,10,20,40];



for i=1:length(means)
    img_gaussian = max(min(uint8(normrnd(means(i), standard_deviations(i), width, height)), 255), 0);
    % images_gaussian{i}=img_gaussian;
    entropy_gaussian = entropy(img_gaussian);
    fprintf('Entropy of Gaussian Image (mean=%d, std=%d): %.4f\n', means(i), standard_deviations(i), entropy_gaussian);

    figure;
    imshow(img_gaussian);
    title(sprintf('Gaussian Image (mean=%d, std=%d)', means(i), standard_deviations(i)));

    figure;
    histogram(img_gaussian);
end
fprintf('\n');

% 2-b
% images_laplacian=cell(1,4);

for i=1:length(means)
    mean = means(i);
    sigma = standard_deviations(i);
    u = rand(width, height)-0.5;
    scale_parameter = sigma / sqrt(2);
    img_laplacian = max(min(uint8(mean - scale_parameter * sign(u).* log(1- 2* abs(u))),255),0);
    % images_laplacian{i}=img_laplacian;
    entropy_laplacian = entropy(img_laplacian);
    fprintf('Entropy of Laplacian Image (mean=%d, std=%d): %.4f\n', means(i), standard_deviations(i), entropy_laplacian);

    figure;
    imshow(img_laplacian);
    title(sprintf('Laplacian Image (mean=%d, std=%d)', means(i), standard_deviations(i)));

    figure;
    histogram(img_laplacian);
end
fprintf('\n');

% 2-c %

image_uniform = uint8(randi([0 255], width, height));
entropy_uniform = entropy(image_uniform);
fprintf('Entropy of Uniform Distribution Image: %.4f\n', entropy_uniform);
figure;
imshow(image_uniform);
title('Uniform Distribution Image');
figure;
histogram(image_uniform);



