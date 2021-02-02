function [] = plot_psychometric(parsed, clevs)

% psychometric function for mouse

hitZeroContrast = mean(parsed.hitRate(:,clevs.Zero),2);
hitLowContrast = mean(parsed.hitRate(:,clevs.Low),2);
hitMidContrast = mean(parsed.hitRate(:,clevs.Mid),2);
hitHighContrast = mean(parsed.hitRate(:,clevs.High),2);
hitHundredContrast = mean(parsed.hitRate(:,clevs.Hundred),2);

hitContrastMatrix = [ hitZeroContrast hitLowContrast hitMidContrast...
    hitHighContrast hitHundredContrast ];

figure
plot(hitContrastMatrix)
title('Psychometric Function')
xlabel('Contrast Level')
ylabel('P(Hit)')


end