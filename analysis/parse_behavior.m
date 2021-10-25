function [parsed, nStim] = parse_behavior(bData, stimSamps, lickWindow, depth, nStim, ps)

% loop over the first one hundred trials and extract hit/miss information
for n = 1:nStim
   % for touch
   parsed.amplitude(n)=bData.c1_amp(n);
   % for vision
   %parsed.amplitude(n)=bData.contrast(n);
   tempLick = find(bData.thresholdedLicks(stimSamps(n):stimSamps(n)+lickWindow)==1);
   tempRun = find(bData.binaryVelocity(stimSamps(n):stimSamps(n)+ lickWindow) == 1);

   % check to see if the animal licked in the window
   if numel(tempLick)>0
      % it licked
      parsed.lick(n) = 1;
      %parsed.lickLatency(n) = tempLick(1) - stimSamps(n);
      parsed.lickLatency(n) = tempLick(1);
      parsed.lickCount(n) = numel(tempLick);
      if parsed.amplitude(n)>0
         parsed.response_hits(n) = 1;
         parsed.response_miss(n) = 0;
         parsed.response_fa(n) = NaN;
         parsed.response_cr(n) = NaN;
      elseif parsed.amplitude(n) == 0
         parsed.response_fa(n) = 1;
         parsed.response_cr(n) = 0;
         parsed.response_hits(n) = NaN;
         parsed.response_miss(n) = NaN;
      end
   elseif numel(tempLick)==0
      parsed.lick(n) = 0;
      parsed.lickLatency(n) = NaN;
      parsed.lickCount(n) = 0;
      if parsed.amplitude(n)>0
         parsed.response_hits(n) = 0;
         parsed.response_miss(n) = 1;
         parsed.response_fa(n) = NaN;
         parsed.response_cr(n) = NaN;
      elseif parsed.amplitude(n) == 0
         parsed.response_fa(n) = 0;
         parsed.response_cr(n) = 1;
         parsed.response_hits(n) = NaN;
         parsed.response_miss(n) = NaN;
      end
   end

   % extract whether or not the mouse ran during the report window
   if numel(tempRun) > 0
      parsed.run(n) = 1;
      tempVel = bData.velocity(stimSamps(n):stimSamps(n)+ lickWindow);
      parsed.vel(n) = nanmean(abs(tempVel));
   else
      parsed.run(n) = 0;
      parsed.vel(n) = 0;
   end

   parsed.depth(n) = depth;
end

parsed.contrast = parsed.amplitude;

parsed.response_hits_hi = parsed.response_hits;
parsed.response_hits_hi(parsed.amplitude < 2000) = NaN;

parsed.response_hits_low = parsed.response_hits;
parsed.response_hits_low(parsed.amplitude >= 2000) = NaN;

parsed.response_miss_hi = parsed.response_miss;
parsed.response_miss_hi(parsed.amplitude < 2000) = NaN;

parsed.response_miss_low = parsed.response_miss;
parsed.response_miss_low(parsed.amplitude >= 2000) = NaN;

% Hit rate, false alarm rate, dPrime
use_new_parse = 1;
if use_new_parse
   % New
   smtWin = 31;
   parsed.hitRate = mPointMean(parsed.response_hits, smtWin)';
   parsed.faRate  = mPointMean(parsed.response_fa, smtWin)';

   parsed.hitRateHi  = mPointMean(parsed.response_hits_hi, smtWin)';
   parsed.hitRateLow = mPointMean(parsed.response_hits_low, smtWin)';

   parsed.dPrime    = calc_dPrime(parsed.hitRate   , parsed.faRate);
   parsed.dPrimeHi  = calc_dPrime(parsed.hitRateHi , parsed.faRate);
   parsed.dPrimeLow = calc_dPrime(parsed.hitRateLow, parsed.faRate);

   FA_sup = find(~isnan(parsed.faRate));
   if ~isempty(FA_sup)
      parsed.faCont = interp1(FA_sup, parsed.faRate(FA_sup) , 1:length(parsed.faRate));
   else
      parsed.faCont = nan(1,length(parsed.faRate));
   end

else
   % OLD
   % -------------- WARNING  --------------
   % DO NOT USE THIS EXCEPT FOR COMPARISON!
   % IT RETURNS INCORRECT RESULTS!
   % --------------------------------------
   smtWin = 50;
   parsed.hitRate = nPointMean(parsed.response_hits, smtWin)';
   parsed.faRate = nPointMean(parsed.response_fa, smtWin)';
   parsed.dPrime = norminv(parsed.hitRate) - norminv(parsed.faRate);
end

% Determine when animal stops trying
badHR = find(parsed.hitRate <= ps.hitRateLB, 1);
badFA = find(parsed.faRate  <= ps.faRateLB , 1);
trunc = min(badHR,badFA) - 1;

%
parsed.allTrials = 1:nStim;

% now find the HM trials, defined as either all hits or misses that
% aren't nans as those would be fa/cr trials
parsed.allHMTrials = parsed.allTrials(isnan(parsed.response_hits)==0);

% likewise all catch trials are trials where either hits or misses were
% nans
parsed.allCatchTrials = parsed.allTrials(isnan(parsed.response_hits)==1);
parsed.allHitTrials = intersect(parsed.allHMTrials,find(parsed.response_hits==1));
parsed.allMissTrials = intersect(parsed.allHMTrials,find(parsed.response_miss==1));
parsed.allFaTrials = intersect(parsed.allCatchTrials,find(parsed.response_fa==1));
parsed.allCrTrials = intersect(parsed.allCatchTrials,find(parsed.response_cr==1));

% Truncate everything to "valid" data
% Note: Validity is really crudely estimated currently!
if ~isempty(trunc)
   flds = fieldnames(parsed);
   for i = 1:length(flds)
      fld = flds{i};

      % Infer list type (dangerous!)
      if length(parsed.(fld)) == nStim
         parsed.(fld) = parsed.(fld)(1:trunc);
      else
         parsed.(fld) = truncate(parsed.(fld),trunc);
      end
   end
   nStim = trunc;
end
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

      dP = norminv(HR_int) - norminv(FA_int);
   else
      dP = nan(1,len);
   end
end
