close all;clear all; clc;
% Voice Activity Detection
% by Alvin Wong z5076152
% for undergraduate thesis 'Distant Real-Time Automatic Speech Recognition
% for Voice-Controlled Home Automation'

audioSource = audioDeviceReader('OutputDataType', 'single', ...
                                'NumChannels', 1, ...
                                'SamplesPerFrame', 80, ...
                                'SampleRate', 8000);
                            
% Create a time scope to visualize the VAD decision (channel 1) and the
% speech data (channel 2)
% scope = dsp.TimeScope(2, 'SampleRate', [8000/80 8000], ...
%                       'BufferLength', 80000, ...
%                       'YLimits', [-0.3 1.1], ...
%                       'ShowGrid', true, ...
%                       'Title','Decision speech and speech data', ...
%                       'TimeSpanOverrunAction','Scroll');

% Initialise VAD parameters
VAD_cst_param = vadInitCstParams;
clear vadG729

% Initialise time/saving parameters
path = fullfile(pwd, 'test.sh');
time = 0;
time_off = 0;
audio = [];
fs = 8000;
tic
decision = 0;
check = 'finished';
submitted = 0;
data = [];
while(1)
  speech = audioSource();
  % Call the VAD algorithm
  % decision = vadG729(speech, VAD_cst_param);
  value = sum(abs(fft(speech)).^2)/numel(speech);
  
  if (value > 0.02)
      time = time + toc;
      time_off = 0;
      decision = 1;
  else
      time_off = time_off + toc;
  end
  tic
  if length(data) < 800
    data = [data speech'];
  else
      data(1:length(data)-length(speech)) = data(1+length(speech):length(data));
      data(1+length(data)-length(speech):length(data)) = speech;
  end
      
  audio = [audio speech'];
  % Reset
  if (time_off > 1)
      if (time > 0.2)
          fprintf('Sending for translation\n')
          audiowrite('tmp.wav', audio', fs, 'BitsPerSample', 16);
          if submitted == 1
              fprintf('Waiting!\n')
              wait(job);
              load(job);
              delete(job);
              fprintf(text)
          end
          job = batch('asr');
          submitted = 1;
      end
      decision = 0;
      time = 0;
      audio = [];
      time_off = 0;
  end
  if submitted == 1 && strcmp(check,job.State)
    load(job);
    delete(job);
    fprintf(text);
    submitted = 0;
  end
  % Plot speech frame and decision: 1 for speech, 0 for silence
  pause(0.01)
  plot(data);
  ylim([-0.1 0.1])
end
release(scope);
release(audioSource);