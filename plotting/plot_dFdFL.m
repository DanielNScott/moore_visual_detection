function [] = plot_dFdFL(dF, dFL)

nCells = size(dF,3);
nrows  = ceil(nCells/5);
for c = 1:nCells
   subplot(nrows, 5, c)
   plot(nanmean(squeeze(dF( :,:,c)),1)'); hold on
   plot(nanmean(squeeze(dFL(:,:,c)),1)')
   grid on
   
   xlim([0,4000])
end

end