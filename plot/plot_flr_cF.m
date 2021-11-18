function [] = plot_flr_cF(cF, msks, cid)

figure()
corder = get(gca,'ColorOrder');

msk_strs = {'hit','miss','fa','cr'};

l = 1;
for k = 1:numel(msk_strs)
   
   msk = msks.(msk_strs{k});
   msk(isnan(msk)) = 0;
   msk = logical(msk);

   subplot(4,4,l)
   for i = 1:3
      j = i+1;
      %histogram(cF(:,j,:), 'Normalization', 'pdf', 'BinEdges', -2:0.1:2, 'FaceAlpha', 0.1)
      hold on

      [f,xi] = ksdensity( squeeze(cF(msk,j,cid)) );
      plot(xi,f,'LineWidth',2, 'Color', corder(i,:));
      xlim([-3,3])
   end
   grid on

   legend({'Resp.','Wait','Rew'})
   title('Evoked Response Densities')
   xlabel('z-scored dF/F')
   ylabel('density')
   l = l+1;

   subplot(4,4,l)
   plot(cF(msk,2,cid), cF(msk,3,cid), 'o')
   grid on
   xlim([-2.5,2.5])
   ylim([-2.5,2.5])
   hold on;
   plot([-3,3], [-3,3], '--k')
   xlabel('Resp.')
   ylabel('Wait')
   title('Evoked Response Relations')
   l = l + 1;
   
   subplot(4,4,l)
   plot(cF(msk,3,cid), cF(msk,4,cid), 'o')
   grid on
   xlim([-2.5,2.5])
   ylim([-2.5,2.5])
   hold on;
   plot([-3,3], [-3,3], '--k')
   xlabel('Wait')
   ylabel('Rew.')
   title('Evoked Response Relations')
   l = l + 1;

   subplot(4,4,l)
   plot(cF(msk,2,cid), cF(msk,4,cid), 'o')
   grid on
   xlim([-2.5,2.5])
   ylim([-2.5,2.5])
   hold on;
   plot([-3,3], [-3,3], '--k')
   xlabel('Resp.')
   ylabel('Rew.')
   title('Evoked Response Relations')
   l = l + 1;
end
end
