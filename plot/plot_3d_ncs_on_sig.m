function [] = plot_3d_ncs_on_sig(sig, ncs, save)
   figure()
   set(gcf,'Position', [59         491        1533         374])
   for k = 1:3
      subplot(1,3,k)

      scatter3(sig(1,:), sig(2,:), sig(3,:))
      hold on

      minlim = min(sig(:));
      maxlim = max(sig(:));
      
      xlim([min(0,minlim), max(60,maxlim)])
      ylim([min(0,minlim), max(60,maxlim)])
      zlim([min(0,minlim), max(60,maxlim)])

      title(['Noise corr. graph given S', num2str(k)])
      xlabel('S1 response')
      ylabel('S2 resposne')
      zlabel('S3 response')


      minNC = min(   get_upper(ncs{k}));
      medNC = median(get_upper(ncs{k}));
      maxNC = max(   get_upper(ncs{k}));

      ncells = length(sig(1,:));
      lcolors = jet(101);
      for i = 1:(ncells-1)
         for j = (i+1):ncells
            norm_val(i,j) = (ncs{k}(i,j)-minNC)/(maxNC-minNC);
            link_col{i,j} = lcolors(round(norm_val(i,j)*100)+1,:);
         end
      end

      quad4 = prctile(get_upper(norm_val*100),0);
      for i = 1:(ncells-1)
         for j = 2:ncells
            if norm_val(i,j)*100 >= quad4
               plot3(sig(1,[i,j]), sig(2,[i,j]), sig(3,[i,j]), 'Color', link_col{i,j}, 'LineWidth', 2);
            end
         end
      end

   end

   if save
      saveas(gcf,'NCs-on-sig-3D.png');
      saveas(gcf,'NCs-on-sig-3D.fig');
   end

end