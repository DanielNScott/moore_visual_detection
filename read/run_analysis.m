

%% Plot parameters
save_plts = 0;
folder = 'PV_CIX22_04Orientation_Figs';

%% Load and reformat info
% Load necessary file contents
file = [ps.path, ps.fname];

%----------------------------------------------------------

% Load behavior
if ps.re_parse_behavior
   parsed = parse_behavior_from_file(ps);
else
   load([file(1:(end-4)) '_parsed.mat'])
end

% Load fluorescence
fluor = parse_fluorescence_from_file(file, ps, parsed);

% Load data quality
load(ps.dqualf)

% Get the valid data masks
[valid_msk, valid_trls] = get_valid_from_file(ps, dqual);

% Get a censored parsed structure
parsed_c = censor_parsed(parsed, valid_msk, valid_trls);

% Censor arrays
fluor.dFc  = fluor.dF( valid_msk, :, :);
%dFLc = dFL(valid_msk, :, :);
%dFRc = dFR(valid_msk, :, :);

fluor.evokedc  = fluor.evoked( :, valid_msk);
%evokedLc = evokedL(:, valid_msk);
%evokedRc = evokedR(:, valid_msk);


return

%%%% Unreachable analyses

% SPs are still using contrast, which is kind of hacked
[DP_Thr  , SP_all  , DP_shuff  , SP_shuff  ] = get_SPDP(parsed  , dF, ps.dFWindow);
[DP_Thr_c, SP_all_c, DP_shuff_c, SP_shuff_c] = get_SPDP(parsed_c, dF, ps.dFWindow);

% 
slevs = get_contrast_levels(parsed_c.contrast);


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

