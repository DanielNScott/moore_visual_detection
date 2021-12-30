function cen = get_lick_rates(cen, pre, post)
% Inputs are number of ms pre- and post- stim in lick raster.

% Loop over
for mnum = 1:length(cen)
   
   % Loop over days
   for dnum = 1:length(cen{mnum}.bhv)
      
      % Loop over fields we want rates for
      for fs = {'hit','miss','fa','cr', 'amp9', 'amp8', 'amp7', 'amp6', 'amp5', 'amp4', 'amp3', 'amp2', 'amp1'}
         fs = fs{:};
         nds = cen{mnum}.bhv{dnum}.nds.(fs);

         cur_raster = cen{mnum}.bhv{dnum}.lickRstr(nds,:);
         cur_raster = cur_raster(~isnan(sum(cur_raster,2)), :);

         ntrials = size(cur_raster,1);
         licks_frq = sum(cur_raster)/ntrials;

         % Rise and fall times for alpha like kernel
         tau_r = 1/20;
         tau_f = 1/100;
         ker = conv(expker(tau_f), expker(tau_r), 'full');
         ker = ker/sum(ker);

         % Lick frequency plot
         times = -pre:post;
         lick_rate = conv(licks_frq, ker,'valid');
         lick_rate = [NaN(1, numel(times) - numel(lick_rate)),lick_rate]*1000;

         cen{mnum}.bhv{dnum}.lick_rate.(fs) = lick_rate;
      end
   end
end
end