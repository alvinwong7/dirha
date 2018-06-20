function speech = energy(audio)
% Energy-based VAD
% by Alvin Wong z5076152
speech = sum(abs(fft(audio)).^2)/numel(audio);
end