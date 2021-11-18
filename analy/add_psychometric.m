function bhv = add_psychometric(bhv)

%levs  = unique(bhv.amp);
levs = [0,50,100,150,200,500,1000,2000,4000]';

nlevs = length(levs);    
for i = 1:nlevs
   msk = bhv.amp == levs(i);
   
   resp(i) = mean(bhv.msk.lick(msk));
   smps(i) = sum(msk);
   
   fs = ['amp', num2str(i)];
   bhv.msk.(fs) = msk;
   bhv.nds.(fs) = find(msk);
end

bhv.psych_phit = resp';
bhv.psych_smps = smps';
bhv.psych_levs = levs ;

end