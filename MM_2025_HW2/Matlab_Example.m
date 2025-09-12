%% Sampling

% Read the original audio file
[song, sampling_frequency_song] = audioread("sample_song.wav");
sampling_frequency_song
sound(song, sampling_frequency_song)

% Resample the audio in 16kHz and save the sampled file
Fs_sampling_sacle = 3; 
Fs_sampled = sampling_frequency_song / Fs_sampling_sacle; % 48k/3 = 16kHz
audio_sampled = song(1:Fs_sampling_sacle:end, :);
audiowrite("sample_song_16kHz_sampled.wav", audio_sampled, Fs_sampled);
%sound(audio_sampled, Fs_sampled)

%% Aliasing
% Create time vectors for plotting
t_48kHz = (0:length(song)-1) / sampling_frequency_song;
t_sampled = (0:length(audio_sampled)-1) / Fs_sampled;

% Plot Waves
figure;
start_second = 5.09; end_second = 5.10;

fs = sampling_frequency_song; start_time = int32(start_second*fs + 1); end_time = int32(end_second*fs);
subplot(2, 1, 1);
plot(t_48kHz(start_time:end_time), ...
    song(start_time:end_time, 1), "Color", "r")
title("Fs=48kHz")

fs = Fs_sampled; start_time = start_second*fs + 1; end_time = end_second*fs;
subplot(2, 1, 2);
plot(t_sampled(start_time:end_time), ...
    audio_sampled(start_time:end_time, 1), "Color", "b")
title("Fs=16kHz")
%% Quantization
[song, sampling_frequency_song] = audioread("sample_song.wav", "native");
% Quantize
max_value = 2^32;   quant_bit = 8;
bit_scaling = 2^(32-quant_bit);

song_8bit = floor(double(song)./bit_scaling).*bit_scaling;
% Normalize
song_8bit = int32(song_8bit.*max_value./(max(song_8bit)-min(song_8bit))-(max(song_8bit)+min(song_8bit))*0.5);
% Save the audio
audiowrite("sample_song_8bit.wav", song_8bit, sampling_frequency_song)

% Plot the waveform of the audios
figure;
start_second = 0.0; end_second = 0.1;

fs = sampling_frequency_song; start_time = int32(start_second*fs + 1); end_time = int32(end_second*fs);
subplot(2, 1, 1);
plot(song(start_time:end_time, 1))

subplot(2, 1, 2);
plot(song_8bit(start_time:end_time, 1))
