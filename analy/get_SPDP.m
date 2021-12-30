function mus = get_SPDP(mus, window)
% Window is [beg, fin; beg, fin] for ms in trial
% So to get DP for response vs baseline is [1,1000; 1001,2000]
% window(1001,2000; 2001,3000)


% Loop over mice
for mnum = 1:numel(mus)
   
   % Number of days
   ndays = numel(mus{mnum}.bhv);
   
   % Remove any days with no imaging
   for dnum = 1:ndays

      flr = mus{mnum}.PVs{dnum};
      bhv = mus{mnum}.bhv{dnum};
      
      mus{mnum}.PVs{dnum} = SPDP(flr, bhv, window);
         
   end
end

end
    
function flr = SPDP(flr, bhv, window)

   shuffle_num = 100;
   df = flr.dF;


   triggeredDF = permute(df, [3 2 1]);

   hitInd = bhv.nds.hit;
   missInd = bhv.nds.miss;
   amps = bhv.amp;
   dPrime = bhv.dPrime;

   % hit miss comparisons
   % make a vector of all trials and then logically index
   allHitDF = triggeredDF(:,:,hitInd);
   allMissDF = triggeredDF(:,:,missInd);


   hitThreshContTrials = intersect(hitInd,find(amps <= 1000 & amps>0 & dPrime>=1.0));
   missThreshContTrials = intersect(missInd,find(amps <=1000 & amps>0 & dPrime>=1.0));

   thrHitDF = triggeredDF( :,:,hitThreshContTrials);
   thrMissDF = triggeredDF(:,:,missThreshContTrials);



   preFr  = window(1,1):window(1,2);
   postFr = window(2,1):window(2,2);

   preStim_hit = squeeze(trapz(thrHitDF(:,preFr,:),2));
   postStim_hit = squeeze(trapz(thrHitDF(:,postFr,:),2));

   preStim_miss = squeeze(trapz(thrMissDF(:,preFr,:),2));
   postStim_miss = squeeze(trapz(thrMissDF(:,postFr,:),2));

   evokedHit = postStim_hit-preStim_hit;
   evokedMiss = postStim_miss-preStim_miss;


   % sp now, start with pop distributions

   noStim   = find(amps == 0    & dPrime >= 1.0);
   highStim = find(amps >= 2000 & dPrime >= 1.0);

   preStim_noStim = squeeze(trapz(triggeredDF(:,preFr,noStim),2));
   postStim_noStim = squeeze(trapz(triggeredDF(:,postFr,noStim),2));

   evoked_noStim = postStim_noStim-preStim_noStim;

   preStim_highStim = squeeze(trapz(triggeredDF(:,preFr,highStim),2));
   postStim_highStim = squeeze(trapz(triggeredDF(:,postFr,highStim),2));

   evoked_highStim = postStim_highStim-preStim_highStim;

   %
   nCells = size(df,3);
   DP_Thr = [];
   SP_all = [];
   
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

   dataDP = DP_Thr;
   dataSP = SP_all;

   dataDPShuffMean = mean(poolShuffAUCDP);
   dataSPShuffMean = mean(poolShuffAUCSP);

   meanDP = dataDPShuffMean;

   dataDPShuffSTD = std(poolShuffAUCDP);
   dataSPShuffSTD = std(poolShuffAUCSP);

   critDP = 1.3 * dataDPShuffSTD;
   critSP = 1.3 * dataSPShuffSTD;

   missCellInd  = find(dataDP<(meanDP-critDP));
   nonPredictiveCellInd = find(dataDP<(meanDP+critDP) & dataDP>(meanDP-critDP));
   hitCellInd = find(dataDP>(meanDP+critDP));

   missCellVect  = dataDP<(meanDP-critDP);
   nonPredictiveCellVect = dataDP<(meanDP+critDP) & dataDP>(meanDP-critDP);
   hitCellVect = dataDP>(meanDP+critDP);

   missCellNum  = sum(dataDP<(meanDP-critDP));
   nonPredictiveCellNum = sum(dataDP<(meanDP+critDP) & dataDP>(meanDP-critDP));
   hitCellNum = sum(dataDP>(meanDP+critDP));

   flr.cellnfo.hit  = hitCellVect;
   flr.cellnfo.miss = missCellVect;
   flr.cellnfo.non  = nonPredictiveCellVect;

end