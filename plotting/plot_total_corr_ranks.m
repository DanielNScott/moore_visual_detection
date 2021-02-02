function [] = plot_total_corr_ranks(ranks1, ranks2, ranks3, save)

   figure()
   set(gcf,'Position', [95   274   446   670])

   % Permutation matrix which takes ranks to inds (i.e. st P*ranks' = inds) is P = inds'*ranks.
   P1 = ranks2' == ranks1;
   P2 = ranks3' == ranks1;

   [rows1, ~] = find(P1);
   [rows2, ~] = find(P2);

   ncells = length(rows1);
   orders = [(1:ncells)', rows1, rows2];

   plot(orders', '-o');
   grid on
   xlim([0.5,3.5])
   ylim([0,12])
   xticks([1,2,3])

   xlabel('Stimulus #')
   ylabel('Rank Order')
   title('Total Correlation by Neuron')

   if save
      saveas(gcf,'Total-corr-rank.png');
      saveas(gcf,'Total-corr-rank.fig');
   end
end