function [] = plot_sig_detection(parsed)

   figure()
   subplot(2,1,1)
   plot(parsed.hitRate);
   ylim([0,1]);
   title('Hit Rate')
   ylabel('P(H)')
   xlabel('Trial Number')
   %legend('Day 4', 'Day 5', 'Day 6')
   hold all


   subplot(2,1,2)
   plot(parsed.dPrime);
   title('d Prime')
   xlabel('Trial Number')
   %legend('Day 1', 'Day 2', 'Day 3','Day 4','Day 5');
   ylim([0,2])
end