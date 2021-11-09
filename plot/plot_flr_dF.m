function [] = plot_flr_dF(dF, mid, dstr, cid, cvec, varargin)

% Default plot layout, modify if input
dvec = [-1,1,1,1];
pvec = get_plotvec(varargin, dvec);

window = [-1000, 3000];

time   = window(1):window(2);
ntrls  = size(dF,1);

% Use only this cell
dF = squeeze(dF(:,:,cid));

% Contrast vector processing
if isempty(cvec)
   
   % Baselined mean
   baseline = mean(mean(dF(:,1:900)));
   avg = mean( dF', 2) - baseline;

   % Standard deviation
   sd = std(dF, [], 1)';

   % Get jacknife resampled standard error
   js = jackknife(@mean, dF);
   se = sqrt(ntrls-1)*std(js, [], 1);
   
else
   num_ms = length(time);
   
   % Mean difference is weighted sum
   avg = cvec'*dF;
   
   % Here I'm calling pos. mask hits, neg mask misses
   % but these are actually arbitrary.
   %
   % Variance in the contrast is variance in contrast of deviations.
   
   % Positive, negative mask and weights
   cvp = max(cvec,0);
   cvn = min(cvec,0);
   pm = cvp > 0;
   nm = cvn < 0;
   
   % Convert all hit trials to devs. from mean for type
   dH = pm.*dF - pm*cvp'*dF;
   dM = nm.*dF - nm*cvn'*dF;
   
   dH = dH(pm,:);
   dM = dM(nm,:);
   
   % Generate a matrix of all dH - dM variables
   nht = sum(pm);
   nmt = sum(nm);
   dHdM = zeros(nht*nmt, num_ms);
   
   k = 1;
   for ht = 1:nht
      for mt = 1:nmt
         dHdM(k,:) = dH(ht,:) - dM(mt,:);
         k = k+1;
      end
   end
   
   % The std of this is std of (H - M).
   sd = std(dHdM);
   
   % Construct a jacknife sample
   cvp_inds = find(cvp > 0);
   cvn_inds = find(cvn < 0);
   jsample = zeros(nmt, num_ms);
   for mt = 1:nmt     
      tmp_p = pm;
      tmp_p(cvp_inds(mt)) = 0;
      tmp_p = logical(tmp_p);
      
      tmp_n = cvp;
      tmp_n(cvn_inds(mt)) = 0;
      tmp_n = logical(tmp_n);
      
      jsample(mt,:) = mean(dF(tmp_p,:)) - mean(dF(tmp_n,:));
   end
   
   % Get jacknife resampled standard error
   se = sqrt(nmt-1)*std(jsample, [], 1)';
end


% Plot things
subplotpv(pvec,1)
plot(time, avg, 'LineWidth', 2); hold on;
cord = get(gca,'ColorOrder');

plot(time, avg + sd   , '--', 'Color', cord(1,:));
plot(time, avg + 2*se', '-' , 'Color', cord(2,:));

plot([0   ,    0],[-2,2], '--k', 'LineWidth', 2)
plot([1000, 1000],[-2,2], '--' , 'LineWidth', 2, 'Color', cord(4,:))
plot([2000, 2000],[-2,2], '--' , 'LineWidth', 2, 'Color', cord(7,:))

% Plot these later so that legend can omit them
plot(time, avg - sd   , '--', 'Color', cord(1,:));
plot(time, avg - 2*se', '-' , 'Color', cord(2,:));

title(['Mouse ', num2str(mid), ', ', dstr, ', Cell ', num2str(cid)])
grid on
ylim([-2, 2])
xlim(window)

xlabel('Time [ms]')
ylabel('z-score dF/F')

legend({'Mean', 'SD', 'J. 2SEM', 'Stim', 'RD', 'Rew'})

end