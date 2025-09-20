%% Sampling

original_Image = imread('Sample.png');

Sampling_factor = 0.5;
sampled_image = imresize(original_Image, Sampling_factor, 'nearest', 'Antialiasing', false);
imwrite(sampled_image, 'Sampled_0.5.png');

%% Quantization
original_Image = imread('Sample.png');
quantized_bit = 4;

quantized_scale = 2^(8-quantized_bit);
I_4bit = floor(double(original_Image) / quantized_scale);
I_8bit_from4 = uint8(I_4bit * quantized_scale);

imwrite(I_8bit_from4, 'Quantized_4bit.png');
