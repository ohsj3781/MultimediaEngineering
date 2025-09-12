clear; clc;

%% Config
sample_path = "samples/";
output_path = "outputs/";
DURATION = 8;
fs_list = [24000, 12000, 8000];

%% Aliasing

% Load sine wave
[song, Fs] = audioread("sample_song.wav");
[song_24kHz, Fs_song_24kHz] = audioread("sample_song_24kHz_sampled.wav");
[song_12kHz, Fs_song_12kHz] = audioread("sample_song_12kHz_sampled.wav");
[song_8kHz, Fs_song_8kHz] = audioread("sample_song_8kHz_sampled.wav");

% Create time vectors for plotting
t_48kHz = (0:length(song)-1) / Fs;
t_24kHz = (0:length(song_24kHz)-1) / Fs_song_24kHz;
t_12kHz = (0:length(song_12kHz)-1) / Fs_song_12kHz;
t_8kHz = (0:length(song_8kHz)-1) / Fs_song_8kHz;

% Plot Waves
figure;
start_second = 5.09; end_second = 5.10;

fs = Fs; start_time = int32(start_second*fs + 1); end_time = int32(end_second*fs);
subplot(4, 1, 1);
plot(t_48kHz(start_time:end_time), ...
    song(start_time:end_time, 1), "Color", "r")

title("Fs=48kHz")

fs = Fs_song_24kHz; start_time = int32(start_second*fs + 1); end_time = int32(end_second*fs);
subplot(4, 1, 2);
plot(t_24kHz(start_time:end_time), ...
    song_24kHz(start_time:end_time, 1), "Color", "c")
title("Fs=24kHz")

fs = Fs_song_12kHz; start_time = int32(start_second*fs + 1); end_time = int32(end_second*fs);
subplot(4, 1, 3);
plot(t_12kHz(start_time:end_time), ...
    song_12kHz(start_time:end_time, 1), "Color", "b")
title("Fs=12kHz")

fs = Fs_song_8kHz; start_time = int32(start_second*fs + 1); end_time = int32(end_second*fs);
subplot(4, 1, 4);
plot(t_8kHz(start_time:end_time), ...
    song_8kHz(start_time:end_time, 1), "Color", "g")
title("Fs=8kHz")