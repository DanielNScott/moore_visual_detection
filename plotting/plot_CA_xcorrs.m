function [] = plot_CA_xcorrs()
% Consider this broken right now...


figure()
for stim = 1:3
   ts = find(stim_trials{stim});
   ts = setdiff(ts,1);

   nTrials = length(ts);

   m = zeros(nCells, nCells, nTrials);
   l = zeros(nCells, nCells, nTrials);

   for k = 1:nTrials
      [r, maxrs, maxrlags] = avgxcorr(squeeze(dF(ts(k),1000:end,:)), 35,0);


      n = 1;
      for i = 1:nCells
         for j = i:nCells
            m(i,j,k) = maxrs(n);
            n = n+1;
         end
      end


      n = 1;
      for i = 1:nCells
         for j = i:nCells;
            l(i,j,k) = maxrlags(n);
            n = n+1;
         end
      end

   end

   mave(stim,:,:) = mean(m,3);
   msd(stim,:,:)  = std(m,[],3);
   lave(stim,:,:) = mean(l,3);
   
   %mave(find(eye(11))) = 0;
   
   hold on;
   plot(get_upper(squeeze(mave(stim,:,:))), get_upper(corrs.ncs{stim}), 'o','LineWidth', 2)
   grid on
   title('XCorr vs Evoked NC')
   ylabel('Noise Correlation')
   xlabel('Average CA^2^+ Cross-Correlation')
   
end
legend({'90','0','270'}, 'Location', 'SouthEast')


[~, ranks1] = sort(sum(abs(corrs.ncs{1})), 'descend');
[~, ranks2] = sort(sum(abs(corrs.ncs{2})), 'descend');
[~, ranks3] = sort(sum(abs(corrs.ncs{3})), 'descend');

figure()
hold on
plot(get_upper(squeeze(mave(1,:,:))), get_upper(corrs.ncs{1}), 'o', 'LineWidth', 2)
plot(get_upper(squeeze(mave(2,:,:))), get_upper(corrs.ncs{2}), 'o', 'LineWidth', 2)

for i = 1:11
   for j = (i+1):11
      
      x = [mave(1,i,j), mave(2,i,j)];
      y =  [corrs.ncs{1}(i,j), corrs.ncs{2}(i,j)];
      plot(x,y,'-k','LineWidth',0.5)
   end
end


figure()
hold on
plot(get_upper(squeeze(mave(1,:,:))), get_upper(corrs.ncs{1}), 'o', 'LineWidth', 2)
plot(get_upper(squeeze(mave(3,:,:))), get_upper(corrs.ncs{3}), 'o', 'LineWidth', 2)

for i = 1:11
   for j = (i+1):11
      
      x = [mave(1,i,j), mave(3,i,j)];
      y =  [corrs.ncs{1}(i,j), corrs.ncs{3}(i,j)];
      plot(x,y,'-k','LineWidth',0.5)
   end
end


figure()
hold on
plot(get_upper(squeeze(mave(2,:,:))), get_upper(corrs.ncs{2}), 'o', 'LineWidth', 2)
plot(get_upper(squeeze(mave(3,:,:))), get_upper(corrs.ncs{3}), 'o', 'LineWidth', 2)

for i = 1:11
   for j = (i+1):11
      
      x = [mave(2,i,j), mave(3,i,j)];
      y =  [corrs.ncs{2}(i,j), corrs.ncs{3}(i,j)];
      plot(x,y,'-k','LineWidth',0.5)
   end
end


figure()
hold on
plot(get_upper(squeeze(mave(1,:,:))), get_upper(squeeze(mave(2,:,:))), 'o', 'LineWidth', 2)
plot(get_upper(squeeze(mave(2,:,:))), get_upper(squeeze(mave(3,:,:))), 'o', 'LineWidth', 2)
grid on
title('Average Maximum Cross Correlation')
xlabel('Signal 1')
ylabel('Signal 2')
legend({'S1-S2', 'S2-S3'},'Location','NorthWest')
text(0.4,0.3, '\bf{R^2 = 0.98}')
