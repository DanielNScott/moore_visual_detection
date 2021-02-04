function [] = plot_all(evoked, sig, sig_normed, stim_trials, corrs, parsed, contrast, folder, save)

% Make Plots
close all;

% Make and go to folder
if save
   mkdir(folder);
   cd(folderr)
end

% Define rank orderings of total correlation in each case
[~, ranks1] = sort(sum(abs(corrs.ncs{1})), 'descend');
[~, ranks2] = sort(sum(abs(corrs.ncs{2})), 'descend');
[~, ranks3] = sort(sum(abs(corrs.ncs{3})), 'descend');

% Plot the raw evoked activity correlation
plot_raw_corr(corrs.raw, save)

% Plot top noise components by stimulus
plot_ncs_evecs(corrs.ncs_evecs, corrs.ncs_evals, save)

% Plot the evoked activity, zscored over time, by neuron and condition
plot_zscored_evoked(evoked, stim_trials, save)

% Plot 3 dim noise correlation graphs
plot_3d_ncs_on_sig(sig, corrs.ncs, save)

% Plot the noise correlation matrices
plot_nc_mats(corrs.ncs, ranks1, ranks2, ranks3, save)

% Plot the noise corrs as functions of signal tuning
plot_sig_vs_noise(corrs.sig, corrs.ncs, corrs.ncs_avg, save)

% Plot the signal correlation matrix as points in signal space
plot_normed_sigcorr(sig_normed, save)

% Plot the rankings of how strongly each neurons correlates with others by signal
plot_total_corr_ranks(ranks1, ranks2, ranks3, save)

% Plot neuro- and psychometric functions
%clevels = get_contrast_levels(contrast);
%plot_neurometric(evoked, clevels);
%plot_psychometric(parsed, clevels);

if save
   cd('..')
end

end