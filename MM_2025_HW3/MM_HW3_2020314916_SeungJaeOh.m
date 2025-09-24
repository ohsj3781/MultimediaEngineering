% MM_HW3_2020314916_SeungJaeOh.m %


%% Section 1: Sampling %
% Read original image file %
original_image = imread('Sample.png');

% Resample the original image file with a resample ratio of 0.75, 0.5, and 0.25 %
sampling_factors = [0.75, 0.5, 0.25];
for sampling_factor = sampling_factors
    sampled_image = imresize(original_image,sampling_factor,'nearest','Antialiasing',false);
    imwrite(sampled_image, 'Sampled_' + string(sampling_factor) + '.png');
end

%% Section 2: Quantization %
% Quantize the original image file to bit depth of 6-bit, 4-bit, and 2-bits %
original_image = imread('Sample.png');

quantized_bits = [6, 4, 2];
for quantized_bit = quantized_bits

    quantized_scale = 2^(8-quantized_bit);
    image_quantized = floor(double(original_image)/quantized_scale);
    image_8bit_from_quantized = uint8(image_quantized*quantized_scale);

    imwrite(image_8bit_from_quantized, 'Quantized_' + string(quantized_bit) + 'bit.png');
end

