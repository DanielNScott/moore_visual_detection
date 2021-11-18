function mus = add_flr(mus)

for mnum = 1:numel(mus)
   for dnum = 1:numel(mus{mnum}.nfo)
      mus{mnum}.PVs{dnum} = get_evoked_dF(mus{mnum}.PVs{dnum}, mus{mnum}.bhv{dnum}.msk);
   end   
end

end