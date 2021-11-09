function [] = plot_bhv_trls(bhv)

% Pull things out for easy plotting
hits = to_nan(bhv.msk.hit,  0);
miss = to_nan(bhv.msk.miss, 0);
cr   = to_nan(bhv.msk.cr,   0);
fa   = to_nan(bhv.msk.fa,   0);

%figure('Visible',visibility)
subplot(4,1,1)
plot(bhv.hitRate,'-o', 'LineWidth', 2)
hold on
plot(bhv.faRate','-o', 'LineWidth', 2)
grid on

plot(hits - 1   , 'x','LineWidth',2);
plot(miss - 1.05, 'x','LineWidth',2);
plot(fa   - 1.1 , 'x','LineWidth',2);
plot(cr   - 1.15, 'x','LineWidth',2);

legend('Hit Rate', 'FA Rate', 'Hits', 'Misses', 'FAs', 'CRs')
xlabel('Trial Number');
title('Psychometric Rates and Trial Results');
ylabel('p(H) and p(FA)')
ylim([-0.2,1]);
xlim([1, bhv.n_trials])

subplot(4,1,2)
plot(bhv.hitRateHi,  '-o', 'LineWidth', 2); hold on;
plot(bhv.hitRateLow, '-o', 'LineWidth', 2)
plot(bhv.faRate',    '-o', 'LineWidth', 2)

legend('Hit Rate High', 'Hit Rate Low', 'FA Rate')
fmt('False Alarm Rate and Decomposed Hit Rate', 'Trial Number', 'p(H) and p(FA)', bhv.n_trials)
ylim([0,1]);


valid_msk = and((bhv.dPrimeHi > 1.2),(bhv.faCont <= 0.35));

subplot(4,1,3)
%d' plot
plot(bhv.dPrime   , 'k-', 'LineWidth', 2); hold on;
plot(bhv.dPrimeHi ,       'LineWidth', 2)
plot(bhv.dPrimeLow,       'LineWidth', 2)
plot(valid_msk,     'kx', 'LineWidth', 2);

legend({'d-prime','d-prime high', 'd-prime low', 'Valid'})
fmt('D Prime', 'Trial', 'd Prime', bhv.n_trials)
ylim([-0.5,3])

subplot(4,1,4)
plot(bhv.lickCount,  '-o', 'LineWidth', 2); hold on
yyaxis right
plot(bhv.lickLatency,'-o', 'LineWidth', 2);
yyaxis left
plot(bhv.vel,        '-o', 'LineWidth', 2);

fmt('Other Behavior', 'Trial', '', bhv.n_trials)
yyaxis right; ylabel('Lick Latency')
yyaxis left;  ylabel('Lick Count')

legend({'Lick Count', 'Run Speed', 'Lick Latency'})

set(gcf,'Position', [95          28        1123         946])

end

function [] = fmt(tstr, xstr, ystr, n_trials)

grid on
xlim([1, n_trials])

title(tstr)
xlabel(xstr)
ylabel(ystr)

end
