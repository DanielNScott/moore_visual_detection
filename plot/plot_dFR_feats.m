function [] = plot_dFR_feats(basis, coefs, svals, hits, miss)

figure();
for i = 1:16
   subplot(4,4,i)
   plot(svals(:,i)./sum(svals(:,i)),'-o')
   xlim([1,10])
   grid on
   title(['Neuron ' num2str(i)])
   xlabel('Singular Value Number')
   ylabel('% Std. Explained')
   
end
set(gcf,'Position', [95          27        1258    947])

figure();
for i = 1:16
   subplot(4,4,i)
   plot(squeeze(basis(:,1,i))); hold on;   
   plot(squeeze(basis(:,2,i)));
   grid on
   xlim([1,size(basis,1)])
   title(['Neuron ' num2str(i)])
   xlabel('Basis Timeseries')
   ylabel('\DeltaF/F')
   
end
set(gcf,'Position', [95          27        1258    947])

figure();
for i = 1:16
   subplot(4,4,i)
   histogram(coefs(hits,1,i), 'BinEdges', -0.5:0.05:0.5); hold on;
   histogram(coefs(miss,1,i), 'BinEdges', -0.5:0.05:0.5)
   grid on
   title(['Neuron ' num2str(i)])
   xlabel('Basis 2 Coefficient')
   ylabel('Counts')
   
end
set(gcf,'Position', [95          27        1258    947])


figure();
for i = 1:16
   subplot(4,4,i)
   histogram(coefs(hits,2,i), 'BinEdges', -0.5:0.05:0.5); hold on;
   histogram(coefs(miss,2,i), 'BinEdges', -0.5:0.05:0.5)
   grid on
   title(['Neuron ' num2str(i)])
   xlabel('Basis 2 Coefficient')
   ylabel('Counts')
   
end
set(gcf,'Position', [95          27        1258    947])


end