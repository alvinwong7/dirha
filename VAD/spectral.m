function speech = spectral(audio)
% Spectral-domain VAD
% by Alvin Wong z5076152
speech = abs(fft(audio))

end