clear; clc;

%% 1-a
[sine_wave, Fs_sine] = audioread('sine.wav');
% sound(sine_wave, Fs_sine)
% pause(5);

figure;
plot(sine_wave(1:1000, 1))
title('Waveform of Sine')

figure;
melSpectrogram(sine_wave,Fs_sine, ...
    'Window',hann(2048,'periodic'), ...
    'OverlapLength',1024, ...
    'FFTLength',4096, ...
    'NumBands', 256, ...
    'FrequencyRange',[62.5,8e3])
title('MelSpectrogram of Sine')

fprintf('The sampling frequency of sine wave is %d Hz.\n', Fs_sine);

%% 1-b
[square_wave, Fs_square] = audioread('square.wav');
% sound(square_wave, Fs_square)
% pause(5);

figure;
plot(square_wave(1:1000, 1))
title('Waveform of Square')

figure;
melSpectrogram(square_wave,Fs_square, ...
    'Window',hann(2048,'periodic'), ...
    'OverlapLength',1024, ...
    'FFTLength',4096, ...
    'NumBands', 256, ...
    'FrequencyRange',[62.5,8e3])
title('MelSpectrogram of Square')

fprintf('The sampling frequency of square wave is %d Hz.\n', Fs_square);

%% 1-c
[saw_wave, Fs_saw] = audioread('saw.wav');
% sound(saw_wave, Fs_saw)
% pause(5);

figure;
plot(saw_wave(1:1000, 1))
title('Waveform of Saw')

figure;
melSpectrogram(saw_wave,Fs_saw, ...
    'Window',hann(2048,'periodic'), ...
    'OverlapLength',1024, ...
    'FFTLength',4096, ...
    'NumBands', 256, ...
    'FrequencyRange',[62.5,8e3])
title('MelSpectrogram of Saw')

fprintf('The sampling frequency of saw wave is %d Hz.\n', Fs_saw);

%% 2
clear; clc;

%% 2-a
[sample, Fs] = audioread('knock.wav');
sample = sample(:, 1);
% sound(sample, Fs)
% pause(3)

poses = [-50, -25, 0, 25, 50];
for i = 1:length(poses)

    pos = poses(i);         % Change this variaunt
    pos = max(-50, min(50, pos));

    left_gain  = (70 - pos) / 140;
    right_gain = (70 + pos) / 140;

    sample_iid = [sample*left_gain, sample*right_gain];

    plot_title = sprintf('IID Position: %d', pos);
    figure;
    plot(sample_iid(1:4000, 1:2))
    title(plot_title);
    legend('Left Channel', 'Right Channel')
end

%% 2-b
[sample, Fs] = audioread('knock.wav');
sample = sample(:, 1);
% sound(sample, Fs)
% pause(3)

ear_distance = 0.20;
sound_speed  = 340;
max_ITD = ear_distance / sound_speed;

poses = [-50, -25, 0, 25, 50];
for i = 1:length(poses)

    pos = poses(i);         % Change this variant
    pos = max(-50, min(50, pos));
    ITD = (pos / 50) * max_ITD;
    delay_samples = round(abs(ITD) * Fs);

    if ITD < 0
        left  = sample;
        right = [zeros(delay_samples,1); sample(1:end-delay_samples)];
    else
        right = sample;
        left  = [zeros(delay_samples,1); sample(1:end-delay_samples)];
    end

    min_len = min(length(left), length(right));
    left  = left(1:min_len);
    right = right(1:min_len);

    sample_itd = [left, right];

    plot_title = sprintf('ITD Position: %d', pos);
    figure;
    plot(sample_itd(1:4000, 1:2))
    title(plot_title);
    legend('Left Channel', 'Right Channel')

    sound(sample_itd, Fs);
    pause(3)
end


%% 3
clear; clc;

Hz = [20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 12000, 18000];
db = [0, -40, -42, -40, -52, -55, -60, -66, -58, -57 ,0];

figure;
semilogx(Hz, db, '-o');
title('ATH Curve');
xlabel('Frequency (Hz)');
ylabel('Level (dB)');
grid on;
xlim([20 20000]);