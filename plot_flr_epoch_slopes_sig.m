

figure()
subplot(2,3,1)

[~, inds] = sort(flr.vld.mFm(2,:), 'descend');
errorbar(flr.vld.mFm(2,inds), 2*flr.vld.mFse(2,inds), 'o')
title('Resp. Period Slope')
fmt()


subplot(2,3,2)
errorbar(flr.vld.mFm(3,inds), 2*flr.vld.mFse(3,inds), 'o')
title('Wait Period Slope')
fmt()


subplot(2,3,3)
errorbar(flr.vld.mFm(4,inds), 2*flr.vld.mFse(4,inds), 'o')
title('Rew. Period Slope')
fmt()


subplot(2,3,4)
[n_pos, n_neg, n_non] = count_stuff( flr.vld.mFm(2,inds), flr.vld.mFse(2,inds));
pie([n_pos, n_neg, n_non])
legend({'pos', 'neg', 'non'})


subplot(2,3,5)
[n_pos, n_neg, n_non] = count_stuff( flr.vld.mFm(3,inds), flr.vld.mFse(3,inds));
pie([n_pos, n_neg, n_non])
legend({'pos', 'neg', 'non'}, 'Location', 'NorthWest')


subplot(2,3,6)
[n_pos, n_neg, n_non] = count_stuff( flr.vld.mFm(4,inds), flr.vld.mFse(4,inds));
pie([n_pos, n_neg, n_non])
legend({'pos', 'neg', 'non'}, 'Location', 'NorthWest')


set(gcf,'Position', [95         109        1646         835])

function [] = fmt()
   xlabel('Sorted Cell Number')
   ylabel('z-scored dF/F')
   grid on
end



function [n_pos, n_neg, n_non] = count_stuff(mFms, mFses)
sig = abs(mFms) > 2*mFses;
sgn = sign(mFms);

n_pos = sum((sgn > 0) .* sig);
n_neg = sum((sgn < 0) .* sig);
n_non = sum(sig == 0);


end