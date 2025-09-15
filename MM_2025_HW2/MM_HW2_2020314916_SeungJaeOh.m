% MM_HW2_01_2020314916_SeungJaeOh.m %s

% Read original audio file %
[song, Fs] = audioread("sample_song.wav");

% Requirement 1.a: Play the original audio %
sound(song, Fs);

% Requirement 1.b: resample the audio with 24kHz, 12kHz and 8kHz %
samplingFss = [24000, 12000, 8000];

for samplingFs = samplingFss
    audio_sampled = song(1:Fs/samplingFs:end, :);
    audiowrite("sample_song_" + string(samplingFs/1000) + "kHz_sampled.wav", audio_sampled, samplingFs);
end

% Requirement 3.a: Quantize the original audio file to 8-bit, 4-bit, 2-bit resolutions %
[song, Fs] = audioread("sample_song.wav", "native");
max_value = 2^32;
quant_bits = [8, 4, 2];

for quant_bit = quant_bits
    bit_scaling = 2^(32-quant_bit);
    song_quantized = floor(double(song)./bit_scaling).*bit_scaling;
    song_quantized = int32(song_quantized.*max_value./(max(song_quantized)-min(song_quantized))-(max(song_quantized)+min(song_quantized))*0.5);
    audiowrite("sample_song_" + string(quant_bit) + "bit.wav", song_quantized, Fs);
end