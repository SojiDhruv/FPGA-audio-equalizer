function [t_plot, t, x_b, x_m, x_t, x_test] = test_signal(fs, N, lp, mp, hp)
    L = 0.1 * fs;
    n_test = 0:1:L-1;
    t = n_test / fs;
    f1 = 100;
    f2 = 1000;
    f3 = 10000;
    
    x_test = cos(2*pi*f1*t) + cos(2*pi*f2*t) + cos(2*pi*f3*t);
    
    % filtered signals
    x_b = conv(x_test, lp);
    x_m = conv(x_test, mp);
    x_t = conv(x_test, hp);
    
    t_plot = (0:1:(L + N - 2)) / fs;
end