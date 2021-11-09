function [] = plot_dFdFL_mean(dF, proc) 

figure

meanCell = squeeze(mean(dF,1))

tVec = proc.params.dFWindow(1):proc.params.dFWindow(2)

shadedErrorBar(tVec, mean(meanCell,2), std(meanCell')./sqrt(size(meanCell,2)),...
    'lineprops','r');

end 