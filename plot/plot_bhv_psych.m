function [] = plot_bhv_psych(bhv, varargin)

% Default plot layout, modify if input
dvec = [-1,2,1,1; 0,2,1,2];
pvec = get_plotvec(varargin, dvec);

subplotpv(pvec,1)
plot(bhv.psych_levs, bhv.psych_phit, '-o');
grid on
xlabel('Stim Amplitude')
ylabel('Response Rate')
title('Psychometric Function')

subplotpv(pvec,2)
plot(bhv.psych_levs, bhv.psych_smps, '-o');
grid on
xlabel('Stim Amplitude')
ylabel('Num. Presentations')
title('Sample Rates')

if pvec(1) ~= 0
   set(gcf,'Position', [100   446   548   498])
end

end