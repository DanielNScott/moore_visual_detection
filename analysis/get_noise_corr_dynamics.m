function rho = get_noise_corr_dynamics(dF, trials)

   nCells  = size(dF,3);
   maxTime = size(dF,2);
   
   rho = NaN(nCells,nCells,maxTime);
   
   for t = 1:maxTime

     slice = squeeze(dF(trials,t,:));
     mu = mean(slice,1);
     centered = (slice - mu);
     rho(:,:,t) = corr(centered);
   end

end

