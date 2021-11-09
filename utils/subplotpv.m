function [] = subplotpv(pvec, ind)
   
   fignum = pvec(ind,1);
   
   % Only append if there's a specific fig noted.
   % By default use current. If code -1, create new.
   if fignum ~= 0
      if fignum == -1
         figure()
      else
         figure(fignum);
      end
   end
   
   subplotv(pvec(ind,2:end));
end