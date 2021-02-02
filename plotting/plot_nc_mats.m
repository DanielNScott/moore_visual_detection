function [] = plot_nc_mats(ncs, ranks1, ranks2, ranks3, save)

   figure()

   subplot(3,3,1)
   imagesc(ncs{1})
   xlabel('Neuron ID')
   ylabel('Neuron ID')
   title('S1 NCs')

   subplot(3,3,2)
   imagesc(ncs{2})
   xlabel('Neuron ID')
   ylabel('Neuron ID')
   title('S2 NCs')

   subplot(3,3,3)
   imagesc(ncs{3})
   xlabel('Neuron ID')
   ylabel('Neuron ID')
   title('S3 NCs')

   subplot(3,3,4)
   imagesc(ncs{1}(ranks1,ranks1))
   xlabel('Neuron Total Corr. Rank')
   ylabel('Neuron Total Corr. Rank')
   title('S1 NCs')

   subplot(3,3,5)
   imagesc(ncs{2}(ranks2,ranks2))
   xlabel('Neuron Total Corr. Rank')
   ylabel('Neuron Total Corr. Rank')
   title('S2 NCs')

   subplot(3,3,6)
   imagesc(ncs{3}(ranks3,ranks3))
   xlabel('Neuron Total Corr. Rank')
   ylabel('Neuron Total Corr. Rank')
   title('S3 NCs')

   subplot(3,3,7)
   histogram(get_upper(ncs{1}),'BinEdges',-1:0.05:1)
   grid on
   title('S1 NC Histogram')
   ylabel('Count')
   xlabel('Noise Correlation')

   subplot(3,3,8)
   histogram(get_upper(ncs{2}),'BinEdges',-1:0.05:1)
   grid on
   title('S2 NC Histogram')
   ylabel('Count')
   xlabel('Noise Correlation')

   subplot(3,3,9)
   histogram(get_upper(ncs{3}),'BinEdges',-1:0.05:1)
   grid on
   title('S3 NC Histogram')
   ylabel('Count')
   xlabel('Noise Correlation')

   if save
      saveas(gcf,'NC-matrices.png');
      saveas(gcf,'NC-matrices.fig');
   end

end