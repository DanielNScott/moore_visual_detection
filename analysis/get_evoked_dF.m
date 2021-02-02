function [evoked] = get_evoked_dF(dF, baseInds, respInds)

dFRel = (dF(:,:,:)  - mean(dF(:,baseInds,:),2));

avg_dF_pre  = trapz(dFRel(:, baseInds, :), 2);
avg_dF_post = trapz(dFRel(:, respInds, :), 2);

evoked = squeeze(avg_dF_post - avg_dF_pre)';

end