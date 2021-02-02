function [] = plot_sig_vs_noise(sigcorr, ncs, ncs_avg, save)

   sigvec = get_upper(sigcorr);

   figure()
   for i = 1:3
      subplot(2,2,i)
      
      ncsvec = get_upper(ncs{i});
      [m, b] = fit_orthog_line(sigvec,ncsvec);
      signoise_subplot(sigvec, ncsvec, m,b, ['S' num2str(i) ' Signal & Noise'])
      xlim([-1,1])
      ylim([-1,1])
   end

   subplot(2,2,4)
   ncsvec = get_upper(ncs_avg);
   [m, b] = fit_orthog_line(sigvec,ncsvec);
   signoise_subplot(sigvec, ncsvec, m,b, 'Avg. Signal & Noise')
   xlim([-1,1])
   ylim([-1,1])
      
   if save
      saveas(gcf,'Sig-vs-Noise.png');
      saveas(gcf,'Sig-vs-Noise.fig');
   end

end