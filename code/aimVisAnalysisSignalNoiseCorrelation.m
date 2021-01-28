
%%
% Align sample frequencies

frameSamples = (frameDelta:frameDelta:frameDelta*size(somaticF,2))*1000;
imTime  = ((frameSamples)/1000);
hertz = 1/frameDelta*1000;

% baseline data with df/f

blCutOffs = computeQuantileCutoffs(somaticF);
somaticF_BLs=slidingBaseline(somaticF,500,blCutOffs);
deltaFDS = (somaticF - somaticF_BLs)./somaticF_BLs;


% upsample data
tseries = timeseries(deltaFDS',imTime);
tseries_rs = resample(tseries,bData.sessionTime);
deltaF = tseries_rs.Data;

% parse the behavior for Hits, Misses, FAs, and CRs 

% find the timing in ms of each reward and lick
[rewardOnSamps, rewardOnVect] = getStateSamps(bData.teensyStates,4,1);
[licks, licksVect] = getStateSamps(bData.thresholdedLicks, 1, 1);

% Considering whisker stimulation

[stimOnSamps,stimOnVect]=getStateSamps(bData.teensyStates,2,1);
[catchOnSamps,catchOnVect]=getStateSamps(bData.teensyStates,3,1);
stimSamps = [stimOnSamps, catchOnSamps];
stimSamps = sort(stimSamps);
whiskerSample = stimSamps; 
[rewardOnSamps, rewardOnVect] = getStateSamps(bData.teensyStates,4,1);
[licks, licksVect] = getStateSamps(bData.thresholdedLicks, 1, 1);
lickWindow = 1500;

% loop over the first one hundred trials and extract hit/miss information
    for n = 2:100
        % for touch
        %parsed.amplitude(n)=bData.c1_amp(n);
        % for vision
        parsed.amplitude(n)=bData.contrast(n);
        tempLick = find(bData.thresholdedLicks(stimSamps(n):stimSamps(n)+lickWindow)==1);
        tempRun = find(bData.binaryVelocity(stimSamps(n):stimSamps(n)+ lickWindow) == 1);

        % check to see if the animal licked in the window
        if numel(tempLick)>0
            % it licked
            parsed.lick(n) = 1;
            parsed.lickLatency(n) = tempLick(1) - stimSamps(n);
            parsed.lickCount(n) = numel(tempLick);
            if parsed.amplitude(n)>0
                parsed.response_hits(n) = 1;
                parsed.response_miss(n) = 0;
                parsed.response_fa(n) = NaN;
                parsed.response_cr(n) = NaN;
            elseif parsed.amplitude(n) == 0
                parsed.response_fa(n) = 1;
                parsed.response_cr(n) = 0;
                parsed.response_hits(n) = NaN;
                parsed.response_miss(n) = NaN;
            end
        elseif numel(tempLick)==0
            parsed.lick(n) = 0;
            parsed.lickLatency(n) = NaN;
            parsed.lickCount(n) = 0;
            if parsed.amplitude(n)>0
                parsed.response_hits(n) = 0;
                parsed.response_miss(n) = 1;
                parsed.response_fa(n) = NaN;
                parsed.response_cr(n) = NaN;
            elseif parsed.amplitude(n) == 0
                parsed.response_fa(n) = 0;
                parsed.response_cr(n) = 1;
                parsed.response_hits(n) = NaN;
                parsed.response_miss(n) = NaN;
            end
        end
        
        % extract whether or not the mouse ran during the report window
        if numel(tempRun) > 0
            parsed.run(n) = 1;
            tempVel = bData.velocity(stimSamps(n):stimSamps(n)+ lickWindow);
            parsed.vel(n) = nanmean(abs(tempVel));
        else
            parsed.run(n) = 0;
            parsed.vel(n) = 0;
        end
        
        parsed.depth(n) = depth;
    end
    
parsed.contrast = parsed.amplitude;

% hit rate, false alarm rate, and d' calculation 
smtWin = 50;
parsed.hitRate = nPointMean(parsed.response_hits, smtWin)';
parsed.faRate = nPointMean(parsed.response_fa, smtWin)';

figure
subplot(2,1,1)
plot(parsed.hitRate);
ylim([0,1]);
title('Hit Rate')
ylabel('P(H)')
xlabel('Trial Number')
%legend('Day 4', 'Day 5', 'Day 6')
hold all

parsed.dPrime = norminv(parsed.hitRate) - norminv(parsed.faRate);

subplot(2,1,2)
plot(parsed.dPrime);
title('d Prime')
xlabel('Trial Number')
%legend('Day 1', 'Day 2', 'Day 3','Day 4','Day 5');
ylim([0,2])

% pre/post are ms before/after stimulus onset
pre = 1000;
post = 3000;


zStackCellMat=[];

% Get the event triggered average for fluorescence
for cellID = 1:size(somaticF,1)
    cell = deltaF(:,cellID); % this is the cell you want
  
    for stimid = 2:100
        whiskfluormat(stimid,:) = cell(whiskerSample(stimid) - pre: whiskerSample(stimid)+ post);
    end
    zStackCellMat(:,:,cellID) = whiskfluormat;
end


% Make subplots for each cell
    figure
    for cellID = 1:size(somaticF, 1)
        subplot (3,4,cellID)
        %plot([-1*pre:post],(zstackcellmat(:,:,cellID)'))
        plot([-1*pre:post], mean((zStackCellMat(:,:,cellID)'),2)-mean(mean(zStackCellMat(:,1:900,cellID))))
        title(['Cell', num2str(cellID)])
        ylim([-0.05,0.1])
        xlim([-1000,3000])
    end

%%



% capture evoked scores for every trial of every cell
zStackCellMatBaselined = (zStackCellMat(:,:,:)  -mean(zStackCellMat(:,1:900,:),2));

preScore = zStackCellMatBaselined(:,1:1000,:);
postScore = zStackCellMatBaselined(:,1000:2000,:);

preScore2 = trapz(preScore,2);
preScore2 = squeeze(preScore2);

postScore2 = trapz(postScore,2);
postScore2 = squeeze(postScore2);

evoked = (postScore2-preScore2)';


% calculate correlation between cells
corrMatrix = corr(evoked');

% convenience downsample for now to 100
orientation = bData.orientation;
orientation = orientation(2:100);

contrast = bData.contrast;
contrast = contrast(2:100);


% neurometric function for each cell

contrastZero = find(contrast == 0);
contrastLow = find(contrast < 20 & contrast >0);
contrastMid = find(contrast>=20 & contrast <50);
contrastHigh = find(contrast>=50 & contrast <100);
contrastHundred = find(contrast == 100);

evokedZeroContrast = mean(evoked(:,contrastZero),2);
evokedLowContrast = mean(evoked(:,contrastLow),2);
evokedMidContrast = mean(evoked(:,contrastMid),2);
evokedHighContrast = mean(evoked(:,contrastHigh),2);
evokedHundredContrast = mean(evoked(:,contrastHundred),2);

cellContrastMatrix = [evokedZeroContrast evokedLowContrast evokedMidContrast...
    evokedHighContrast evokedHundredContrast]

cellContrastMatrix = cellContrastMatrix';

figure
plot(cellContrastMatrix(:,4))
title('Neurometric Function')
xlabel('Contrast Level')
ylabel('Evoked Score')

% psychometric function for mouse

hitZeroContrast = mean(parsed.hitRate(:,contrastZero),2);
hitLowContrast = mean(parsed.hitRate(:,contrastLow),2);
hitMidContrast = mean(parsed.hitRate(:,contrastMid),2);
hitHighContrast = mean(parsed.hitRate(:,contrastHigh),2);
hitHundredContrast = mean(parsed.hitRate(:,contrastHundred),2);

hitContrastMatrix = [ hitZeroContrast hitLowContrast hitMidContrast...
    hitHighContrast hitHundredContrast ]

figure
plot(hitContrastMatrix)
title('Psychometric Function')
xlabel('Contrast Level')
ylabel('P(Hit)')

stim_trials{1} = orientation == 90;
stim_trials{2} = orientation == 0;
stim_trials{3} = orientation == 270;

sig = {};
sig{1} = mean(evoked(:,stim_trials{1}),2);
sig{2} = mean(evoked(:,stim_trials{2}),2);
sig{3} = mean(evoked(:,stim_trials{3}),2);

sig = [sig{1}' ; sig{2}' ; sig{3}' ];

sigcorr = corr(sig);

sig_normed = sig;
for i = 1:size(somaticF,1)
   sig_normed(:,i) = sig(:,i)./norm(sig(:,i));
end

%
ncovs = {};
for i = 1:3
   ncovs{i} = cov(evoked(:,stim_trials{i})');

end

% 
ncs = {};
evecs = {};
evals = {};
for i = 1:3
   ncs{i} = corr(evoked(:,stim_trials{i})');
   
   [v,d] = eig(ncs{i});
   [d,j] = sort(diag(d), 'descend');
   v = v(:,j);
   
   evecs{i} = v;
   evals{i} = d;
end

ncs_avg = cell2mat(ncs);
ncs_avg = reshape(ncs_avg, size(somaticF,1),size(somaticF,1),3);
ncs_avg = mean(ncs_avg, 3);

% Define rank orderings of total correlation in each case
[~, ranks1] = sort(sum(abs(ncs{1})), 'descend');
[~, ranks2] = sort(sum(abs(ncs{2})), 'descend');
[~, ranks3] = sort(sum(abs(ncs{3})), 'descend');



%

% assign triggeredDF for each cell, trial, and samples

triggeredDF= permute(zStackCellMat, [3 2 1]);

% hit miss comparisons
% make a vector of all trials and then logically index

parsed.allTrials = 1:numel(bData.stimSamps);

% now find the HM trials, defined as either all hits or misses that
% aren't nans as those would be fa/cr trials
parsed.allHMTrials = parsed.allTrials(isnan(parsed.response_hits)==0);

% likewise all catch trials are trials where either hits or misses were
% nans
parsed.allCatchTrials = parsed.allTrials(isnan(parsed.response_hits)==1);


parsed.allHitTrials = intersect(parsed.allHMTrials,find(parsed.response_hits==1));
parsed.allMissTrials = intersect(parsed.allHMTrials,find(parsed.response_miss==1));
parsed.allFaTrials = intersect(parsed.allCatchTrials,find(parsed.response_fa==1));
parsed.allCrTrials = intersect(parsed.allCatchTrials,find(parsed.response_cr==1));

parsed.allHitDF = triggeredDF(:,:,parsed.allHitTrials);
parsed.allMissDF = triggeredDF(:,:,parsed.allMissTrials);

% parsed.maxStim = triggeredDF(:,:,find(bData.contrast == 100));

% hit rate, false alarm rate, and d' calculation and engagemenbt threshold

smtWin = 75;
strCut = 70;
wkCut = 50;

parsed.hitRate = nPointMean(parsed.response_hits, smtWin)';
parsed.faRate = nPointMean(parsed.response_fa, smtWin)';
parsed.dPrime = norminv(parsed.hitRate) - norminv(parsed.faRate);
parsed.criterion = 0.5*(norminv(parsed.hitRate) + norminv(parsed.faRate));

parsed.smtContrast = nPointMean(parsed.contrast./100,smtWin);


parsed.hitRateStrong = nPointMean(parsed.response_hits(parsed.contrast>=strCut), smtWin)';
parsed.faRateStrong = parsed.faRate(parsed.contrast>=strCut);
parsed.strongInds = find(parsed.contrast>=strCut);
parsed.dPrimeStrong = norminv(parsed.hitRateStrong) - norminv(parsed.faRateStrong);

parsed.hitRateWeak = nPointMean(parsed.response_hits(parsed.contrast<=wkCut), smtWin)';
parsed.faRateWeak = parsed.faRate(parsed.contrast<=wkCut);
parsed.weakInds = find(parsed.contrast<=wkCut);
parsed.dPrimeWeak = norminv(parsed.hitRateWeak) - norminv(parsed.faRateWeak);

figure, plot(parsed.strongInds,parsed.hitRateStrong);
ylim([0,1]);
figure, plot(parsed.strongInds,parsed.dPrimeStrong);
plot(parsed.dPrime);

% Get a threshold
lowCut = 0.25;
highCut = 1-lowCut;
% find the direction of the skew
% if negative this is skewed right
% if positive this is skewed left
hr_skew=mean(parsed.hitRate)-median(parsed.hitRate);
hr_upQuant = quantile(parsed.hitRate,highCut);
hr_lowQuant = quantile(parsed.hitRate,lowCut);
hr_upQuantDiff = hr_upQuant-mean(parsed.hitRate);
hr_lowQuantDiff = median(parsed.hitRate)-hr_lowQuant;
hr_quantDiff = hr_upQuantDiff-hr_lowQuantDiff;
hr_lowQuantDeskew = median(parsed.hitRate)-(hr_upQuantDiff-abs(hr_skew));
hr_deskew = find(parsed.hitRate>hr_lowQuantDeskew);
disengagedTrials = find(parsed.hitRate<hr_lowQuantDeskew);

% recalculate d prime based on the engagement threshold
deSkewDPrime = norminv(parsed.hitRate(hr_deskew)) - norminv(parsed.faRate(hr_deskew));

% plot the original d prime and the deskewed d prime on one figure
figure
subplot(1,2,1)
plot(parsed.dPrime, 'k-');

subplot(1,2,2)
plot(deSkewDPrime, 'r-');


% re-evaluate the hit and miss trials based on the d prime deskewed trials

% lets make a vector of all trials and then logically index
% start with all we did
parsed.allTrials = hr_deskew;


% now find just the HM trials, defined as either all hits or misses that
% aren't nans as those would be fa/cr trials
parsed.allHMTrials = parsed.allTrials(isnan(parsed.response_hits(hr_deskew))==0);

% likewise all catch trials are trials where either hits or misses were
% nans
parsed.allCatchTrials = parsed.allTrials(isnan(parsed.response_hits(hr_deskew))==1);


parsed.allHitTrials = intersect(parsed.allHMTrials,find(parsed.response_hits==1));
parsed.allMissTrials = intersect(parsed.allHMTrials,find(parsed.response_miss==1));
parsed.allFaTrials = intersect(parsed.allCatchTrials,find(parsed.response_fa==1));
parsed.allCrTrials = intersect(parsed.allCatchTrials,find(parsed.response_cr==1));

parsed.allHitDF = triggeredDF(:,:,parsed.allHitTrials);
parsed.allMissDF = triggeredDF(:,:,parsed.allMissTrials);

% parsed.maxStim = triggeredDF(:,:,find(bData.contrast == 100));

% compare contrast distributions
hCont = parsed.contrast(parsed.allHitTrials);
mCont = parsed.contrast(parsed.allMissTrials);
figure,nhist({hCont,mCont},'box')


% look at threshold level trials, defined as trials as trials from 1 to 20%
% contrast and above or equal to a d Prime of 1.0
hitThreshContTrials = intersect(parsed.allHitTrials,find(parsed.contrast(hr_deskew)<=20 & parsed.contrast(hr_deskew)>0 & deSkewDPrime>=0.8))
missThreshContTrials = intersect(parsed.allMissTrials,find(parsed.contrast(hr_deskew)<=20 & parsed.contrast(hr_deskew)>0 & deSkewDPrime>=0.8))


parsed.thrHitDF = triggeredDF(:,:,hitThreshContTrials);
parsed.thrMissDF = triggeredDF(:,:,missThreshContTrials);

% plot the average activity for a cell on hit trials and miss trials
cellNum = 1;

cellHit = squeeze(parsed.thrHitDF(cellNum,:,:));
cellMiss = squeeze(parsed.thrMissDF(cellNum,:,:));

inds=size(parsed.thrHitDF,2);
hSem=nanstd(cellHit,1,2)./sqrt(numel(hitThreshContTrials)-1);
mSem=nanstd(cellMiss,1,2)./sqrt(numel(missThreshContTrials)-1);
tVec = frameDelta:frameDelta:frameDelta*inds;
figure
boundedline(tVec,nanmean(cellMiss,2),...
    mSem,'cmap',[1,0.3,0],'transparency',0.1)
    plot([0,0],[0.0,0.5],'k:')
    hold all
boundedline(tVec,nanmean(cellHit,2),...
    hSem,'cmap',[0,0.3,1],'transparency',0.05)


% ROC (detection) population for DP, start with pop distributions

preFr = pre;
postFr = post;

preStim_hit = squeeze(trapz(parsed.thrHitDF(:,1:preFr,:),2));
postStim_hit = squeeze(trapz(parsed.thrHitDF(:,preFr+1:preFr+postFr,:),2));

preStim_miss = squeeze(trapz(parsed.thrMissDF(:,1:preFr,:),2));
postStim_miss = squeeze(trapz(parsed.thrMissDF(:,preFr+1:preFr+postFr,:),2));

evokedHit = postStim_hit-preStim_hit;
evokedMiss = postStim_miss-preStim_miss;

figure,nhist({preStim_hit,postStim_hit,preStim_miss,postStim_miss},'box')
figure,nhist({evokedHit,evokedMiss},'box')

% sp now, start with pop distributions

noStim = find(parsed.contrast(hr_deskew)==0 & deSkewDPrime >=1.20);
highStim = find(parsed.contrast(hr_deskew)==100 & deSkewDPrime>=1.20);

preStim_noStim = squeeze(trapz(triggeredDF(:,1:preFr,noStim),2));
postStim_noStim = squeeze(trapz(triggeredDF(:,preFr+1:preFr+postFr,noStim),2));

evoked_noStim = postStim_noStim-preStim_noStim;

preStim_highStim = squeeze(trapz(triggeredDF(:,1:preFr,highStim),2));
postStim_highStim = squeeze(trapz(triggeredDF(:,preFr+1:preFr+postFr,highStim),2));

evoked_highStim = postStim_highStim-preStim_highStim;

figure,nhist({abs(evoked_noStim),abs(evoked_highStim)},'box')


% calculate SP and DP
for n=1:size(somaticF,1)
    testCell = n;
    %DP
    tVals = horzcat(evokedHit(testCell,:),evokedMiss(testCell,:));
    tLabs = horzcat(ones(size(evokedHit(testCell,:))),zeros(size(evokedMiss(testCell,:))));
    [aa,bb,~,cc]=perfcurve(tLabs,tVals,1);
    parsed.DP_Thr(n)=cc;
    clear tVals tLabs cc
    
    %SP
    tVals = horzcat(evoked_highStim(testCell,:),evoked_noStim(testCell,:));
    tLabs = horzcat(ones(size(evoked_highStim(testCell,:))),zeros(size(evoked_noStim(testCell,:))));
    [aa,bb,~,cc]=perfcurve(tLabs,tVals,1);
    parsed.SP_all(n)=cc;
    clear tVals tLabs cc
end

figure,plot(parsed.SP_all,'ko')
hold all,plot(parsed.DP_Thr,'bo')
figure,plot(parsed.SP_all,parsed.DP_Thr,'o')

% shuffle the trials labels 1000 times and run the ROC on shuffled data

    poolShuffAUCDP = [];
    poolShuffAUCSP = [];
    
    % calculate SP and DP
    for n=1:size(somaticF,1)
        testCell = n;
        tVals = horzcat(evokedHit(testCell,:),evokedMiss(testCell,:));
        tLabs = horzcat(ones(size(evokedHit(testCell,:))),zeros(size(evokedMiss(testCell,:))));
        
       %shuffle for DP
        for nn = 1:1000
            
            tLabsShuff = tLabs(randperm(length(tLabs)));            
            [aa,bb,~,cc]=perfcurve(tLabsShuff,tVals,1);            
            poolShuffAUCDP(nn,n) = cc;
            
            clear cc tLabsShuff 
            
        end
        
        clear tVals tLabs 
        
        %shuffle for SP
        tVals = horzcat(evoked_highStim(testCell,:),evoked_noStim(testCell,:));
        tLabs = horzcat(ones(size(evoked_highStim(testCell,:))),zeros(size(evoked_noStim(testCell,:))));
        
        for mm = 1:1000
            
            tLabsShuff = tLabs(randperm(length(tLabs)));
            [aa,bb,~,cc]=perfcurve(tLabsShuff,tVals,1);            
            poolShuffAUCSP(mm,n) = cc;
            
            clear cc tLabsShuff 
            
        end
        
        clear tVals tLabs tLabsNotShuffled cc 
    end
    
    figure,plot(mean(poolShuffAUCSP),'ko')
    hold all,plot(mean(poolShuffAUCDP),'bo')
    figure,plot(mean(poolShuffAUCSP),mean(poolShuffAUCDP),'o')
   
 % calculate which cells are hit and miss based on 1.5 standard deviations
 % from the shuffled mean for each cell
    
    dataDP = parsed.DP_Thr;
    dataSP = parsed.SP_all;
    
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
