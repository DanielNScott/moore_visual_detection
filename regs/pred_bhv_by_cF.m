function [lm] = pred_bhv_by_cF(flr, bhv, ep_flr, ep_lck, msk)

model = [];
SEs   = [];
pval  = [];
pred  = [];
rsqr  = [];
mpv   = [];
rho   = [];

% Dependent vars, lick, stim amp, velocity, hit 
dep{1} = zscore( bhv.lickCnt{ep_lck}(msk,:) );
dep{2} = zscore( log0(bhv.amp(msk,:)) );
dep{3} = zscore( bhv.vel{ep_lck}(msk,:) );
dep{4} = zscore( bhv.msk.hit(msk,:));

% Cell fluorescence as regressors
design = zscore(squeeze(flr.cF(msk, ep_flr, :)));

% Get correlations among the predictors
rho = corr(design);

% Predict each of the dependent vars
for ynum = 1:4

   % Fit linear model
   warning('off','all');
   lm = fitlm(design, dep{ynum});
   warning('on', 'all');   

   % Save the various elements of the model
   model = [model, lm.Coefficients.Estimate(2:end)];
   SEs   = [SEs,   lm.Coefficients.SE(2:end)];
   pval  = [pval,  lm.Coefficients.pValue(2:end)];
   rsqr  = [rsqr,  lm.Rsquared.Ordinary];

   % CoefTest likes to warn that the model is singular
   warning off
   mpv = [mpv,   lm.coefTest];   
   warning on

   % Actual model predictions
   pred  = [pred, ([ones(numel(dep{1}),1), design]*lm.Coefficients.Estimate)];

end

lm = struct();
lm.model = model';
lm.SEs   = SEs';
lm.pval  = pval';
lm.pred  = pred';
lm.rsqr  = rsqr';
lm.mpv   = mpv';
lm.rho   = rho';
end