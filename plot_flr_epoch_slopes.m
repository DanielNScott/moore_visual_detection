function [] = plot_flr_epoch_slopes(flr, bhv)
figure(); 

corder = get(gca,'ColorOrder');

msk_strs = {'hit','miss','fa','cr'};

l = 1;
for k = 1:numel(msk_strs)

%    subplot(4,4,l)
%    for i = 1:3
%       j = i+1;
%       %histogram(cF(:,j,:), 'Normalization', 'pdf', 'BinEdges', -2:0.1:2, 'FaceAlpha', 0.1)
%       hold on
% 
%       %[f,xi] = ksdensity( squeeze(flr.mF(bhv.nds.(msk_strs{k}),j,cid)) );
%       %plot(xi,f,'LineWidth',2, 'Color', corder(i,:));
%       xlim([-3,3])
%    end
%    grid on
% 
%    legend({'Resp.','Wait','Rew'})
%    title('Evoked Response Densities')
%    xlabel('z-scored dF/F')
%    ylabel('density')
%    l = l+1;

   tmp = mean(permute(flr.mF(bhv.nds.(msk_strs{k}),:,:), [3,2,1]),3);

   subplot(4,3,l)
   plot(tmp(:,2), tmp(:,3),'o')
   fmt()
   xlabel('Resp.')
   ylabel('Wait')
   title('Evoked Response Relations')
   l = l + 1;
   

   subplot(4,3,l)
   plot(tmp(:,3), tmp(:,4),'o')
   fmt()
   xlabel('Wait')
   ylabel('Rew.')
   title('Evoked Response Relations')
   l = l + 1;

   subplot(4,3,l)
   plot(tmp(:,2), tmp(:,4),'o')
   fmt()
   xlabel('Resp.')
   ylabel('Rew.')
   title('Evoked Response Relations')
   l = l + 1;
end

set(gcf,'Position', [1           1        1920         995])

end





function [] = fmt()
grid on
xlim([-2,2])
ylim([-2,2])
hold on;
plot([-2,2], [-2,2], '--k')

end