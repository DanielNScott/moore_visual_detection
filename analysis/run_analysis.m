%% Analysis parameters
%ps.path  = './data/';
%ps.fname = 'cix22_04Feb2019.mat';

ps.baseInds = 1:1000;
ps.respInds = 1000:2000;
ps.dFBLWindowLen = 500;

% Pre/post are ms before/after stimulus onset
ps.dFWindow = [-1000,3000];

% Response period length
ps.lickWindow = 1500;

ps.hitRateLB = 0.3;
ps.faRateLB  = 0.02;

% Save the processed .mat file?
ps.save_proc = 1;

% Plot things?
ps.plot_flg = 0;

%% Plot parameters
save_plts = 0;
folder = 'PV_CIX22_04Orientation_Figs';

%% Load and reformat info
% Load necessary file contents
file = [ps.path, ps.fname];
load(file, 'bData', 'somaticF', 'frameDelta', 'depth')

% 100k frames taken @ 30 Hz

% Align sample frequencies
% frametimes: timing of frames in ms
% imTime: timing in seconds
[nCells, nFrames] = size(somaticF);
ms2s = 1000;

frameTimes   = (frameDelta:frameDelta:frameDelta*nFrames)*ms2s;
frameTimesMs = frameTimes/ms2s;

% baseline data with df/f
blCutOffs    = computeQuantileCutoffs(somaticF);
somaticF_BLs = slidingBaseline(somaticF, ps.dFBLWindowLen, blCutOffs);
deltaFDS     = (somaticF - somaticF_BLs)./somaticF_BLs;

% upsample data
tseries = timeseries(deltaFDS', frameTimesMs);
tseries = resample(tseries, bData.sessionTime);
deltaF  = tseries.Data;

% Considering whisker stimulation
[stimOnInds,  ~] = getStateSamps(bData.teensyStates, 2, 1);
[catchOnInds, ~] = getStateSamps(bData.teensyStates, 3, 1);

% Timing when stimuli occur
stimInds = [stimOnInds, catchOnInds];
stimInds = sort(stimInds);
nStim    = length(stimInds);

% Parse behavior and get last good trial number
[parsed, nStim] = parse_behavior(bData, stimInds, ps.lickWindow, depth, nStim, ps);
stimInds = stimInds(1:nStim);

% Get peri-stimulus time flourescence
dF = get_PSTH(deltaF, ps.dFWindow, nStim, stimInds);

% Get evoked activity
evoked = get_evoked_dF(dF, ps.baseInds, ps.respInds);

[DP_Thr, SP_all, DP_shuff, SP_shuff] = get_signal_probability_detect_probability(parsed,dF, ps.dFWindow, somaticF);


%% Get derived quantities like signal vectors, noise correlations

% Subdivide trials by contrast or orientation
or.trials = get_stim_trials('Orientation', bData.orientation(1:nStim), bData.contrast(1:nStim));
co.trials = get_stim_trials('Contrast'   , bData.orientation(1:nStim), bData.contrast(1:nStim));

% Get the mean signals for trial type
[or.sig, or.sig_normed] =  get_signal_vecs(evoked, or.trials, nCells);
[co.sig, co.sig_normed] =  get_signal_vecs(evoked, co.trials, nCells);

% Get correlation info
or.corrs = get_corrs(evoked, or.sig, or.trials, nCells);
co.corrs = get_corrs(evoked, co.sig, or.trials, nCells);

or.corrs.mnb = get_sig_vs_noise(or.corrs.sig, or.corrs.ncs, or.corrs.ncs_avg);
co.corrs.mnb = get_sig_vs_noise(co.corrs.sig, co.corrs.ncs, co.corrs.ncs_avg);

%% Package the processed data as a structure
if ps.save_proc
   proc.ID        = ps.fname(4:5);
   proc.date      = ps.fname(7:15);
   proc.params    = ps;
   proc.evoked    = evoked;
   proc.dF        = dF;
   proc.blCutOffs = blCutOffs;
   proc.parsed    = parsed;
   proc.stimInds  = stimInds;

   proc.or = or;
   proc.co = co;

   proc.stim.contrast    = bData.contrast;
   proc.stim.orientation = bData.orientation;

   save([ps.path, ps.fname(1:(end-4)), '_proc.mat'], 'proc');
end

%% Plot stuff
if ps.plot_flg

   plot_all(evoked, or.sig, or.sig_normed, or.trials, or.corrs, parsed, bData.contrast, [folder, '_O'], save_plts)
   plot_all(evoked, co.sig, co.sig_normed, co.trials, co.corrs, parsed, bData.contrast, [folder, '_C'], save_plts)
   plot_parsed_behavior(parsed)
   plot_signal_probability_detect_probability(SP_all, DP_Thr, DP_shuff, SP_shuff)
end

