% MM_HW2_01_2020314916_SeungJaeOh.m %s

% Read original audio file %
[song, Fs] = audioread("sample_song.wav");

% Play the original audio %
sound(song, Fs);