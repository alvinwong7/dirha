close all;clear all; clc;
% Voice Activity Detection Module
% by Alvin Wong z5076152
% for undergraduate thesis 'Distant Real-Time Automatic Speech Recognition
% for Voice-Controlled Home Automation'

x = -1;
options();
while (x < 0 || x > 4)
    prompt = 'Select the desired algorithm (1-4): ';
    x = input(prompt);
end

% Initialisation


% switch x
%     case 1
%         energy();
%     case 2
%         spectral();
%     case 3
%         cepstral();
%     case 4
%         harmonicity();
% end