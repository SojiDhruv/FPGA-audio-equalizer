% Dhruv Sojitra
% 10/23/2026
% This script produces 3-band filter coefficients for an FPGA 
% targeted equalizer. It includes plots showing the coefficients, 
% hamming window, an arbitrary test signal, and the filtered frequency
% components of the test signal.
%

% Defined:
% Bass: 0 - 250 Hz
% Mids: 250 - 4k Hz
% Treble: 4k - Sample rate/2 Hz
% Sample rate: 48k Hz
%
% Transitions:
% bass-mid: 150-350 Hz (200 Hz)
% mid-treble: 2.5k - 5.5k (3k Hz)
%

clear;
clc;
close all;

%% variables
SAMPLE_RATE = 48000;

BASS_HIGH = 250;

MID_LOW = 250;
MID_HIGH = 4000;

TREBLE_LOW = 4000;
TREBLE_HIGH = SAMPLE_RATE/2;

% narrowest transition width
BASS_MID = 200;

% using narrowest transition width 
N = ceil((3.3)*(SAMPLE_RATE) / BASS_MID); 
n = 0:1:N-1;

% 2^13 = 8192 evenly spaced 
w = linspace(-pi, pi, 8192);

% cutoff frequencies
wc = struct( ...
    'wc_bass_high', 2*pi*BASS_HIGH / SAMPLE_RATE, ...
    'wc_mid_low', 2*pi*MID_LOW / SAMPLE_RATE, ...
    'wc_mid_high', 2*pi*MID_HIGH / SAMPLE_RATE, ...
    'wc_treble_low', 2*pi*TREBLE_LOW / SAMPLE_RATE, ...
    'wc_treble_high', 2*pi*TREBLE_HIGH / SAMPLE_RATE ...
);

%% hamming window
window = 0.54 - 0.46*cos((2*pi*n)/(N-1)); 

% plot hamming window
figure(1);
plot(n, window);
title('Hamming Window');
xlabel('n');
ylabel('$w[n]$', 'Interpreter', 'latex');

%% generate frequency responses
[h_lp, h_mp, h_hp, h_lp_windowed, h_mp_windowed, h_hp_windowed] ...
    = frequency_response(n, N, wc, window);

% plot filter coefficients
figure(2);

coef1 = subplot(3, 1, 1);
plot(coef1, n, h_lp);
title(coef1, 'FIR Filter Coefs LP');
xlabel(coef1, 'n');
ylabel(coef1, '$h[n]$', 'Interpreter', 'latex');

coef2 = subplot(3, 1, 2);
plot(coef2, n, h_mp);
title(coef2, 'FIR Filter Coefs MP');
xlabel(coef2, 'n');
ylabel(coef2, '$h[n]$', 'Interpreter', 'latex');

coef3 = subplot(3, 1, 3);
plot(coef3, n, h_hp);
title(coef3, 'FIR Filter Coefs HP');
xlabel(coef3, 'n');
ylabel(coef3, '$h[n]$', 'Interpreter', 'latex');

output_mem(h_lp_windowed, N, "LP_Coefficients");
output_mem(h_mp_windowed, N, "MP_Coefficients");
output_mem(h_hp_windowed, N, "HP_Coefficients");

%% generate test signal for 0.1s
[t_plot, t, x_bass, x_mids, x_treble, x_test] ...
    = test_signal(SAMPLE_RATE, N, h_lp_windowed, h_mp_windowed, h_hp_windowed);    

% plot test signal
figure(3);
plot(t, x_test);
title('Test Signal');
xlabel('t');
ylabel('$x[n]$', 'Interpreter', 'latex');

% plot filtered signals
figure(4);

filtered1 = subplot(3, 1, 1);
plot(filtered1, t_plot, x_bass);
title(filtered1, 'Bass of $x[n]$', 'Interpreter', 'latex');
xlabel(filtered1, 't');
ylabel(filtered1, '$x[n]$', 'Interpreter', 'latex');

filtered2 = subplot(3, 1, 2);
plot(filtered2, t_plot, x_mids);
title(filtered2, 'Mids of $x[n]$', 'Interpreter', 'latex');
xlabel(filtered2, 't');
ylabel(filtered2, '$x[n]$', 'Interpreter', 'latex');

filtered3 = subplot(3, 1, 3);
plot(filtered3, t_plot, x_treble);
title(filtered3, 'Treble of $x[n]$', 'Interpreter', 'latex');
xlabel(filtered3, 't');
ylabel(filtered3, '$x[n]$', 'Interpreter', 'latex');
