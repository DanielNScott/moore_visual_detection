
function [] = multitaper(sig)

% Setup experiment variables
sample_rate   = 1000;
time_step     = 1/sample_rate;
window_len    = 0.5;
window_len_ms = window_len*1000;

freq_res = 1/window_len;
fNyquist = sample_rate/2;
f_grid   = 0:freq_res:fNyquist;

total_n_sample = length(sig);

mtpr_spectrogram = NaN( length(f_grid), total_n_sample/(window_len_ms/2)-2);

j = 0;
for i = 1:(window_len_ms/2):(total_n_sample - window_len_ms)
    j = j + 1;
    
    window = i:(i + window_len*sample_rate - 1);
    t_series = sig(window)';
    t_series = t_series - mean(t_series);
    n_sample = length(t_series);
    

    %-------------------------------------------%
    % Multi-taper
    %-------------------------------------------%
    bandwidth = 8; %bandwidth in Hz
    NFFT      = length(t_series);
    nTapers   = [];
    removeTemporalMean = true;
    removeEnsembleMean = true;

    % [Pxx, Pyy, Pxy, XYphi, Cxy, F, nTapers] = multitaperSpectrum(...)
    [Smt, ~, ~, ~, ~, ~, ~] = ...
        multitaperSpectrum(t_series, t_series, sample_rate, bandwidth, NFFT,...
                           removeTemporalMean, removeEnsembleMean, nTapers);
    
    mtpr_spectrogram(:,j) = 10*log10(Smt);
end

t = 1:length(sig);

figure()
topf = ceil(40/freq_res);
imagesc(t,f_grid(2:topf),mtpr_spectrogram(2:topf,:))
set(gca, 'YDir', 'normal')
title('Multi Taper Based Spectrogram')
xlabel('Time [s]')
ylabel('Freq. [Hz]')

end