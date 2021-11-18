function [] = plot_flr_dF_typed(flr, msk_strs, mid, dstr, cid, varargin)

   dvec = [-1,1,1,1];
   pvec = get_plotvec(varargin, dvec);

   subplotpv(pvec,1)

   hold on;
   for i = 1:length(msk_strs)
      fs = msk_strs{i};

      x   = -1000:3000;
      y   = flr.(fs).zFm(:,cid);
      %err = flr.(fs).cFse(:,cid);
      
      %errorbar(x, y, err, '-o', 'LineWidth',2)
      plot(x, y, '-', 'LineWidth',2)
   end
   grid on
   legend(msk_strs, 'Location', 'NorthWest')
   xlim([-1000,3000])
   ylim([-2.5, 2.5])
   
   plot([0   ,    0],[-2.5,2.5], '--k', 'LineWidth', 2)
   plot([1000, 1000],[-2.5,2.5], '--k', 'LineWidth', 2)
   plot([2000, 2000],[-2.5,2.5], '--k', 'LineWidth', 2)
   
   title(['Mouse ', num2str(mid), ', ', dstr, ', Cell ', num2str(cid)])

   legend(msk_strs)
   
end