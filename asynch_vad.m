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
scope = dsp.TimeScope(2, 'SampleRate', [8000/80 8000], ...
                      'BufferLength', 80000, ...
                      'YLimits', [-0.3 1.1], ...
                      'ShowGrid', true, ...
                      'Title','Decision speech and speech data', ...
                      'TimeSpanOverrunAction','Scroll');

% Initialise VAD parameters
VAD_cst_param = vadInitCstParams;
clear vadG729

% Initialise time/saving parameters
path = fullfile(pwd, 'test.sh');
time = 0;
time_off = 0;
audio = [];
fs = 8000;
decision = 0;
workers = zeros(1,12);
p = gcp();
i = 1;
submit = 0;
tic
fprintf('Starting ASR\n')
while(1)
  speech = audioSource();
  % Call the VAD algorithm
  % decision = vadG729(speech, VAD_cst_param);
  value = sum(abs(fft(speech)).^2)/numel(speech);
  
  if (value > 0.01)
      time = time + toc;
      time_off = 0;
      decision = 1;
  else
      time_off = time_off + toc;
  end
  tic
      
  audio = [audio speech'];
  % Reset
  if (time_off > 1)
      if (time > 0.2)
          for num = 1:12
              if workers(num) == 0
                  break
              end
              if num == 12
                  [i, text] = fetchNext(f);
                  if ~isempty(i)
                      fprintf(text);
                      workers(i) = 0;
                      filename = convertToFileName(i);
                      path = fullfile(pwd, filename);
                      delete(filename)
                  end
              end
          end
          workers(num) = 1;
          filename = convertToFileName(num);
          audiowrite(filename, audio', fs, 'BitsPerSample', 16);
          f(i) = parfeval(p,@func_asr,1,filename);
          submit = 1;
      end
      decision = 0;
      time = 0;
      audio = [];
      time_off = 0;
  end
  if submit == 1 && ~all([f.Read])
    text = '';
    [i, text] = fetchNext(f, 0.001);
    
    if ~isempty(i)
        fprintf(text)
        workers(i) = 0;
        filename = convertToFileName(i);
        path = fullfile(pwd, filename);
        delete(filename)
    end
  end
  % Plot speech frame and decision: 1 for speech, 0 for silence
  scope(decision, speech);
end
release(scope);
release(audioSource);