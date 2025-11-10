%% Huffman & Arithmetic Coding
clc; clear; close all;

%% Load image (RGB → Gray, uint8)
img = imread('SKKU.png');         % Load File
if size(img,3) == 3, img = rgb2gray(img); end
img = uint8(img);
[H, W] = size(img);
RAW_BITS = numel(img) * 8; % 8bits per pixel

%% ========= Common Utility: Count/Index Mapping (for Arithmetic coding) =========
% data_vals ∈ {0..MAXVAL} (e.g., 0..255 or 0..510)
% Returns:
%  - counts_nz: frequency of 1..K symbols (only positive values)
%  - symbols_nz: actual observed symbols (0..MAXVAL) of length K
%  - toIdxLUT: lookup table of size (MAXVAL+1), mapping symbol value → 1..K index (0 if not observed)
function [counts_nz, symbols_nz, toIdxLUT] = build_counts_and_lut(data_vals, MAXVAL)
    % Compute histogram counts
    if MAXVAL == 255
        % Fast 8-bit histogram
        counts = imhist(uint8(data_vals)); % 256x1
    else
        % General case for range 0..MAXVAL
        counts = accumarray(double(data_vals(:))+1, 1, [MAXVAL+1, 1]);
    end
    nz = counts > 0;
    symbols_nz = find(nz) - 1;               % Actual symbol values (0..MAXVAL)
    counts_nz  = double(counts(nz));         % Only positive values (required by arithenco)
    toIdxLUT   = zeros(MAXVAL+1,1,'uint16'); % 0..MAXVAL → 1..K
    toIdxLUT(nz) = uint16(1:nnz(nz));
end

%% Huffman Coding
% Huffman: Build dictionary from probabilities (remove 0-prob symbols)
[counts0, ~] = imhist(img);                        % 256 bins
prob0      = counts0 / sum(counts0);
symbols0   = find(prob0>0)-1;                      % Actual symbols (0..255)
prob0_nz   = prob0(prob0>0);
dict0      = huffmandict(symbols0, prob0_nz);
stream_huff_orig = huffmanenco(img(:), dict0);
bits_huffman_orig   = numel(stream_huff_orig);

%% Arithmetic Coding
% Arithmetic: Convert to 1..K index sequence and encode
[counts0_nz, symbols0_nz, lut0] = build_counts_and_lut(img(:), 255);
seq0 = lut0(double(img(:))+1);                     % 1..K sequence
stream_arith_orig = arithenco(double(seq0), counts0_nz);
bits_arithmetic_orig   = numel(stream_arith_orig);

%% ========= Result Summary Output =========
fprintf('\n==================== RESULT SUMMARY ====================\n');
fprintf('             Raw file Bits | Huffman bits  | Arithmetic bits |  Compression Ratio\n');
fprintf('---------------------------------------------------------\n');
print_row('Original', RAW_BITS, bits_huffman_orig, bits_arithmetic_orig);
fprintf('=========================================================\n');

function print_row(name, raw_bits, bits_h, bits_a)
    crH = raw_bits/bits_h;
    crA = raw_bits/bits_a;
    fprintf('%-10s | %13d | %13d | %15d |   Huffman:%6.4f  Arithmetic:%6.4f\n', ...
        name, raw_bits ,bits_h, bits_a, crH, crA);
end
