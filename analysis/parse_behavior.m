function [parsed, trunc] = parse_behavior(bData, stimSamps, lickWindow, depth, nStim, ps)

% loop over the first one hundred trials and extract hit/miss information
for n = 2:nStim
   % for touch
   %parsed.amplitude(n)=bData.c1_amp(n);
   % for vision
   parsed.amplitude(n)=bData.contrast(n);
   tempLick = find(bData.thresholdedLicks(stimSamps(n):stimSamps(n)+lickWindow)==1);
   tempRun = find(bData.binaryVelocity(stimSamps(n):stimSamps(n)+ lickWindow) == 1);
   
   % check to see if the animal licked in the window
   if numel(tempLick)>0
      % it licked
      parsed.lick(n) = 1;
      parsed.lickLatency(n) = tempLick(1) - stimSamps(n);
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

% Hit rate, false alarm rate, dPrime
smtWin = 50;
parsed.hitRate = nPointMean(parsed.response_hits, smtWin)';
parsed.faRate = nPointMean(parsed.response_fa, smtWin)';
parsed.dPrime = norminv(parsed.hitRate) - norminv(parsed.faRate);

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
end

function list = truncate(list, trial)
   list = list(list <= trial);
end