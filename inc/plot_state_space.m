% Full state space

[v, d, P, proj, dFm, dFmCov] = get_state_space(dFR, parsed.allMissTrials, 1:3000);

% Plotting
figure()

subplotc(2,3,1)
imagesc(dFmCov);
title('Neuron Covariance Matrix')

subplotc(2,3,2)
plot(P(1,:), 'o-'); hold on;
plot(P(2,:), 'o-');
grid on
legend({'PC1', 'PC2'})
title('Principal Components of Covariance')

subplotc(2,3,3)
plot(real(sqrt(d)), 'o-')
grid on
title('Variance Explained')
ylabel('\sigma []')
xlabel('Principal Component')


subplotc(2,3,4)
plot(proj(1,:)); hold on;
plot(proj(2,:))
grid on
title('PC Weights by Time')
xlabel('Time [ms]')
ylabel('PC Loading')

subplotc(2,3,5)
plot(dFm)
grid on
title('PSTH')
ylabel('Scaled dF/F')
xlabel('Time [ms]')


% 
% dFmCOMax = squeeze(mean(dFR(co.trials{3},:,:),1));
% dFmCOMin = squeeze(mean(dFR(co.trials{1},:,:),1));
% 
% 
% dFmCOMax = squeeze(mean(dFR(parsed.allHitTrials,:,:),1));
% dFmCOMin = squeeze(mean(dFR(parsed.allMissTrials,:,:),1));
% 
% proj2 = P*dFmCOMax';
% proj3 = P*dFmCOMin';
% 
% 
% subplotc(3,3,4)
% plot(proj(1,:) , proj(2,:)); hold on;
% plot(proj2(1,:), proj2(2,:))
% plot(proj3(1,:), proj3(2,:))
% grid on
% title('Trajectories in PC Space')
% legend({'Trial Grand Mean', 'Low Contrast', 'High Contrast'})
% xlabel('PC 1 Loading')
% ylabel('PC 2 Loading')
