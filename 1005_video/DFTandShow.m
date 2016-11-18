function [f power] = DFTandShow(t,x)
if size(t) == 1
    sampling = t;
else
    sampling = t(2) - t(1);
end

% transpose so that row become longer
if size(x,1) < size(x,2)
    x = x.';
end

sf = 1/sampling % Sample frequency (Hz)
L = max(size(x)) % data length(window length)

% calc average
average = ones(1,L)*x(:,1) / L;

x = x - average;

% fft
N = pow2(nextpow2(L));  % Transform length
N = 512;

y = fft(x,N); %fft

f = (0:N-1)*(sf/N);     % Frequency range ( sampling fq / fft length )
power =abs(y/N) *2 ;   % Power of the DFT

figure;
plot(f,power)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('frequency (Hz)')
ylabel('Power')
grid on;
xlim([0 f(floor(N/2))]) % cut off faster frequency than nyquist freq
end
