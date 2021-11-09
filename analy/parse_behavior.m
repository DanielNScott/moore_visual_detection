function bhv = parse_behavior(bData, stimSamps, lickWindow, depth, n_trials, ps)

% Loop over the trials, extract hit/miss info
for n = 1:n_trials

   % Note: state machine has 1 extra index
   
   % For touch. For vision use contrast.
    bhv.amp(n) = bData.c1_amp(n);

   % Peri stimulus time window 
   window = stimSamps(n):(stimSamps(n)+lickWindow);
   
   % Find any lick times and msk.run times
   tempLick = find( bData.thresholdedLicks(window) ==1);
   tempRun  = find( bData.binaryVelocity(window)  == 1);

   % Check to see if the animal licked in the window
   if numel(tempLick)>0
      
      % It licked
      bhv.msk.lick(n)    = 1;
      bhv.lickLatency(n) = tempLick(1);
      bhv.lickCount(n)   = numel(tempLick);
      
      % Hits, misses, etc
      if bhv.amp(n) > 0
         
         % There was a stim
         bhv.msk.hit(n)  = 1;
         bhv.msk.miss(n) = 0;
         bhv.msk.fa(n)   = NaN;
         bhv.msk.cr(n)   = NaN;
         
      elseif bhv.amp(n) == 0
         
         % There was no stim
         bhv.msk.fa(n)   = 1;
         bhv.msk.cr(n)   = 0;
         bhv.msk.hit(n) = NaN;
         bhv.msk.miss(n) = NaN;
      end
      
   elseif numel(tempLick) == 0
      
      % It didn't msk.lick
      bhv.msk.lick(n) = 0;
      bhv.lickLatency(n) = NaN;
      bhv.lickCount(n) = 0;
      
      % 
      if bhv.amp(n)>0
         bhv.msk.hit(n) = 0;
         bhv.msk.miss(n) = 1;
         bhv.msk.fa(n) = NaN;
         bhv.msk.cr(n) = NaN;
      elseif bhv.amp(n) == 0
         bhv.msk.fa(n) = 0;
         bhv.msk.cr(n) = 1;
         bhv.msk.hit(n) = NaN;
         bhv.msk.miss(n) = NaN;
      end
   end

   % Extract whether or not the mouse ran during the report window
   if numel(tempRun) > 0
      bhv.msk.run(n) = 1;
      
      tempVel    = bData.velocity(stimSamps(n):stimSamps(n)+ lickWindow);
      bhv.vel(n) = nanmean(abs(tempVel));
   else
      
      % Didn't run, velocity was zero
      bhv.msk.run(n) = 0;
      bhv.vel(n) = 0;
   end

   bhv.depth(n) = depth;
end

% High and low hit masks
bhv.msk.hits_hi = bhv.msk.hit;
bhv.msk.hits_hi(bhv.amp < 2000) = NaN;

bhv.msk.hits_lo = bhv.msk.hit;
bhv.msk.hits_lo(bhv.amp >= 2000) = NaN;

bhv.msk.miss_hi = bhv.msk.miss;
bhv.msk.miss_hi(bhv.amp < 2000) = NaN;

bhv.msk.miss_lo = bhv.msk.miss;
bhv.msk.miss_lo(bhv.amp >= 2000) = NaN;

% Hit rate, false alarm rate, dPrime
use_new_parse = 1;
if use_new_parse
   % New
   smtWin = 31;
   bhv.hitRate = mPointMean(bhv.msk.hit, smtWin)';
   bhv.faRate  = mPointMean(bhv.msk.fa, smtWin)';

   bhv.hitRateHi  = mPointMean(bhv.msk.hits_hi, smtWin)';
   bhv.hitRateLow = mPointMean(bhv.msk.hits_lo, smtWin)';

   bhv.dPrime    = calc_dPrime(bhv.hitRate   , bhv.faRate);
   bhv.dPrimeHi  = calc_dPrime(bhv.hitRateHi , bhv.faRate);
   bhv.dPrimeLow = calc_dPrime(bhv.hitRateLow, bhv.faRate);

   FA_sup = find(~isnan(bhv.faRate));
   if ~isempty(FA_sup)
      bhv.faCont = interp1(FA_sup, bhv.faRate(FA_sup) , 1:length(bhv.faRate))';
   else
      bhv.faCont = nan(length(bhv.faRate),1);
   end

