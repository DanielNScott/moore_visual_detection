function [] = plot_zscored_evoked(evoked, stim_trials, save)
   figure()
   
   for i = 1:3
      subplot(3,1,i)
      
      z_evoked = zscore(evoked(:,stim_trials{i})');
      z_evoked_mu = mean(z_evoked,2);
      z_evoked_sd = std(z_evoked,0,2);

      ax = plot(z_evoked_mu); hold on
      plot(z_evoked_mu + z_evoked_sd, '--', 'Color', ax.Color)
      plot(z_evoked_mu - z_evoked_sd, '--', 'Color', ax.Color)
      grid on
      
      title(['S', num2str(i)])
      xlabel('Trial Number')
      ylabel('Z-Scored dF/F')
      legend({'mean', 'sd'})
      xlim([1,length(z_evoked_mu)])
      ylim([-3,3])
   end
   
   if save
      saveas(gcf,'Evoked-dfbyF.png');
      saveas(gcf,'Evoked-dfbyF.fig');
   end

end