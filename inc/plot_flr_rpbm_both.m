function [] = plot_flr_rpbm_both(flr, mid, date_str, cid)
% Plot fluorescence response period by mask, both
%
% First group of masks are hit, miss, etc
% Second group of masks are stimulus amplitudes

figure()

subplot(1,2,1)
corder = parula(9);
msks = {'hit','hits_hi','hits_lo', 'miss', 'miss_hi', 'miss_lo', 'fa','cr'};

plot_flr_rpbm(flr, msks, corder, cid) 
title('Evoked by Trial Type')


subplot(1,2,2)
corder = parula(10);

msks = {'amp1','amp2','amp3','amp4','amp5','amp6','amp7','amp8','amp9'};
plot_flr_rpbm(flr, msks, corder, cid) 
title('Evoked by Stim. Amplitude')


suptitle(['\bf{Mouse ', num2str(mid), ', ' date_str,'}'])


set(gcf,'Position', [54         331        1331         494])
 
end