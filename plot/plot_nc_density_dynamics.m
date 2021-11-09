function [] = plot_nc_density_dynamics(hist)

binEdges = -1:0.05:1;
binWidth = 0.05;
binCtrs  = binEdges(1:(end-1)) + binWidth/2; 

imagesc(hist)
set(gca,'YTick',[0.5,20.5,40.5]);%1:4:40)
set(gca,'YTickLabel',[-1,0,1]);%binCtrs(1:4:40))

ylabel('Noise Correlation')
xlabel('Time [ms]')

hold on;
plot([1000,1000],[1,40],'--r','LineWidth', 2)
plot([1,3701],[20.5,20.5],'-k','LineWidth',2)
title('Noise Correlations Over Time')
colorbar()

end