function [] = plot_bhv_raster(bhv)
%bhv = cen{1}.bhv{1};

figure()
ttot = 0;
for fs = {'hit','miss','fa','cr'}
   fs = fs{:};
   
   subplot(2,1,1)
   nds = bhv.nds.(fs);
   
   nds_fin = [];
   for amps = {'amp9', 'amp8', 'amp7', 'amp6', 'amp5', 'amp4', 'amp3', 'amp2', 'amp1'}
      nds_subset = bhv.nds.(amps{:});
      nds_subset = intersect(nds_subset, nds);
      nds_fin = [nds_fin; nds_subset];
   end
   
   cur_raster = bhv.lickRstr(nds,:);
   
   plot_raster(cur_raster, ttot)
   ttot = numel(bhv.nds.(fs)) + ttot;
   
   %if strcmp(fs,'cr')
   %   yls = ylim();
   %   plot([0,0],[0,yls(2)], '--r', 'LineWidth', 2)
   %   legend({'hit','miss','fa','cr'}, 'Location', 'NorthWest')
   %end
   
   pre = 3000;
   post = 3000;
   subplot(2,1,2)
   times = -pre:post;
   plot(times, bhv.lick_rate.(fs), 'LineWidth',2); hold on
   grid on
   xlabel('Time [ms]')
   ylabel('Licks / sec')
   title('Lick Frequency')
   if strcmp(fs,'cr')
      yls = ylim();
      plot([0,0],[0,yls(2)], '--r', 'LineWidth', 2)
      legend({'hit','miss','fa','cr'}, 'Location', 'NorthWest')
   end
end

end