% Full state space

% Mean over trials 
dFm    = squeeze(mean(dF(2:55,1:1000,:),1));
dFmCov = (dFm-mean(dFm,2))'*(dFm-mean(dFm,2));
[v,d] = eig(dFmCov);

[d,inds] = sort(diag(d), 'descend');
v = v(:,inds);

P = v(:,1:2)';
proj = P*dFm';

dFmCOMax = squeeze(mean(dF(logical([ones(64,1); zeros(52,1)].*co.trials{3}),:,:),1));
dFmCOMin = squeeze(mean(dF(logical([ones(64,1); zeros(52,1)].*co.trials{1}),:,:),1));

proj2 = P*dFmCOMax';
proj3 = P*dFmCOMin';

% Plotting
figure()

subplotc(3,3,1)
imagesc(dFmCov);
title('Neuron Covariance Matrix')

subplotc(3,3,2)
plot(P(1,:), 'o-'); hold on;
plot(P(2,:), 'o-');
grid on
legend({'PC1', 'PC2'})
title('Principal Components of Covariance')

subplotc(3,3,3)
plot(real(sqrt(d)), 'o-')
grid on
title('Variance Explained [\sqrt(\sigma)]')
ylabel('\sigma []')
xlabel('Principal Component')

subplotc(3,3,4)
plot(proj(1,:) , proj(2,:)); hold on;
plot(proj2(1,:), proj2(2,:))
plot(proj3(1,:), proj3(2,:))
grid on
title('Trajectories in PC Space')
legend({'Trial Grand Mean', 'Low Contrast', 'High Contrast'})
xlabel('PC 1 Loading')
ylabel('PC 2 Loading')

subplotc(3,3,5)
plot(proj(1,:)); hold on;
plot(proj(2,:))
grid on
title('PC Weights by Time for Trial Grand Mean')
xlabel('Time [ms]')
ylabel('PC Loading')

subplotc(3,3,6)
plot(dFm)
grid on
title('PSTHs for Trial Grand Means')
ylabel('Scaled dF/F')
xlabel('Time [ms]')

