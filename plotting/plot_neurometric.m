function [] = plot_neurometric(evoked, clevs)

% neurometric function for each cell

evokedZeroContrast = mean(evoked(:,clevs.Zero),2);
evokedLowContrast = mean(evoked(:,clevs.Low),2);
evokedMidContrast = mean(evoked(:,clevs.Mid),2);
evokedHighContrast = mean(evoked(:,clevs.High),2);
evokedHundredContrast = mean(evoked(:,clevs.Hundred),2);

cellContrastMatrix = [evokedZeroContrast evokedLowContrast evokedMidContrast...
    evokedHighContrast evokedHundredContrast];

cellContrastMatrix = cellContrastMatrix';

figure
plot(cellContrastMatrix(:,4))
title('Neurometric Function')
xlabel('Contrast Level')
ylabel('Evoked Score')

end