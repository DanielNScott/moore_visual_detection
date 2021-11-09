function [] = plot_ncs_evecs(evecs, evals, save)

   figure()
   set(gcf,'Position', [95, 528, 1520, 416])
   colorOrder = get(gca, 'ColorOrder');
   subplot(1,2,1)
   plot(evecs{1}(:,1), '-o', 'Color', colorOrder(1,:)); hold on
   plot(evecs{2}(:,1), '-o', 'Color', colorOrder(2,:));
   plot(evecs{3}(:,1), '-o', 'Color', colorOrder(3,:));

   plot( evecs{1}(:,2), '--o', 'Color', colorOrder(1,:));
   plot( evecs{2}(:,2), '--o', 'Color', colorOrder(2,:));
   plot( evecs{3}(:,2), '--o', 'Color', colorOrder(3,:));

   plot([1,11], [0,0],'--k')
   xlim([1,11])
   grid on

   title('Noise Correlation Matrix Eigenvectors')
   xlabel('Neuron ID')
   ylabel('Loading')
   legend({'S1 E1', 'S2 E1', 'S3 E1', 'S1 E2', 'S2 E2', 'S3 E2'},'Location','NorthWest')

   subplot(1,2,2)
   plot(evals{1}, '-o', 'Color', colorOrder(1,:)); hold on
   plot(evals{2}, '-o', 'Color', colorOrder(2,:));
   plot(evals{3}, '-o', 'Color', colorOrder(3,:));
   grid on

   title('Noise Correlation Matrix Spectra')
   xlabel('Eigenvalue Rank')
   ylabel('Eigenvalue')
   legend({'S1', 'S2', 'S3'})
   xlim([1,11])
   
   if save
      saveas(gcf,'./Noise-Corr-Spectra.png');
      saveas(gcf,'./Noise-Corr-Spectra.fig');
   end
end