function bhv = add_derived_behavior(bhv, ps)

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
bhv.nds.hit  = find(bhv.msk.hit  == 1);
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