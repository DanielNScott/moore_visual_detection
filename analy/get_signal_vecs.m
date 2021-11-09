function [ sig, sig_normed ] = get_signal_vecs(evoked, stim_trials, nCells)

sig = [];
sig(1,:) = mean(evoked(:,stim_trials{1}),2)';
sig(2,:) = mean(evoked(:,stim_trials{2}),2)';
sig(3,:) = mean(evoked(:,stim_trials{3}),2)';

sig_normed = sig;
for i = 1:nCells
   sig_normed(:,i) = sig(:,i)./norm(sig(:,i));
end


end

