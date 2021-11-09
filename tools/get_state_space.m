function [v, d, P, proj, dFm, dFmCov] = state_space(dF, trials, window)
   % Mean over trials 
   dFm    = squeeze(mean(dF(trials,window,:),1));
   dFmCov = (dFm-mean(dFm,2))'*(dFm-mean(dFm,2));
   [v,d]  = eig(dFmCov);

   [d,inds] = sort(diag(d), 'descend');
   v = v(:,inds);

   P = v(:,1:2)';
   proj = P*dFm';

end