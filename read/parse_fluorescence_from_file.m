function flr = parse_fluorescence_from_file(file, ps, parsed, stimInds, filter)

load(file, 'bData', 'somaticF', 'frameDelta', 'depth')
isPy = zeros(size(somaticF,1),1);

has_PY = 0;
if has_PY
   tmp = load(file, 'somaticF_PY');
   somaticF = [somaticF; tmp.somaticF_PY];
   isPy = [isPy; ones(size(somaticF,1),1)];   
end

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

% Smooth the data with whatever filter was supplied
deltaFDS = filtfilt(filter, deltaFDS');

% upsample data
tseries = timeseries(deltaFDS, frameTimesMs);
tseries = resample(tseries, bData.sessionTime);
deltaF  = tseries.Data;

% Get peri-stimulus time flourescence
dF = get_PSTH(deltaF, ps.dFWindow, parsed.n_trials, stimInds, []);

% Offsets are wrong, don't do these now:
% Sizing for reward doesn't work for latency and visa versa
%dFL = get_PSTH(deltaF, ps.dFWindow, n_trials, stimInds, parsed.lickLatency);
%dFR = get_PSTH(deltaF, ps.dFWindow, n_trials, stimInds, rew);

flr = struct();
flr.dF = dF;

% Get evoked activity
% flr = get_evoked_dF(flr, dF);
%[dFL, evokedL, ~, ~] = get_evoked_dF(dFL, ps.baseInds, ps.respInds);
%[dFR, evokedR, ~, ~] = get_evoked_dF(dFR, ps.baseInds, ps.respInds);


end