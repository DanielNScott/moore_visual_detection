function [parsed] = parse_behavior(bData, stimSamps, lickWindow, depth)

% loop over the first one hundred trials and extract hit/miss information
for n = 2:100
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

   
end
