% MM_HW5_2020314916_OhSeungjae.m %

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

function H = image_entropy_bits_per_pixel(Image)
H = 0;
if (ndims(Image) == 3)
    R = Image(:,:,1);
    G = Image(:,:,2);
    B = Image(:,:,3);
    H_R = entropy(R);
    H_G = entropy(G);
    H_B = entropy(B);
    H = mean([H_R, H_G, H_B]); % [bits/pixel]
else
    H = entropy(Image); % [bits/pixel]
end
end

function H = get_file_size_in_bytes(filepath)
fid = fopen(filepath, 'r');
bytes = fread(fid, Inf, '*uint8');
fclose(fid);
H = length(bytes);
end

%% 1. Looseless Compression with zipping program %%
clear; clc;

csv_file_name = "example.csv";
Entropy_csv_file = csv_entropy_chars(csv_file_name);
% fprintf("File size of %s: %d bytes\n", csv_file_name, get_file_size_in_bytes(csv_file_name));
fprintf("Entropy of %s: %.8f \n", csv_file_name, Entropy_csv_file);
fprintf("\n");

zip_paths={'alzip','bandizip','windows_zip'};
zip_file_names={'example_01.zip','example_02.zip','example_03.zip','example_04.zip','example_05.zip'};

for zip_path = zip_paths
    for zip_file_name = zip_file_names
        zip_file = zip_path + "/" + zip_file_name;
        Entropy_zip_file = file_entropy_bits_per_byte(zip_file);
        % fprintf("File size of %s: %d bytes\n", zip_file, get_file_size_in_bytes(zip_file));
        fprintf("Entropy of %s: %.8f \n", zip_file, Entropy_zip_file);
    end
    fprintf("\n");
end
%% 2. Exercise with your own photo %%
clear; clc;

photo_name = "photo.jpg";
Image=imread(photo_name);
Entropy_photo_file = image_entropy_bits_per_pixel(Image);
fprintf("Entropy of %s: %.8f \n", photo_name, Entropy_photo_file);
% fprintf("File size of %s: %d bytes\n", photo_name, get_file_size_in_bytes(photo_name));
fprintf("\n");

zip_paths={'alzip','bandizip','windows_zip'};
zip_file_names={'photo_01.zip','photo_02.zip','photo_03.zip','photo_04.zip','photo_05.zip'};

for zip_path = zip_paths
    for zip_file_name = zip_file_names
        zip_file = zip_path + "/" + zip_file_name;
        Entropy_zip_file = file_entropy_bits_per_byte(zip_file);
        fprintf("Entropy of %s: %.8f \n", zip_file, Entropy_zip_file);
        % fprintf("File size of %s: %d bytes\n", zip_file, get_file_size_in_bytes(zip_file));
    end
    fprintf("\n");
end

%% 3. Lossy Compression with JPEG in Matlab %%
clear; clc;

img = imread("Sample.png");
quality_factors = {25,50,75};

for quality_factor = quality_factors
    compressed_filename = sprintf("Compressed_img_qf%d.jpg", quality_factor{1});
    fprintf("Quality Factor: %d\n", quality_factor{1});

    imwrite(img, compressed_filename, "Quality", quality_factor{1});
    compressed_img = imread(compressed_filename);
    psnr_value = psnr(compressed_img, img, 255);
    fprintf("PSNR : %.4f\n", psnr_value);

    fprintf("Compression Ratio : %.4f\n", ...
        get_file_size_in_bytes("Sample.png") / get_file_size_in_bytes(compressed_filename));
    fprintf("\n");
end
%% 4. Exercise with your own photo %%
clear; clc;

img = imread("photo.jpg");
quality_factors = {25,50,75};

for quality_factor = quality_factors
    compressed_filename = sprintf("Compressed_img_qf%d.jpg", quality_factor{1});
    fprintf("Quality Factor: %d\n", quality_factor{1});

    imwrite(img, compressed_filename, "Quality", quality_factor{1});
    compressed_img = imread(compressed_filename);
    psnr_value = psnr(compressed_img, img, 255);
    fprintf("PSNR : %.4f\n", psnr_value);

    fprintf("Compression Ratio : %.4f\n", ...
        get_file_size_in_bytes("Sample.png") / get_file_size_in_bytes(compressed_filename));
    fprintf("\n");
end