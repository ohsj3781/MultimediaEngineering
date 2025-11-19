clc; clear; close all;

I_org = imread('SKKUG.png');
entropy_org = entropy(I_org);

quantStep = 16;
I_quant = round(I_org / quantStep) * quantStep;                        % Quantization and Dequantization
entropy_quant = entropy(I_quant);                                      % Compute Entropy
psnr_quant = 10*log10(255^2 / mean((I_org(:) - I_quant(:)).^2));       % Compute PSNR
imwrite(I_quant, "SKKU_quant.png");                                    % Save the Image file

I_tr = dct2(I_org);                                                    % Perform a DCT2 transform on the entire image
I_tr_quant = round(I_tr / quantStep) * quantStep;                      % Quantization and Dequantization
entropy_tr_quant = entropy(I_tr_quant);                                % Compute Entropy
I_tr_recon = idct2(I_tr_quant);                                        % Inverse Transform
I_tr_recon = uint8(max(0, min(255, I_tr_recon)));                      % Clipping
psnr_tr_quant = 10*log10(255^2 / mean((I_org(:) - I_tr_recon(:)).^2)); % Compute PSNR
imwrite(I_tr_recon, "SKKU_tr_quant.png");                              % Save the Image file

