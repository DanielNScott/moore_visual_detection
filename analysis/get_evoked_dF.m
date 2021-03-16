function [dF, evoked, avg, sd] = get_evoked_dF(dF, baseInds, respInds)

% Z-score baseline period.
% Apply the same mean shift and variance scaling to whole trial.
dF = (dF(:,:,:)  - mean(dF(:,baseInds,:),2));
sd = std(dF(:,baseInds,:),[],2);
dF = dF./sd;

sd = squeeze(sd);

% Avg. pre should be basically zero now, but we keep it for the case
% in which we turn off the baselining and inspect sequential effects.
avg.pre  = squeeze(trapz(dF(:, baseInds, :), 2))';
avg.post = squeeze(trapz(dF(:, respInds, :), 2))';

evoked = avg.post - avg.pre;

end