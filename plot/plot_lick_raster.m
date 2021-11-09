function [] = plot_lick_raster(bData, dFWindow, stimInds, lickWindow, nStim)

preSamps = -dFWindow(1)/1000;
postSamps = dFWindow(2)/1000;

[licks, licksVect] = getStateSamps(bData.thresholdedLicks, 1, 1);

for n=2:nStim
    tempLickVect = licksVect(stimInds(n)+dFWindow(1):stimInds(n)+dFWindow(2))==1;
    tempLickVect = tempLickVect';
    lickTrig(1:length(tempLickVect),n)=tempLickVect;
end


[ x_bins2 ,mean_rate] = rasterSmooth([-preSamps:0.001:postSamps],lickTrig,2,'k');

    figure
subplot(211);rasterSmooth([-preSamps:0.001:postSamps],lickTrig,1,'k');
subplot(212);
plot(x_bins2,mean_rate,'k','linewidth',2);ylim([0 15]);ylabel('Licks/Second');xlabel('Time (s)');
ax=axis;line([0 0],[ax(3) ax(4)],'color','r','linewidth', 2,'linestyle','--');


end

