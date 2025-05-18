clc;
clear all;
close all;
pkg load signal


M = 64;
N = 512;

hM = floor(M/2);
hN = floor(N/2);


f = (-N/2:N/2-1)'/N;


windows = {
    hanning(M), 'hanning';
    hamming(M), 'hamming';
    ones(M,1), 'rectangular';
    blackman(M), 'blackman'
    };

figure; hold on;
for k = 1:size(windows,1)
    w = windows{k,1};
    label = windows{k,2};


    buf = zeros(N,1);
    start_idx = hN - hM + 1;
    end_idx = start_idx + M - 1;
    buf(start_idx:end_idx) = w;


    X = fft(buf);
    X_shifted = fftshift(X);
    magX = abs(X_shifted);
    magX = magX / sum(w);
    dbX = 20*log10(magX + eps);
    plot(f, dbX, 'LineWidth',1.1,'DisplayName', label);

    % Save frequency and magnitude dB to .dat file
    data = [f, dbX];
    filename = sprintf('%s_window.dat', label);
    save('-ascii', filename, 'data');
end
% Plot settings
xlabel('Normalized Frequency (cycles/sample)');
ylabel('Magnitude (dB)');
title('FFT Magnitude of Various Windows (Zero-Padded and Centered)');
grid on;
ylim([-80 5]);
legend('location', 'northeast');
hold off;
