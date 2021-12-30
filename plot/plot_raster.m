function [] = plot_raster(raster, trial_offset)
 
   ntrials = size(raster,1);
   ntimes  = size(raster,2);
   
   event_times = [];
   trial_number = [];
   for i = 1:ntrials
      inds = find(raster(i,:) == 1)-3000;
      event_times = [event_times, inds];
      trial_number = [trial_number, repmat(i + trial_offset, [1, numel(inds)])];
   end

   plot(event_times,trial_number, '.', 'MarkerSize', 9); hold on
   xlim([-3000,3000])
   %ylim([0,ntrials])
   xlabel('Time [ms]')
   ylabel('Trial Number')
   plot([0,0],[0,ntrials]+trial_offset, '--r', 'LineWidth',2)
   ylim([0, ntrials + trial_offset])
   title('Lick Raster')
   
end