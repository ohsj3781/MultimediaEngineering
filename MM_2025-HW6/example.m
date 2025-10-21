clear; clc;
%% Random Image
width = 100;
height = 100;

% Uniform Distribution
% img = uint8(randi([min max], HT, VT))
img_uniform_distributed = uint8(randi([0 255], width, height));
%histogram(img_uniform_distributed);
entropy_uniform = entropy(img_uniform_distributed);

% Gaussian Distribution
% img = normrnd (mean, sigma, HT, VT)
mean = 100;
sigma = 20;
img_gaussian_distributed = max(min(uint8(normrnd(mean, sigma, 100, 100)), 255), 0);
%histogram(img_gaussian_distributed);
entropy_gaussian = entropy(img_gaussian_distributed);

% Laplacian Distribution
mean = 100;
sigma = 20;
u = rand(width, height)-0.5;
scale_parameter = sigma / sqrt(2);
img_laplacian = max(min(uint8(mean - scale_parameter * sign(u).* log(1- 2* abs(u))),255),0);
%histogram(img_laplacian);
entropy_laplacian = entropy(img_laplacian);
