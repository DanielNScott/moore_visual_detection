function [] = signoise_subplot(sigvec,ncsvec,m,b,name)
   plot(sigvec, ncsvec, 'o'); hold on
   plot([-1,1], [-m+b, m+b], '--k')   
   grid on
   title(name)
   xlabel('Signal Corr.')
   ylabel('Noise Corr.')
   ylim([-0.5,1])
   legend({'Data', 'Fit line'}, 'Location', 'SouthEast')
end