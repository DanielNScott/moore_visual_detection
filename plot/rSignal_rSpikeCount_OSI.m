%this script is run on the parsed data set, and it makes histograms of the
%distribution of noise correlation and signal correlation values for pairs
%of PV cells of the 234 cells collected. this script also calculates an OSI
%for each PV cells but the calculation is (max-min)/(max+min) because there
%are only 3 orientations


%% histogram of noise correlation values

% make a vector of each cell pairs' noise correlation value
noiseCorr = cell2mat(data.corr(:));
[noiseCorr, noiseCorrInd, ic] = unique(round(noiseCorr,4));


% plot the distribution of NC values
figure
subplot(2,1,1)
hist(noiseCorr)
xlabel('Pairwise Noise Correlation')
ylabel('Number of PV Pairs')
xlim([-1,1])
legend('All Cells', 'location', 'northwest')
title('Noise Correlation Values of PV Cell Pairs in V1')

% find the indices of putative L2 and L3 cells
depthVectorNoise = cell2mat(data.depthCell(:));
depthVectorNoise = depthVectorNoise(noiseCorrInd);

layer2Ind = find(depthVectorNoise<175);
layer3Ind = find(depthVectorNoise>175);

l2NoiseCorr = noiseCorr(layer2Ind);
l3NoiseCorr = noiseCorr(layer3Ind);

% plot the distrubtion of NC values by layer
subplot(2,1,2)
nhist({l2NoiseCorr, l3NoiseCorr}, 'box', 'numbers')
xlabel('Pairwise Noise Correlation')
ylabel('Number of PV Pairs')
legend('Layer 2', 'Layer 3', 'location', 'northwest')
xlim([-1,1])

%% signal correlation histogram

% make a vector of each cell pairs' signal correlation value
sigCorr = cell2mat(data.sigCorr(:));
[sigCorr, sigCorrInd, icSig] = unique(round(sigCorr,4));

% plot the distribution of SC values
figure
subplot(2,1,1)
histogram(sigCorr)
xlabel('Pairwise Signal Correlation')
ylabel('Number of PV Pairs')
xlim([-1,1])
legend('All Cells', 'location', 'northwest')
title('Signal Correlation Values of PV Cell Pairs in V1')

% find the indices of putative L2 and L3 cells
depthVectorSignal = cell2mat(data.depthCell(:));
depthVectorSignal = depthVectorSignal(sigCorrInd);

layer2Ind = find(depthVectorSignal<175);
layer3Ind = find(depthVectorSignal>175);

l2SignalCorr = sigCorr(layer2Ind);
l3SignalCorr = sigCorr(layer3Ind);

% plot the distrubtion of SC values by layer
subplot(2,1,2)
nhist({l2SignalCorr, l3SignalCorr}, 'box', 'numbers')
xlabel('Pairwise Signal Correlation')
ylabel('Number of PV Pairs')
legend('Layer 2', 'Layer 3', 'location', 'northwest')
xlim([-1,1])

%% orientation selectivity index histogram

%tuning and orientation selectivity 
data.tuning = abs(data.tuning)
out = bsxfun(@rdivide, data.tuning, max(data.tuning,[],2));

% calculate the orientation selectivity index by using the preferred
% direction and the least preferred direction, since we only have three
% orienations and can't compare orthogonal
osi = (max(out, [], 1) - min(out, [], 1)) ./ (max(out, [], 1) + min(out, [], 1));


% find the indices for osi in putative L2 and L3 cells
depth = data.depth(:,2)
layer2Ind = find(depth<175)
layer3Ind = find(depth>175)
 
l2Osi = osi(layer2Ind)
l3Osi = osi(layer3Ind)

% plot the distrubtion of osi values by layer
figure
subplot(2,1,1)
hist(osi)
xlabel('Orientation Selectivity Index')
ylabel('Number of PV Cells')
xlim([0,1])
legend('All Cells', 'location', 'northwest')
title('Orientation Selectivity of V1 PV Cells')
subplot(2,1,2)
nhist({l2Osi, l3Osi}, 'box')
xlabel('Orientation Selectivity Index')
ylabel('pdf')
legend('Layer 2', 'Layer 3', 'location', 'northwest')
xlim([0,1])

