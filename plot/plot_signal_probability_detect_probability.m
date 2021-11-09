function [] = plot_signal_probability_detect_probability(SP, DP, DP_shuff, SP_shuff)


figure
subplot(2,1,1)
plot(SP,'ko')
xlabel('Cell Number')
ylabel('Signal Probability')


subplot(2,1,2)
plot(DP,'bo')
xlabel('Cell Number')
ylabel('Detect Probability')

figure,plot(SP,DP,'o')
xlabel('Signal Probability')
ylabel('Detect Probability')
title('Detect Probability vs. Signal Probability')
xlim([0,1]);
ylim([0,1]);


dataDP = DP;
dataSP = SP;

poolShuffAUCDP = DP_shuff;
poolShuffAUCSP = SP_shuff;

dataDPShuffMean = mean(poolShuffAUCDP);
dataSPShuffMean = mean(poolShuffAUCSP);

meanDP = dataDPShuffMean;

dataDPShuffSTD = std(poolShuffAUCDP);
dataSPShuffSTD = std(poolShuffAUCSP);

critDP = 1.5 * dataDPShuffSTD;
critSP = 1.5 * dataSPShuffSTD;

missCellInd  = find(dataDP<(meanDP-critDP));
nonPredictiveCellInd = find(dataDP<(meanDP+critDP) & dataDP>(meanDP-critDP));
hitCellInd = find(dataDP>(meanDP+critDP));

missCellVect  = dataDP<(meanDP-critDP);
nonPredictiveCellVect = dataDP<(meanDP+critDP) & dataDP>(meanDP-critDP);
hitCellVect = dataDP>(meanDP+critDP);

missCellNum  = sum(dataDP<(meanDP-critDP));
nonPredictiveCellNum = sum(dataDP<(meanDP+critDP) & dataDP>(meanDP-critDP));
hitCellNum = sum(dataDP>(meanDP+critDP));

figure
% make a pie chart that show the number of hit, miss, and nonPredictive
% cells
x = [hitCellNum, missCellNum, nonPredictiveCellNum];
pie(x,{'Hit Cells','Miss Cells','Non-Predictive Cells'})
title('Fraction of Behaviorally-Representative Neurons')
colormap([  0 0 1;      %// blue
            1 0 0;      %// red  
            .5 .5 .5])  %// grey


end 