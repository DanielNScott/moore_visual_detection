

figure()


flr = cen{mnum}.PVs{dnum};
vinds = 1:size(cen{mnum}.PVs{dnum}.ev,2);
nc = vinds(end);

i = 2;
%[~, inds] = sort(cen{1}.PVs{1}.hits_hi.cFm(i,:),'descend');
inds = vinds;

i = 2;
subplot(2,4,1)
errorbar(vinds, flr.hits_hi.cFm(i,inds), 2*flr.hits_hi.cFse(i,inds), 'o'); hold on; 
errorbar(vinds, flr.hits_lo.cFm(i,inds), 2*flr.hits_lo.cFse(i,inds), 'o')
fmt(nc)
legend('hits hi', 'hits lo')
title('Resp. Control for Hits')

subplot(2,4,2)
errorbar(vinds, flr.miss_hi.cFm(i,inds), 2*flr.miss_hi.cFse(i,inds), 'o'); hold on;
errorbar(vinds, flr.miss_lo.cFm(i,inds), 2*flr.miss_lo.cFse(i,inds), 'o')
legend('miss hi', 'miss lo')
fmt(nc)
title('Resp. Control for Miss')

subplot(2,4,3)
errorbar(vinds, flr.hits_hi.cFm(i,inds), 2*flr.hits_hi.cFse(i,inds), 'o'); hold on;
errorbar(vinds, flr.miss_hi.cFm(i,inds), 2*flr.miss_hi.cFse(i,inds), 'o')
legend('hits hi', 'miss hi')
fmt(nc)
title('Resp. Control for High Amp')

subplot(2,4,4)
errorbar(vinds, flr.hits_lo.cFm(i,inds), 2*flr.hits_lo.cFse(i,inds), 'o'); hold on;
errorbar(vinds, flr.miss_lo.cFm(i,inds), 2*flr.miss_lo.cFse(i,inds), 'o')
legend('hits lo', 'miss lo')
fmt(nc)
title('Resp. Control for Low Amp.')


i = 3;
%[~, inds] = sort(cen{1}.PVs{1}.hits_hi.cFm(i,:),'descend');
inds = vinds;

subplot(2,4,5)
errorbar(vinds, flr.hits_hi.cFm(i,inds), 2*flr.hits_hi.cFse(i,inds), 'o'); hold on; 
errorbar(vinds, flr.hits_lo.cFm(i,inds), 2*flr.hits_lo.cFse(i,inds), 'o')
fmt(nc)
legend('hits hi', 'hits lo')
title('Wait Control for Hits')

subplot(2,4,6)
errorbar(vinds, flr.miss_hi.cFm(i,inds), 2*flr.miss_hi.cFse(i,inds), 'o'); hold on;
errorbar(vinds, flr.miss_lo.cFm(i,inds), 2*flr.miss_lo.cFse(i,inds), 'o')
legend('miss hi', 'miss lo')
fmt(nc)
title('Wait Control for Miss')

subplot(2,4,7)
errorbar(vinds, flr.hits_hi.cFm(i,inds), 2*flr.hits_hi.cFse(i,inds), 'o'); hold on;
errorbar(vinds, flr.miss_hi.cFm(i,inds), 2*flr.miss_hi.cFse(i,inds), 'o')
legend('hits hi', 'miss hi')
fmt(nc)
title('Wait Control for High Amp')

subplot(2,4,8)
errorbar(vinds, flr.hits_lo.cFm(i,inds), 2*flr.hits_lo.cFse(i,inds), 'o'); hold on;
errorbar(vinds, flr.miss_lo.cFm(i,inds), 2*flr.miss_lo.cFse(i,inds), 'o')
legend('hits lo', 'miss lo')
fmt()
title('Wait Control for Low Amp.')


set(gcf, 'Position', [100          88        1493         846])


function [] = fmt(nc)
   ylim([-2,2])
   xlim([1,nc])
   grid on
end