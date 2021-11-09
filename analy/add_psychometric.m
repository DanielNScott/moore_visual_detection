function bhv = add_psychometric(bhv)

levs  = unique(bhv.amp);
nlevs = length(levs);    
for i = 1:nlevs
   msk = bhv.amp == levs(i);
   
   resp(i) = mean(bhv.msk.lick(msk));
   smps(i) = sum(msk);
end

bhv.psych_phit = resp';
bhv.psych_smps = smps';
bhv.psych_levs = levs ;

end