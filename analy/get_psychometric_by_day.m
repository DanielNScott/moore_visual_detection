

levs  = [0,50,100,150,200,500,1000,2000,4000];
nlevs = 9;

mouse = data.mouse{1};


for d = 1:mouse.ndays
   
   parsed = mouse.cehav{d};
   
   slevs = get_contrast_levels(parsed.contrast, levs);
   %levs  = unique(parsed.contrast);
   %nlevs = length(slevs);    
   for i = 1:nlevs
      resp(d,i) = mean(parsed.lick(slevs{i}));
      smps(d,i) = numel(slevs{i});
   end
   
   %hr(d ,1) = nanmean(parsed.hitRate);
   hrh(d,1) = nanmean(parsed.hitRateHi);
   hrl(d,1) = nanmean(parsed.hitRateLow);
   
   far(d,1) = nanmean(parsed.faRate);
   %dp(d,1)  = nanmean(parsed.dPrime);
   %dph(d,1) = nanmean(parsed.dPrimeHi);
   %dpl(d,1) = nanmean(parsed.dPrimeLow);
end

colors = cool(mouse.ndays);

figure()
hold on;

subplot(2,2,1)
set(gca, 'ColorOrder', colors, 'NextPlot', 'replacechildren')
plot(levs, resp', '-o', 'LineWidth', 2);
grid on
xlabel('Stim Amplitude')
ylabel('Response Rate')
title('Psychometric Function')
legend({'Day 1', 'Day 2', '...'}, 'Location','SouthEast')

subplot(2,2,2)
imagesc(resp)

xticks(1:nlevs)
xticklabels(levs)
xtickangle(45)

xlabel('Stim Amplitude')
ylabel('Day')
title('Psychometric Function')

cbar = colorbar();
ylabel(cbar,'P(Resp)')



subplot(2,2,3)

set(gca, 'ColorOrder', colors, 'NextPlot', 'replacechildren')
plot(levs, smps', '-o', 'LineWidth', 2);
grid on
xlabel('Stim Amplitude')
ylabel('Num. Presentations')
title('Sample Rates')
legend({'Day 1', 'Day 2', '...'}, 'Location','NorthWest')

subplot(2,2,4)
imagesc(smps)

xticks(1:nlevs)
xticklabels(levs)
xtickangle(45)

xlabel('Stim Amplitude')
ylabel('Day')
title('Psychometric Function')

cbar = colorbar();
ylabel(cbar,'Samples')


set(gcf,'Position', [100   157   594   759])
