function  [parsed, stimInds] = parse_behavior_from_file(ps)

% Load and reformat info
% Load necessary file contents
file = [ps.path, ps.fname];

load(file, 'bData')
depth = NaN;

% Considering whisker stimulation
[stimOnInds,  ~] = getStateSamps(bData.teensyStates, 2, 1);
[catchOnInds, ~] = getStateSamps(bData.teensyStates, 3, 1);

% Timing when stimuli occur
stimInds = [stimOnInds, catchOnInds];
stimInds = sort(stimInds);
n_trials = min(length(stimInds), ps.nStimMax);

% Get lick vector
preSamps  = 3000;
postSamps = 3000;
[~, licksVect] = getStateSamps(bData.thresholdedLicks, 1, 1);

% Get aggregated lick raster
lickRstr = nan(n_trials, preSamps + postSamps + 1);
for n = 1:numel(stimInds)-1
   rstrSamps = stimInds(n) + (-preSamps:postSamps);
   lickRstr(n,:) = licksVect(rstrSamps)==1;
end

% Check bData
check_bData_dims(bData, n_trials)

% Parse behavior and get last good trial number
parsed = parse_behavior(bData, stimInds, ps.epochs, depth, n_trials, ps);

% Attach lick raster to parsed
parsed.lickRstr = lickRstr;

% Stimulus indices in fluor data.
stimInds = stimInds(1:n_trials);



end