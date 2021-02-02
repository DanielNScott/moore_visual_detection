function [] = plot_raw_corr(corrMatrix, save)

   figure()
   imagesc(corrMatrix)
   xlabel('Cell Number')
   ylabel('Cell Number')
   title('Raw Correlation Across Cells')
   colorbar()
   
   if save
      saveas(gcf,'./Raw-dfbyF-corr.png');
      saveas(gcf,'./Raw-dfbyF-corr.fig');
   end
end
