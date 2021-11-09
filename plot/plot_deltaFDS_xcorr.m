function [] = plot_deltaFDS_xcorr(deltaFDS)
% Old, hacked, specific, needs fixing

figure()
[r,x] = xcorr(deltaFDS(1,1:10000)',deltaFDS(1,1:10000)',30, 'coeff');

plot(x(31:end),r(31:end),'-o','LineWidth', 2)
grid on

r = xcorr(deltaFDS(1,1:10000)',deltaFDS(2,1:10000)',30, 'coeff');
hold on

plot(x(31:end),r(31:end),'-o','LineWidth', 2)
legend({'Auto', 'Cross'})
title('Ca^2^+ Timeseries Correlations')
xlabel('Lag [ms]')
ylabel('Correlation Coefficient')

end