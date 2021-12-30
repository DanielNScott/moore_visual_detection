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

   hinds = flr.cellnfo.hit;
   minds = flr.cellnfo.miss;
   ninds = flr.cellnfo.non;
   
   subplot(4,3,l)
   plot(tmp(hinds,2), tmp(hinds,3),'o', 'LineWidth', 2); hold on
   plot(tmp(minds,2), tmp(minds,3),'o', 'LineWidth', 2);
   plot(tmp(ninds,2), tmp(ninds,3),'o', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
   
   fmt()
   xlabel('Resp.')
   ylabel('Wait')
   title('Evoked Response Relations')
   l = l + 1;
   

   subplot(4,3,l)
   plot(tmp(hinds,3), tmp(hinds,4),'o', 'LineWidth', 2); hold on
   plot(tmp(minds,3), tmp(minds,4),'o', 'LineWidth', 2);
   plot(tmp(ninds,3), tmp(ninds,4),'o', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
   fmt()
   xlabel('Wait')
   ylabel('Rew.')
   title('Evoked Response Relations')
   l = l + 1;

   subplot(4,3,l)
   plot(tmp(hinds,2), tmp(hinds,4),'o', 'LineWidth', 2); hold on
   plot(tmp(minds,2), tmp(minds,4),'o', 'LineWidth', 2);
   plot(tmp(ninds,2), tmp(ninds,4),'o', 'LineWidth', 2, 'Color', [0.5 0.5 0.5]);
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