function [] = plot_slopes_and_intercepts(data)
% The data input to this function is from e.g. FULLDATASET_PV.mat

session_inds = {};
session_inds{1} = 1;
session = 1;
for i = 2:size(data.orientation,1)
    if data.orientation(i-1,:) == data.orientation(i,:)
      session_inds{session} = [session_inds{session}, i];
   else
      session = session + 1;
      session_inds{session} = [i];
   end
end


close all

slopes = {};
intercepts = {};

badlist = [1, 16, 17];

sblist = [1,  7, 15];
sflist = [6, 14, 24];

for j = 1:3

   mlist = [];
   blist = [];

   sb = sblist(j);
   sf = sflist(j);
   
   nsess = sf-sb+1;

   for i = sb:sf
      
      if any(i == badlist)
         
         mlist = [mlist, NaN];
         blist = [blist, NaN];
      else
         row = session_inds{i}(1);

         % Find number of stims presented
         nanInd = find(isnan(data.evokedTrials(row,:)),1);
         if isempty(nanInd)
            nStim = 100;
         else
            nStim = nanInd-1;
         end

         % Number of cells in session
         nCells = size(session_inds{i},2);

         % Indices for particular stimuli
         stim_trials = get_stim_trials('Orientation', data.orientation(row,1:nStim), data.stimAmp(row,1:nStim));

         % Extract evoked data flourescence
         evoked = data.evokedTrials(session_inds{i},:);

         [sig, sig_normed] =  get_signal_vecs(evoked, stim_trials, nCells);

         % Get correlations
         corrs = get_corrs(evoked, sig, stim_trials, nCells);

         % Plot them
         %plot_sig_vs_noise(corrs.sig, corrs.ncs, corrs.ncs_avg, 0)
         %suptitle(['\bf{Session ' num2str(i) '}'])

         % Record m and b
         sigvec = get_upper(corrs.sig);
         ncsvec = get_upper(corrs.ncs_avg);

         [m, b] = fit_orthog_line(sigvec,ncsvec);

         mlist = [mlist,m];
         blist = [blist,b];

      %    colors = jet(nCells);
      %    figure()
      %    for j = 1:nCells
      %       plot(sig(:,j),'-o','Color',colors(j,:)); hold on;
      %    end
      %    plot(mean(sig,2),'-o')
      %    grid on
      %    title(['Session ' num2str(i) 'Sigs'])

      end
   end
   
   slopes{j}     = mlist;
   intercepts{j} = blist;
end
% 
% avg_slope = zeros(1,10);
% avg_int   = zeros(1,10);
% for j = 1:3
%    for k = 1:length(slopes{j})
%       avg_int(k)   = nansum([slopes{j}(k),   avg_int(k)]);
%       avg_slope(k) = nansum([slopes{j}(k), avg_slope(k)]);
%    end
% end


figure()
subplot(1,2,1)
plot(slopes{1}, '-o', 'LineWidth', 2); hold on
plot(slopes{2}, '-o', 'LineWidth', 2)
plot(slopes{3}, '-o', 'LineWidth', 2)

title('Slope of Noise = m*Signal + b')
xlabel('Session Number')
ylabel('Slope (m)')
grid on

subplot(1,2,2)
plot(intercepts{1}, '-o', 'LineWidth', 2); hold on
plot(intercepts{2}, '-o', 'LineWidth', 2)
plot(intercepts{3}, '-o', 'LineWidth', 2)

title('Intercept of Noise = m*Signal + b')
xlabel('Session Number')
ylabel('Intercept (b)')
grid on

end

