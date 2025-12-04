clear; clc;

fs = 44100;
% Change this variant
% [20, 50, 100, 200, 500, 1000, 2000, 5000, 10000, 12000, 18000
freq = 1000;

hFig = figure('Name','Sine', ...
    'NumberTitle','off', ...
    'Position',[200 200 500 150]);

uicontrol('Style','text', ...
    'Position',[80 90 340 20], ...
    'String','Level (dB, 0 = full, -100 = very quiet)', ...
    'FontSize',10);

hSlider = uicontrol('Style','slider', ...
    'Min',-100,'Max',0,'Value',0, ...
    'Position',[80 70 340 20]);

hText = uicontrol('Style','text', ...
    'Position',[200 40 100 20], ...
    'String','dB = 0.0', ...
    'FontSize',10);

drawnow;

frameLen = 32;
deviceWriter = audioDeviceWriter('SampleRate', fs);

phase = 0;
frameCount = 0;

smooth_dB = 0;
tau = 0.05;
alpha = exp(-frameLen/(fs*tau));

while ishandle(hFig)
    t = (0:frameLen-1)'/fs;
    x = sin(2*pi*freq*t + phase);
    phase = phase + 2*pi*freq*frameLen/fs;
    phase = mod(phase, 2*pi);

    target_dB = get(hSlider, 'Value');
    smooth_dB = alpha*smooth_dB + (1-alpha)*target_dB;

    amp = 10^(smooth_dB/20);
    y = amp * x;

    stereoFrame = [y y];
    deviceWriter(stereoFrame);

    frameCount = frameCount + 1;

    if mod(frameCount, 10) == 0
        set(hText, 'String', sprintf('dB = %.1f', smooth_dB));
        drawnow limitrate;
    end
end

release(deviceWriter);
disp('Playback finished or window closed.');
