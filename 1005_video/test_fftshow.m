t = 0 : 0.01 : 5-0.01

f1 = 10;
f2 = 20;

x = 5 * sin(2* pi * f1 * t ) + 2 * cos(2* pi * f2 * t);

DFTandShow(t,x);

%%

Fs = 1000;            % Sampling frequency
T = 1/Fs;             % Sampling period
L = 1000;             % Length of signal
t = (0:L-1)*T;        % Time vector

X = 0.7*sin(2*pi*250*t) + sin(2*pi*120*t);

N = 1000;
Y = fft(X,N);

P2 = abs(Y/N);
P1 = P2(1:N/2+1);
P1(2:end-1) = 2*P1(2:end-1);

figure
f = Fs*(0:(N/2))/N;
plot(f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')