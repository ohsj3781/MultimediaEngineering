%% Calculate the entropy of zip file and image file
clear; clc;

function H = file_entropy_bits_per_byte(filepath)
    fid = fopen(filepath, 'r');
    bytes = fread(fid, Inf, '*uint8');
    fclose(fid);

    if isempty(bytes)
        H = 0;
        return;
    end

    % calculate frequency of 0~255
    counts = histcounts(bytes, 0:256);
    p = counts / sum(counts);
    p = p(p > 0);

    % Shannon entropy
    H = -sum(p .* log2(p));   % [bits/byte]
end

function H = csv_entropy_chars(filepath)
    txt = fileread(filepath);           
    bytes = uint8(txt);                 
    counts = histcounts(bytes, 0:256);
    p = counts / sum(counts);
    p = p(p>0);
    H = -sum(p .* log2(p)); % [bits/character]
end

zip_file_name = 'example.zip';
Entropy_zip_file = file_entropy_bits_per_byte(zip_file_name);

csv_file_bame = "example.csv";
Entropy_csv_file = csv_entropy_chars(csv_file_bame);

image_file_name = 'Sample.png';
Image = imread(image_file_name);

Entropy_image_file = 0;
if (ndims(Image) == 3)
    R = Image(:,:,1);
    G = Image(:,:,2);
    B = Image(:,:,3);
    H_R = entropy(R);
    H_G = entropy(G);
    H_B = entropy(B);
    Entropy_image_file = mean([H_R, H_G, H_B]); % [bits/pixel]
else
    Entropy_image_file = entropy(Image); % [bits/pixel]
end
   



%% Lossy compression with JPEG in matlab
clear; clc;

img = imread("Sample.png");
quality_factor = 10;

imwrite(img, "Compressed_img.jpg", "Quality", quality_factor)
Compressed_img = imread("Compressed_img.jpg");
psnr = psnr(Compressed_img, img, 255);