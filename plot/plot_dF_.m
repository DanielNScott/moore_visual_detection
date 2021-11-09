function [] = plot_dF_(data, id, day, cellnum, window)

dF   = squeeze(data.mouse{id}.cluor{day}.dFzc(:,:,cellnum));
time = window(1):window(2);

% Should be replaced w/ nTrials calculation
trls_hit = data.mouse{id}.cehav{day}.response_hits;
trls_hit(isnan(trls_hit)) = 0;

trls_miss = data.mouse{id}.cehav{day}.response_miss;
trls_miss(isnan(trls_miss)) = 0; % these masks should be computed in parse_data

trls_fa = data.mouse{id}.cehav{day}.response_fa;
trls_fa(isnan(trls_fa)) = 0;

trls_cr = data.mouse{id}.cehav{day}.response_cr;
trls_cr(isnan(trls_cr)) = 0;

figure()

act      = baseline_cell(dF, trls_hit + trls_miss + trls_cr + trls_fa);
act_hit  = baseline_cell(dF, trls_hit);
act_miss = baseline_cell(dF, trls_miss);
act_fa   = baseline_cell(dF, trls_fa);
act_cr   = baseline_cell(dF, trls_cr);

se_hit = jkse(dF, trls_hit);

subplot(2,1,1)
plot(time, act_hit); hold on
plot(time, act_miss)
grid on

subplot(2,1,2)
plot(time, act_fa); hold on;
plot(time, act_cr)

title(['Cell', num2str(cellID)])
grid on
%ylim([-0.05, 0.1])
xlim(window)

end

function act = baseline_cell(dF, sel)

  if isempty(sel)
     sel = logical(ones(size(dF,1),1));
  else
     sel = logical(sel);
  end
  
  bl  = mean(mean(dF(sel, 1:900)));
  act = mean( dF(sel, :)', 2) - bl;
  
end

function se = jkse(dF, sel)

   npts = size(dF,2);
   nres = nansum(sel);
   
   act = NaN(npts, nres);
   k = 1;
   for i = find(sel)
      smp    = sel;
      smp(i) = 0;
      
      act(:,k) = baseline_cell(dF, smp);
      k = k+1;
   end
   
   se = sqrt((nres-1)*var(act,[],2));
   
end