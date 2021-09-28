function [] = get_pop_pred()

%figure()
%subplot(1,2,1)
%imagesc(squeeze(VStack(1,:,:)))

%subplot(1,2,2)
%imagesc(squeeze(UStack(:,1,:)))

hitFilt = [];
missFilt = [];
for i = 1:16
   figure()
   hitFilt(:,i)  = squeeze(mean(dF(parsed.allHitTrials,:,i),1));
   missFilt(:,i) = squeeze(mean(dF(parsed.allMissTrials,:,i),1));
   
   hitFiltUnit(:,i)  =  hitFilt(:,i)./norm( hitFilt(:,i));
   missFiltUnit(:,i) = missFilt(:,i)./norm(missFilt(:,i));
   
   %subplot(1,2,1)
   plot(hitFilt(:,i) ); hold on;
   plot(missFilt(:,i))
   %plot(squeeze(dF(parsed.allHitTrials,:,i))','LineWidth',0.5, 'Color', [0,0,0,0.1])
   
   %subplot(1,2,2)
   %plot(hitFiltUnit(:,i)); hold on;
   %plot(missFiltUnit(:,i))
end
close all

trial_preds = [];
ptDistHit = [];
ptDistMiss = [];
hitEvidence = [];
missEvidence = [];

hitMean  = squeeze(mean(dF(parsed.allHitTrials ,:,:),1));
missMean = squeeze(mean(dF(parsed.allMissTrials,:,:),1));
for i = 1:88

   %hitEvidence  = sum((hitFilt  - mean(hitFilt ,1)) .* thisTrial));
   %missEvidence = sum((missFilt - mean(missFilt,1)) .* thisTrial));

   %ptDistHit(:,i)  = sum( (squeeze(dF(i,:,:)) -  hitFilt).^2 )';
   %ptDistMiss(:,i) = sum( (squeeze(dF(i,:,:)) - missFilt).^2 )';
   
   %for j = 1:16
   %   hitEvidence(i,j)  = squeeze(dF(i,:,j))*hitFiltUnit(:,j);
   %   missEvidence(i,j) = squeeze(dF(i,:,j))*missFiltUnit(:,j);
   %end
   
   ptDistHit(i)  = sum(sum( (squeeze(dF(i,:,:)) - hitFilt ).^2 ));
   ptDistMiss(i) = sum(sum( (squeeze(dF(i,:,:)) - missFilt).^2 ));
   
   %hitDist(i)  = sum(sum((squeeze(dF(i,:,:)) - hitMean).^2));
   %missDist(i) = sum(sum((squeeze(dF(i,:,:)) - missMean).^2));
   %trial_preds(:,i) = ptDistHit' < ptDistMiss';
   
end
%hitEvidence  = hitEvidence;'
%missEvidence = missEvidence';
   
sel = ~isnan(trials);
%X = missDist'   - hitDist';
X = ptDistMiss' - ptDistHit';
X = zscore(X);

glm = fitglm(X(sel), trials(sel), 'Distribution', 'Binomial');

figure()
plot(pred,'o')
hold on
plot(parsed.allHitTrials ,16,'bx')
plot(parsed.allMissTrials, 0, 'bx')

trials = NaN(88,1);

end