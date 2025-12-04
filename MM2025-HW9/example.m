clear; clc;

[sine_wave, Fs_sine] = audioread('sine.wav');
% [sine_wave, Fs_sine] = audioread('square.wav');
% [sine_wave, Fs_sine] = audioread('saw.wav');
sound(sine_wave, Fs_sine)
pause(5);

figure;
plot(sine_wave(1:4000, 1))
title('Waveform of Sine')

figure;
melSpectrogram(sine_wave,Fs_sine, ...
    'Window',hann(2048,'periodic'), ...
    'OverlapLength',1024, ...
    'FFTLength',4096, ...
    'NumBands', 256, ...
    'FrequencyRange',[62.5,8e3])
title('MelSpectrogram of Sine')