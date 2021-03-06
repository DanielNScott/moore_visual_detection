function [] = plot_parsed_behavior(parsed)


figure
subplot(3,1,1)
plot(parsed.hitRate,'k-')
hold all
plot(parsed.faRate,'b-');
grid on

legend('Hit', 'FA')
xlabel('Trial Number');
title('Hit Rate and False Alarm Rate');
ylabel('p(H) and p(FA)')
ylim([0,1]);

subplot(3,1,2)

%d' plot
plot(parsed.dPrime,'k-')


xlabel('Trial Number');
title('D Prime')
legend('d-prime')
ylabel('d Prime')
ylim([-0.5,3])
grid on


subplot(3,1,3)

%criterion plot
plot(parsed.criterion,'k-')


xlabel('Trial Number');
title('Criterion')
legend('Criterion')
ylabel('Criterion')
ylim([-1,2])
grid on

end
