function lm = get_max_stim_encoding_model(flr, bhv, ep_flr)

model = [];
SEs   = [];
pval  = [];
pred  = [];
rsqr  = [];
mpv   = [];
rho   = [];

ncells = size(flr.ev, 2);

% Regressors, pLFP = pseudo-LFP
%msk  = logical(bhv.msk.amp9 + bhv.msk.amp2) & logical(bhv.msk.miss);
%msk  = logical(bhv.msk.amp9 + bhv.msk.amp1);
msk = (bhv.msk.hit - bhv.msk.miss) .* bhv.msk.amp9;
stim = msk;
msk  = logical(msk ~= 0);
stim = stim(msk);
%stim = bhv.amp(msk,:);

%stim(stim > 0.1) = 1;
%stim(stim < 100) = 0;
%stim(stim > 100) = 1;

for cid = 1:ncells

   % Fluorescence value to predict
   evoked = zscore( flr.cF(msk,ep_flr, cid) );
   
   % Design matrix, i.e. set of regressors / explanatory variables
   design = stim;
   
   % Fit linear model
   warning('off','all');
   lm = fitlm(design, evoked);
   warning('on', 'all');
      
   % Save the various elements of the model
   model = [model, lm.Coefficients.Estimate(2:end)];
   SEs   = [SEs,   lm.Coefficients.SE(2:end)];
   pval  = [pval,  lm.Coefficients.pValue(2:end)];
   rsqr  = [rsqr,  lm.Rsquared.Ordinary];
   
   % CoefTest likes to warn that the model is singular
   warning off
   mpv   = [mpv,   lm.coefTest];   
   warning on
   
   % Actual model predictions
   pred  = [pred, ([ones(numel(stim),1), design]*lm.Coefficients.Estimate)];

end

lm = struct();
lm.model = model;
lm.SEs   = SEs;
lm.pval  = pval;
lm.pred  = pred;
lm.rsqr  = rsqr;
lm.mpv   = mpv;
lm.rho   = rho;

end