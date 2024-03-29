function [DP_Thr, SP_all, poolShuffAUCDP, poolShuffAUCSP] = get_SPDP(parsed,dF, dFWindow)

% Function params
% Shuffle number parameter
shuffle_num = 100;


% Function

pre = abs(dFWindow(1));
post = dFWindow(2);
%

% assign triggeredDF for each cell, trial, and samples

triggeredDF = permute(dF, [3 2 1]);

% hit miss comparisons
% make a vector of all trials and then logically index
allHitDF = triggeredDF(:,:,parsed.allHitTrials);
allMissDF = triggeredDF(:,:,parsed.allMissTrials);

% Old 
%hitThreshContTrials = intersect(parsed.allHitTrials,find(parsed.contrast <= 20 & parsed.contrast>0 & parsed.dPrime>=0.8));
%missThreshContTrials = intersect(parsed.allMissTrials,find(parsed.contrast <=20 & parsed.contrast>0 & parsed.dPrime>=0.8));

% Should replace with hits and misses given known daily psychometric thresh
% 
%thrHitDF = triggeredDF( :,:,hitThreshContTrials);
%thrMissDF = triggeredDF(:,:,missThreshContTrials);
thrHitDF  = triggeredDF(:,:,find(parsed.response_hits_hi == 1));
thrMissDF = triggeredDF(:,:,find(parsed.response_miss_hi == 1));


preFr = pre;
postFr = post;

preStim_hit = squeeze(trapz(thrHitDF(:,1:preFr,:),2));
postStim_hit = squeeze(trapz(thrHitDF(:,preFr+1:preFr+postFr,:),2));

preStim_miss = squeeze(trapz(thrMissDF(:,1:preFr,:),2));
postStim_miss = squeeze(trapz(thrMissDF(:,preFr+1:preFr+postFr,:),2));

evokedHit = postStim_hit-preStim_hit;
evokedMiss = postStim_miss-preStim_miss;


% sp now, start with pop distributions

noStim   = find(parsed.contrast == 0    & parsed.dPrime >= 0.8);
highStim = find(parsed.contrast >= 2000 & parsed.dPrime >= 0.8);

preStim_noStim = squeeze(trapz(triggeredDF(:,1:preFr,noStim),2));
postStim_noStim = squeeze(trapz(triggeredDF(:,preFr+1:preFr+postFr,noStim),2));

evoked_noStim = postStim_noStim-preStim_noStim;

preStim_highStim = squeeze(trapz(triggeredDF(:,1:preFr,highStim),2));
postStim_highStim = squeeze(trapz(triggeredDF(:,preFr+1:preFr+postFr,highStim),2));

evoked_highStim = postStim_highStim-preStim_highStim;

%
nCells = size(dF,3);

% calculate SP and DP
for n=1:nCells
    testCell = n;
    %DP
    tVals = horzcat(evokedHit(testCell,:),evokedMiss(testCell,:));
    
    % 
    tLabs = horzcat(ones(size(evokedHit(testCell,:))),zeros(size(evokedMiss(testCell,:))));
    [aa,bb,~,cc]=perfcurve(tLabs,tVals,1);
    DP_Thr(n)=cc;
    clear tVals tLabs cc

    %SP
    tVals = horzcat(evoked_highStim(testCell,:),evoked_noStim(testCell,:));
    tLabs = horzcat(ones(size(evoked_highStim(testCell,:))),zeros(size(evoked_noStim(testCell,:))));
    [aa,bb,~,cc]=perfcurve(tLabs,tVals,1);
    SP_all(n)=cc;
    clear tVals tLabs cc
end

% shuffle the trials labels 1000 times and run the ROC on shuffled data

    poolShuffAUCDP = [];
    poolShuffAUCSP = [];
   
    nwarnings = 0;
    % calculate SP and DP
    for n=1:nCells
        testCell = n;
        tVals = horzcat(evokedHit(testCell,:),evokedMiss(testCell,:));
        tLabs = horzcat(ones(size(evokedHit(testCell,:))),zeros(size(evokedMiss(testCell,:))));

       %shuffle for DP
        for nn = 1:shuffle_num

            tLabsShuff = tLabs(randperm(length(tLabs)));
            try
               [aa,bb,~,cc]=perfcurve(tLabsShuff,tVals,1);
            catch ME
               %disp(ME)
               if nwarnings < 1
                  disp('Perfcurve failure in get_signal_probability_detect_probability at line 92.')
                  nwarnings = nwarnings + 1;
               end
               cc = NaN;
            end
            poolShuffAUCDP(nn,n) = cc;

            clear cc tLabsShuff 

        end

        clear tVals tLabs 
        
  

        %shuffle for SP
        tVals = horzcat(evoked_highStim(testCell,:),evoked_noStim(testCell,:));
        tLabs = horzcat(ones(size(evoked_highStim(testCell,:))),zeros(size(evoked_noStim(testCell,:))));

        for mm = 1:shuffle_num

            tLabsShuff = tLabs(randperm(length(tLabs)));
            [aa,bb,~,cc]=perfcurve(tLabsShuff,tVals,1);            
            poolShuffAUCSP(mm,n) = cc;

            clear cc tLabsShuff 

        end

        clear tVals tLabs tLabsNotShuffled cc 
    end
  


end
    
