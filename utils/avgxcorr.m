function [r, maxrs, maxrlags] = avgxcorr(sigs, maxlag, window)

nsigs = size(sigs,2);
r = zeros(maxlag,nsigs);

maxrs    = zeros(nsigs*(nsigs+1)/2,1);
maxrlags = zeros(nsigs*(nsigs+1)/2,1);

k = 1;
for i = 1:nsigs
   for j = i:nsigs
      for lag = 0:maxlag
         r(lag+1, k) = corr(sigs(:,i), circshift(sigs(:,j),lag));
      end
      
      % Inefficient
      maxrs(k) = max(r(:,k));
      maxrlags(k) = mod(find(r(:,k) == maxrs(k))-1, maxlag-1)+1;
      
      k = k+1;
   end
end

end