function [] = plot_parsed_agg(agg, type)


nDays = length(agg);

mlist  = [];
blist  = [];
IDlist = [];
for day = 1:nDays
   IDlist = [IDlist, str2num(agg{day}.ID)];
end

figure()

IDs  = unique(IDlist);
nIDs = length(IDs);
k = 1;
for ID = IDs
   msk  = IDlist == ID;
   inds = find(msk);
   
   populate_subplot(inds, nIDs, (k-1)*3+1, agg, 'hitRate')
   ylabel('Value')
   if k == 1; title('Hit Rate')     ; end
   if k == 3; xlabel('Trial Number'); end
   
   populate_subplot(inds, nIDs, (k-1)*3+2, agg, 'faRate')
   if k == 1; title('FA Rate')     ; end
   if k == 3; xlabel('Trial Number'); end
   
   populate_subplot(inds, nIDs, (k-1)*3+3, agg, 'dPrime')
   if k == 1; title('D-Prime')     ; end
   if k == 3; xlabel('Trial Number'); end

   %legend({'m', 'b'})
   %title([type ' slope & intercept for Mouse ' num2str(ID)]);
   %xlabel('Training Day')
   %ylabel('Slope or Int.')
   
   k = k + 1;
end

set(gcf,'Position', [100         109        1145         865])

end

function [] = populate_subplot(inds, nIDs, num, agg, field)
   subplot(nIDs, 3, num)
   for i = inds
      plot(agg{i}.parsed.(field)); hold on;
      grid on
   end
end