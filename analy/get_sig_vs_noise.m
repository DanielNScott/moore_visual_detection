function [ps] = get_sig_vs_noise(sigcorr, ncs, ncs_avg)

   ps = cell(4,1);
   
   sigvec = get_upper(sigcorr);
   for i = 1:3
      ncsvec = get_upper(ncs{i});
      [ps{i}.m, ps{i}.b] = fit_orthog_line(sigvec,ncsvec);
   end

   ncsvec = get_upper(ncs_avg);
   [ps{4}.m, ps{4}.b] = fit_orthog_line(sigvec,ncsvec);

end