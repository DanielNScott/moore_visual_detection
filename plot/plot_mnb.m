function [] = plot_mnb(agg, type)


nDays = length(agg);

mlist  = [];
blist  = [];
IDlist = [];
for day = 1:nDays
   IDlist = [IDlist, str2num(agg{day}.ID)];
   mlist  = [mlist , agg{day}.or.corrs.mnb{4}.m];
   blist  = [blist , agg{day}.or.corrs.mnb{4}.b];
end

figure()

IDs  = unique(IDlist);
nIDs = length(IDs);
k = 1;
for ID = IDs
   msk = IDlist == ID;
   
   subplot(nIDs, 1, k)
   plot(mlist(msk), '-o'); hold on;
   plot(blist(msk), '-o')
   grid on
   legend({'m', 'b'})
   title([type ' slope & intercept for Mouse ' num2str(ID)]);
   xlabel('Training Day')
   ylabel('Slope or Int.')
   
   k = k + 1;
end

end