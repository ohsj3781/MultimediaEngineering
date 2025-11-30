clc; clear; close all;

%% Load the original image
I_org = imread('SKKUG.png');

%% 1. Quantization of Image

%% 1-a

entropy_org = entropy(I_org);
fprintf('Original Image Entropy: %.4f\n\n', entropy_org);

%% 1-b

stepSizes = [22, 27, 32, 37, 42];
numSteps = length(stepSizes);

entropy_quants = zeros(1, numSteps);
psnr_quants = zeros(1, numSteps);



figure('Name', 'Problem 1: Quantization of Image');
for i = 1:numSteps
    stepSize = stepSizes(i);

    I_quant = round(I_org / stepSize) * stepSize;   % Quantization and Dequantization
    entropy_quants(i) = entropy(I_quant);   % Compute Entropy
    psnr_quants(i) = 10*log10(255^2 / mean((I_org(:) -I_quant(:)).^2)); % Compute PSNR
    fprintf('stepSize: %d\t entropy: %.4f\t PSNR: %.4f\n', stepSize, entropy_quants(i), psnr_quants(i));

    % Save the image
    filename = sprintf('SKKU_quant_step%d.png', stepSize);
    imwrite(I_quant, filename);

    % Display the image
    subplot(2, 3, i);
    imshow(I_quant);
    title(sprintf('Step=%d, PSNR=%.2f dB', stepSize, psnr_quants(i)));
end

% Plot PSNR vs Entropy for Problem 1
subplot(2, 3, 6);
plot(entropy_quants, psnr_quants, '-o', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Entropy');
ylabel('PSNR (dB)');
title('PSNR vs Entropy');
grid on;

fprintf('\n');


%% 2. Quantization of Image after Transform.

%% 2-a

I_tr = dct2(I_org); % Perform a DCT2 transform on the entire image
I_tr_quant = round(I_tr/16)*16; % Quantization and Dequantization
entropy_tr_quant = entropy(I_tr_quant); % Compute Entropy

fprintf('Entropy of DCT-transformed image: %.4f\n\n', entropy_tr_quant);

%% 2-b Perform inverse DCT

I_tr_recon = idct2(I_tr_quant); % Inverse Transform
I_tr_recon = uint8(max(0, min(255, I_tr_recon))); % Clipping
entropy_idct = entropy(I_tr_recon); % Compute Entropy
fprintf('Entropy of inverse DCT image: %.4f\n\n', entropy_idct);

%% 2-d

% Initialize arrays to store results
stepSizes = [22, 27, 32, 37, 42];
numSteps = length(stepSizes);
entropy_quant_2 = zeros(1, numSteps);
psnr_quant_2 = zeros(1, numSteps);

figure('Name', 'Problem 2: Transform + Quantization');
for i = 1:numSteps
    stepSize = stepSizes(i);

    I_dct_quant = round(I_tr / stepSize) * stepSize; % Quantization and Dequantization
    % Inverse DCT
    I_recon = idct2(I_dct_quant);
    I_recon = uint8(max(0, min(255, I_recon)));  % Clipping to [0, 255]

    % Save the image
    filename = sprintf('SKKU_tr_quant_step%d.png', stepSize);
    imwrite(I_recon, filename);

    % Display the image
    subplot(2, 3, i);
    imshow(I_recon);
    title(sprintf('Step=%d, PSNR=%.2f dB', stepSize, psnr_quant_2(i)));
end

% Plot PSNR vs Entropy for Problem 2
subplot(2, 3, 6);
plot(entropy_quant_2, psnr_quant_2, '-o', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Entropy');
ylabel('PSNR (dB)');
title('PSNR vs Entropy (Problem 2)');
grid on;

fprintf('\n');