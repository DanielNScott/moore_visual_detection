function [] = plot_bhv_simple(bhv, varargin)

% Default plot layout, modify if input
dvec = [-1,1,1,1];
pvec = get_plotvec(varargin, dvec);

subplotpv(pvec,1)
plot(bhv.hitRateHi ,'-o', 'LineWidth', 2); hold on
plot(bhv.hitRateLow,'-o', 'LineWidth', 2)
plot(bhv.faRate'   ,'-o', 'LineWidth', 2)
plot(bhv.dPrime    ,'-o', 'LineWidth', 2)
grid on

legend('HR High', 'HR Low', 'FA Rate', 'DP')
xlabel('Trial Number');
title('HR, FA, DP');
ylabel('p(H) and p(FA)')
ylim([-0.2,1.8]);
xlim([1, bhv.n_trials])

if pvec(1) == 0
   set(gcf,'Position', [108         517        1212         276])
end

end