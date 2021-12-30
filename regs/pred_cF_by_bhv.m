function [lm] = pred_cF_by_bhv(flr, bhv, ep_flr, ep_lck, msk)

model = [];
SEs   = [];
pval  = [];
pred  = [];
rsqr  = [];
mpv   = [];
rho   = [];

ncells = size(flr.ev, 2);

% Regressors, pLFP = pseudo-LFP
lick = zscore( bhv.lickCnt{ep_lck}(msk,:) );
stim = zscore( log0(bhv.amp(msk,:)) );
vels = zscore( bhv.vel{ep_lck}(msk,:) );
rew  = zscore( bhv.msk.hit(msk,:));

% Whole pop. for approx. design correlation, LOO for actual regressor
pLFP = zscore( sum(flr.cF(msk, ep_flr, :),3) );

% To compute regressor correlation, real design is below
design = [lick, stim, vels, rew];

% Get correlations among the predictors
rho = corr(design);

for cid = 1:ncells

   % Fluorescence value to predict
   evoked = zscore( flr.cF(msk,ep_flr,cid) );
   
   % pseudo-LFP
   pLFP = zscore( sum(flr.cF(msk, ep_flr, setdiff(1:ncells, cid)),3) );

   % Other cells as potential regressors
   %oc = squeeze(flr.cF(msk, ep_flr, :));
   %oc(:, cid) = 0;
   
   % Design matrix, i.e. set of regressors / explanatory variables
   design = [lick, stim, vels, rew];
   %design = oc;

   % Determine if any columns are constant
   const = all(design == 0);
   
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
   pred  = [pred, ([ones(numel(lick),1), design]*lm.Coefficients.Estimate)];

end

lm = struct();
lm.model = model;
lm.SEs   = SEs;
lm.pval  = pval;
lm.pred  = pred;
lm.rsqr  = rsqr;
lm.mpv   = mpv;
lm.rho   = rho;

% 
% figure
% x1 = lick;
% x2 = stim;
% scatter3(lick,stim, evoked,'filled')
% hold on
% x1fit = min(x1):1:max(x1);
% x2fit = min(x2):100:max(x2);
% [X1FIT,X2FIT] = meshgrid(x1fit,x2fit);
% YFIT = model(1) + model(2)*X1FIT + model(3)*X2FIT + model(4)*X1FIT.*X2FIT;
% %mesh(X1FIT,X2FIT,YFIT)
% xlabel('Lick Amplitude (Licks/Trial)')
% ylabel('Stim Amplitude (Contrast)')
% zlabel({'Evoked Calcium Response'; '(dF/F Evoked Score)'});
% % view(50,10)
% title('Multiple Linear Regression of 1 Cell')
% hold off

end