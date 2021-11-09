function [] = get_plot_SPDPs(bData, parsed, zStackCellMat, frameDelta, dFWindow, somaticF)


pre = abs(dFWindow(1));
post = dFWindow(2);
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
hitThreshContTrials = intersect(parsed.allHitTrials,find(parsed.contrast(hr_deskew)<=20 & parsed.contrast(hr_deskew)>0 & deSkewDPrime>=0.8));
missThreshContTrials = intersect(parsed.allMissTrials,find(parsed.contrast(hr_deskew)<=20 & parsed.contrast(hr_deskew)>0 & deSkewDPrime>=0.8));


parsed.thrHitDF = triggeredDF(:,:,hitThreshContTrials);
parsed.thrMissDF = triggeredDF(:,:,missThreshContTrials);

% plot the average activity for a cell on hit trials and miss trials
cellNum = 1;

cellHit  = squeeze(parsed.thrHitDF(cellNum,:,:));
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

    end