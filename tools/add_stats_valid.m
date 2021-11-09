function mus = add_stats_valid(mus)
% Takes the data quality structure containing the trial validity mask
% and computes some summary info.

for mnum = 1:numel(mus)
   
   mus{mnum}.mta.nvld = 0;
   mus{mnum}.mta.ntrl = 0;

   for dnum = 1:numel(mus{mnum}.nfo)
      
      nvalid = sum(  mus{mnum}.bhv{dnum}.msk.vld);
      ntrial = numel(mus{mnum}.bhv{dnum}.msk.vld);
      
      fvalid = nvalid / ntrial;
      
      mus{mnum}.nfo{dnum}.nvld = nvalid;
      mus{mnum}.nfo{dnum}.ntrl = ntrial;
      mus{mnum}.nfo{dnum}.fvld = fvalid;
      
      mus{mnum}.mta.nvld = mus{mnum}.mta.nvld + nvalid;
      mus{mnum}.mta.ntrl = mus{mnum}.mta.ntrl + ntrial;
   end
   
   mus{mnum}.mta.fvld = mus{mnum}.mta.nvld./mus{mnum}.mta.ntrl;
end

end