function [] = plot_parsed_behavior(parsed)


figure
subplot(2,1,1)
plot(parsed.hitRate,'k-')
hold all,plot(parsed.faRate,'b-');

legend('FA', 'Hit')
xlabel('Trial Number');
title('Hit Rate and False Alarm Rate');
ylabel('p(H) and p(FA)')
ylim([0,1]);


subplot(2,1,2)

%d' plot
plot(parsed.dPrime,'k-')


xlabel('Trial Number');
title('D Prime')
legend('d-prime')
ylabel('d Prime')
ylim([-0.5,3])


end