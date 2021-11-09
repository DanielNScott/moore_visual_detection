function [] = plot_trialwise_std(sd)

figure()
plot(sd)
ylabel('Pre-period Std. Dev.')
xlabel('Trial number')
grid on
title('Pre-Stimulus SD by Trial')
legend({'Cell 1', 'Cell 2', '   ...'})

end