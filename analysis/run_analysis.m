%% Analysis parameters
file = './data/cix22_25Feb2019.mat';

baseInds = 1:1000;
respInds = 1000:2000;
dFBLWindowLen = 500;

% Pre/post are ms before/after stimulus onset
dFWindow = [-1000,3000];
nStim = 120;

% Response period length
lickWindow = 1500;

%% Plot parameters
save = 0;
folder = 'PV_CIX22_04Orientation_Figs';

%% Load and reformat info
% Load necessary file contents
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
somaticF_BLs = slidingBaseline(somaticF, dFBLWindowLen, blCutOffs);
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

% Parse behavior
parsed = parse_behavior(bData, stimInds, lickWindow, depth, nStim);

% Get peri-stimulus time flourescence
dF = get_PSTH(deltaF, dFWindow, nStim, stimInds);

% Get evoked activity
evoked = get_evoked_dF(dF, baseInds, respInds);

%% Get derived quantities like signal vectors, noise correlations

% Subdivide trials by contrast or orientation
stim_trials = get_stim_trials('Orientation', bData.orientation(1:nStim), bData.contrast(1:nStim));

% Get the mean signals for trial type
[sig, sig_normed] =  get_signal_vecs(evoked, stim_trials, nCells);

% Get correlation info 
corrs = get_corrs(evoked, sig, stim_trials, nCells);

%% Plot stuff
plot_all(evoked, sig, sig_normed, stim_trials, corrs, parsed, bdata.Contrast, folder, save)


%% 
get_plot_SPDPs(bData, parsed, zStackCellMat, frameDelta, dFWindow, somaticF)

%% Unused material: To delete in next commit

%[rewardOnInds, rewardOnVect] = getStateSamps(bData.teensyStates,4,1);
%[licks,           licksVect] = getStateSamps(bData.thresholdedLicks, 1, 1);

% Find the sample number of each reward and lick
%[rewardOnInds,  rewardOnVect] = getStateSamps(bData.teensyStates, 4, 1);
%[licks,            licksVect] = getStateSamps(bData.thresholdedLicks, 1, 1);
