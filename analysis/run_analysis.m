%% Analysis parameters
%ps.path  = './data/';
%ps.fname = 'cix27_25Feb2019.mat';
ps.path  = '/media/dan/My Passport/moore_lab_data/';
ps.fname = 'PV6s_10_02July2021.mat';

% Only parse behavior and return
ps.behavior_only = 1;

% Flourescence params
ps.baseInds = 1:1000;
ps.respInds = 1000:2000;
ps.dFBLWindowLen = 500;

ps.inclPy = 1;

% Force truncation of nStim for known problems
ps.nStimMax = inf;

% Pre/post are ms before/after stimulus onset
ps.dFWindow = [-1000,3000];

% Response period length
ps.lickWindow = 1500;

ps.hitRateLB = 0.3;
ps.faRateLB  = 0.02;

% Compute noise correlation densities over trials for every ms. 
% (Takes a while! Make get_nc_density_dynamics faster...)
ps.byStepNCDynamics = 0;

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
if ps.behavior_only
   load(file, 'bData', 'depth')
else
   load(file, 'bData', 'somaticF', 'frameDelta', 'depth')
   isPy = zeros(size(somaticF,1),1);

   tmp = load(file, 'somaticF_PY');
   if isfield(tmp, 'somaticF_PY')
      somaticF = [somaticF; tmp.somaticF_PY];
      isPy = [isPy; ones(size(somaticF,1),1)];   
   end
end

% Considering whisker stimulation
[stimOnInds,  ~] = getStateSamps(bData.teensyStates, 2, 1);
[catchOnInds, ~] = getStateSamps(bData.teensyStates, 3, 1);

% Timing when stimuli occur
stimInds = [stimOnInds, catchOnInds];
stimInds = sort(stimInds);
nStim    = min(length(stimInds), ps.nStimMax);

% Parse behavior and get last good trial number
[parsed, nStim] = parse_behavior(bData, stimInds, ps.lickWindow, depth, nStim, ps);
stimInds = stimInds(1:nStim);

if ps.behavior_only
   return
end
%----------------------------------------------------------

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

% Generate a vector of peri-stimulus times the reward was on
rew = parsed.response_hits == 1;
rew = rew*2000;
rew(rew == 0) = NaN;

% Get peri-stimulus time flourescence
dF  = get_PSTH(deltaF, ps.dFWindow, nStim, stimInds, []);
dFL = get_PSTH(deltaF, ps.dFWindow, nStim, stimInds, parsed.lickLatency);
dFR = get_PSTH(deltaF, ps.dFWindow, nStim, stimInds, rew);

% Get evoked activity
[dF,  evoked , pAvgs , sd ] = get_evoked_dF(dF , ps.baseInds, ps.respInds);
[dFL, evokedL, pAvgsL, sdL] = get_evoked_dF(dFL, ps.baseInds, ps.respInds);
[dFR, evokedR, pAvgsR, sdR] = get_evoked_dF(dFR, ps.baseInds, ps.respInds);

[DP_Thr, SP_all, DP_shuff, SP_shuff] = get_signal_probability_detect_probability(parsed,dF, ps.dFWindow, somaticF);


%% Get derived quantities like signal vectors, noise correlations

% Subdivide trials by contrast or orientation
%or.trials = get_stim_trials('Orientation', bData.orientation(1:nStim), bData.contrast(1:nStim));
co.trials = get_stim_trials('Contrast'   , bData.orientation(1:nStim), bData.contrast(1:nStim));

% Get the mean signals for trial type
%[or.sig, or.sig_normed] =  get_signal_vecs(evoked, or.trials, nCells);
[co.sig, co.sig_normed] =  get_signal_vecs(evoked, co.trials, nCells);

% Get correlation info
%or.corrs = get_corrs(evoked, or.sig, or.trials, nCells);
co.corrs = get_corrs(evoked, co.sig, co.trials, nCells);

%or.corrs.mnb = get_sig_vs_noise(or.corrs.sig, or.corrs.ncs, or.corrs.ncs_avg);
co.corrs.mnb = get_sig_vs_noise(co.corrs.sig, co.corrs.ncs, co.corrs.ncs_avg);

%% Slice-wise Correlations
if ps.byStepNCDynamics
   rho.miss = get_noise_corr_dynamics(dF, parsed.allMissTrials);
   rho.hit  = get_noise_corr_dynamics(dF, parsed.allHitTrials );

   rho.high = get_noise_corr_dynamics(dF, find(co.trials{3}) );
   rho.low  = get_noise_corr_dynamics(dF, find(co.trials{1}) );

   rho.high_miss = get_noise_corr_dynamics(dF, intersect(find(co.trials{3}),parsed.allMissTrials) );
   rho.low_hit   = get_noise_corr_dynamics(dF, intersect(find(co.trials{1}),parsed.allHitTrials ) );

   rho.high_hit = get_noise_corr_dynamics(dF, intersect(find(co.trials{3}),parsed.allHitTrials ) );
   rho.low_miss = get_noise_corr_dynamics(dF, intersect(find(co.trials{1}),parsed.allMissTrials) );

   kapa.miss = get_nc_density_dynamics(rho.miss);
   kapa.hit  = get_nc_density_dynamics(rho.hit );

   kapa.high = get_nc_density_dynamics(rho.high);
   kapa.low  = get_nc_density_dynamics(rho.low );

   kapa.high_hit = get_nc_density_dynamics(rho.high_hit);
   kapa.low_miss = get_nc_density_dynamics(rho.low_miss);

   kapa.high_miss = get_nc_density_dynamics(rho.high_miss);
   kapa.low_hit   = get_nc_density_dynamics(rho.low_hit  );
   
   plot_all_ncdd(kapa)
end


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

