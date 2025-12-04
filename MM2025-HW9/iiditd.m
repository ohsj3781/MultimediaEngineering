clear; clc;

[x, fs] = audioread('walk.wav');
if size(x,2) > 1
    x = mean(x, 2);
end

ear_distance = 0.20;
sound_speed  = 340;
max_ITD = ear_distance / sound_speed;
maxDelaySamples = ceil(max_ITD * fs) + 2;

fprintf("Max ITD = %.3f ms\n", max_ITD*1000);

hFig = figure('Name','IID + ITD Real-time Demo', ...
              'NumberTitle','off', ...
              'Position',[200 200 500 150]);

uicontrol('Style','text', ...
          'Position',[80 90 340 20], ...
          'String','Position (-50 = left, +50 = right)', ...
          'FontSize',10);

hSlider = uicontrol('Style','slider', ...
                    'Min',-50,'Max',50,'Value',0, ...
                    'Position',[80 70 340 20]);

hText = uicontrol('Style','text', ...
                  'Position',[200 40 100 20], ...
                  'String','pos = 0.0', ...
                  'FontSize',10);

drawnow;

frameLen = 32;
deviceWriter = audioDeviceWriter('SampleRate', fs);

vfdL = dsp.VariableFractionalDelay('MaximumDelay', maxDelaySamples);
vfdR = dsp.VariableFractionalDelay('MaximumDelay', maxDelaySamples);

N = numel(x);
idx = 1;
frameCount = 0;

while idx <= N && ishandle(hFig)
    frame = x(idx : min(idx+frameLen-1, N));
    if numel(frame) < frameLen
        frame = [frame; zeros(frameLen-numel(frame),1)];
    end

    pos = get(hSlider, 'Value');

    ITD = (pos / 50) * max_ITD;
    delaySamples = abs(ITD) * fs;

    left_gain  = (70 - pos) / 140;
    right_gain = (70 + pos) / 140;

    if ITD < 0
        dL = 0;
        dR = delaySamples;
    else
        dL = delaySamples;
        dR = 0;
    end

    outL = vfdL(frame, dL);
    outR = vfdR(frame, dR);

    outL = outL * left_gain;
    outR = outR * right_gain;

    stereoFrame = [outL, outR];
    deviceWriter(stereoFrame);

    idx = idx + frameLen;
    frameCount = frameCount + 1;

    if mod(frameCount, 10) == 0
        set(hText, 'String', sprintf('pos = %.1f', pos));
        drawnow limitrate;
    end
end

release(deviceWriter);
disp('Playback finished or window closed.');