else
   % OLD
   % -------------- WARNING  --------------
   % DO NOT USE THIS EXCEPT FOR COMPARISON!
   % IT RETURNS INCORRECT RESULTS!
   % --------------------------------------
   smtWin = 50;
   bhv.hitRate = nPointMean(bhv.msk.hit, smtWin)';
   bhv.faRate  = nPointMean(bhv.msk.fa, smtWin)';
   bhv.dPrime  = norminv(bhv.hitRate) - norminv(bhv.faRate);
end

% Determine when animal stops trying
badHR = find(bhv.hitRate <= ps.hitRateLB, 1);
badFA = find(bhv.faRate  <= ps.faRateLB , 1);
trunc = min(badHR,badFA) - 1;

% List of all trials
bhv.nds.all = 1:n_trials;

% Stim and catch trials
bhv.nds.stim  = bhv.nds.all( isnan( bhv.msk.hit ) == 0);
bhv.nds.catch = bhv.nds.all( isnan( bhv.msk.hit ) == 1);

% Indices for hit, miss, fa, cr trials
bhv.nds.hit  = find(bhv.msk.hit == 1);
bhv.nds.miss = find(bhv.msk.miss == 1);
bhv.nds.fa   = find(bhv.msk.fa   == 1);
bhv.nds.cr   = find(bhv.msk.cr   == 1);

% This was superceded and is now deprecated
%
% Truncate everything to "valid" data
% Note: Validity is really crudely estimated currently! 
% if ~isempty(trunc)
%    flds = fieldnames(bhv);
%    for i = 1:length(flds)
%       fld = flds{i};
% 
%       % Infer list type (dangerous!)
%       if length(bhv.(fld)) == n_trials
%          bhv.(fld) = bhv.(fld)(1:trunc);
%       else
%          bhv.(fld) = truncate(bhv.(fld),trunc);
%       end
%    end
%    n_trials = trunc;
% end


% Generate a vector of peri-stimulus times the reward was on
rew = bhv.msk.hit == 1;
rew = rew*2000;
rew(rew == 0) = NaN;
bhv.rew = rew';

bhv.n_trials = n_trials;


% Append the psychometric data
bhv = add_psychometric(bhv);

% Make everything have the same indexing b.c. one of us is OCD.
% In truth, this is useful because then you can visually check dimensions quickly.
bhv = to_cols(bhv);

end

function list = truncate(list, trial)
   list = list(list <= trial);
end

function dP = calc_dPrime(hr, fa)
   len = length(hr);
   HR_sup = find(~isnan(hr));
   FA_sup = find(~isnan(fa));

   if ~isempty(FA_sup) && ~isempty(HR_sup)
      HR_int = interp1(HR_sup, hr(HR_sup), 1:len);
      FA_int = interp1(FA_sup, fa(FA_sup) , 1:len);

      dP = norminv(HR_int)' - norminv(FA_int)';
   else
      dP = nan(1,len);
   end
end

% Turns every vector into a column
function bhv = to_cols(bhv)

   % List all the field names
   fields = fieldnames(bhv);
   
   % Iterate over them
   for fs = fields'
      fs = fs{:};
      
      % Skip anything that's not a vector
      if sum(size(bhv.(fs)) > 1) > 1
         continue
      end
      
      % Recursion if structure
      if isstruct(bhv.(fs))
         bhv.(fs) = to_cols(bhv.(fs));
      else
         
         % Else make column
         bhv.(fs) = bhv.(fs)(:);
      end
   end

end