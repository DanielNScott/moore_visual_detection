function [] = plot_parsed_behavior(parsed)

% Pull things out for easy plotting
hits = parsed.response_hits;
hits(hits == 0) = NaN;

miss = parsed.response_miss;
miss(miss == 0) = NaN;

cr = parsed.response_cr;
cr(cr == 0) = NaN;

fa = parsed.response_fa;
fa(fa == 0) = NaN;

figure('Visible','Off')
subplot(3,1,1)
plot(parsed.hitRate,'o', 'LineWidth', 2)
hold on
plot(parsed.faRate','o', 'LineWidth', 2)
grid on

plot(hits - 1   , 'x','LineWidth',2);
plot(miss - 1.05, 'x','LineWidth',2);
plot(fa   - 1.1 , 'x','LineWidth',2);
plot(cr   - 1.15, 'x','LineWidth',2);

legend('Hit Rate', 'FA Rate', 'Hits', 'Misses', 'FAs', 'CRs')
xlabel('Trial Number');
title('Hit Rate and False Alarm Rate');
ylabel('p(H) and p(FA)')
ylim([-0.2,1]);

subplot(3,1,2)
plot(parsed.hitRateHi,  'o', 'LineWidth', 2); hold on;
plot(parsed.hitRateLow, 'o', 'LineWidth', 2)
plot(parsed.faRate','o', 'LineWidth', 2)
grid on

legend('Hit Rate High', 'Hit Rate Low', 'FA Rate')
xlabel('Trial Number');
title('Hit Rate and False Alarm Rate');
ylabel('p(H) and p(FA)')
ylim([0,1]);


subplot(3,1,3)
%d' plot
plot(parsed.dPrime   ,'k-', 'LineWidth', 2); hold on;
plot(parsed.dPrimeHi , 'LineWidth', 2)
plot(parsed.dPrimeLow, 'LineWidth', 2)

xlabel('Trial Number');
title('D Prime')
legend({'d-prime','d-prime high', 'd-prime low'})
ylabel('d Prime')
ylim([-0.5,3])
grid on

set(gcf,'Position', [95          28        1123         946])

end