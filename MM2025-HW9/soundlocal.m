clear; clc;

[sample, Fs] = audioread('knock.wav');
sample = sample(:, 1);
sound(sample, Fs)
pause(3)

%% 2(a). Interaural Intensity Difference (IID)
pos = -50;         % Change this variant
pos = max(-50, min(50, pos));

left_gain  = (70 - pos) / 140;
right_gain = (70 + pos) / 140;

sample_iid = [sample*left_gain, sample*right_gain];

sound(sample_iid, Fs);
pause(3)


%% 2(b). Interaural Time Difference (ITD)
ear_distance = 0.20;
sound_speed  = 340;
max_ITD = ear_distance / sound_speed;

pos = 30;         % Change this variant
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
sound(sample_itd, Fs);
pause(3)