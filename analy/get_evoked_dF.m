function flr = get_evoked_dF(flr, msks)

% Z-score baseline period.
% Apply the same mean shift and variance scaling to whole trial.
zF  = (flr.dF(:,:,:)  - mean(flr.dF(:,1:1000,:),2));
bsd = std(flr.dF(:,1:1000,:),[],2);
zF  = zF./bsd;

% Save
flr.zF  = zF;

% Baseline standard deviation
flr.bsd = squeeze(bsd);

%
ntrials = size(flr.dF,1);
ncells  = size(flr.dF,3);

cF = zeros(ntrials, 4, ncells);

% Avg. pre should be basically zero now, but we keep it for the case
% in which we turn off the baselining and inspect sequential effects.
cF(:,1,:) = squeeze(mean(zF(:,    1:1000, :),     2));
cF(:,2,:) = squeeze(mean(zF(:, 1001:2000, :),     2));
cF(:,3,:) = squeeze(mean(zF(:, 2001:3000, :),     2));
cF(:,4,:) = squeeze(mean(zF(:, 3001:4000, :),     2));

cFsd(:,1,:) = squeeze( std(zF(:,    1:1000, :), [], 2));
cFsd(:,2,:) = squeeze( std(zF(:, 1001:2000, :), [], 2));
cFsd(:,3,:) = squeeze( std(zF(:, 2001:3000, :), [], 2));
cFsd(:,4,:) = squeeze( std(zF(:, 3001:4000, :), [], 2));

mF(:,1,:) = squeeze(mean(zF(:,    1:1000,:),2));
mF(:,2,:) = squeeze(mean(zF(:, 1001:1500,:) - zF(:, 501:1000,:),2));
mF(:,3,:) = squeeze(mean(zF(:, 2001:2500,:) - zF(:,1501:2000,:),2));
mF(:,4,:) = squeeze(mean(zF(:, 3001:3500,:) - zF(:,2501:3000,:),2));

flds = fieldnames(msks);
for i = 1:numel(flds)
   fs = flds{i};
   
   msk = msks.(fs);
   
   flr.(fs) = msk_stats_cF(cF,msk);
   flr.(fs) = msk_stats_mF(cF,msk);
   flr.(fs) = msk_stats_zF(zF,msk, flr.(fs));
end

% Evoked response
flr.ev = squeeze(cF(:,2,:) - cF(:,1,:));

flr.cF    = cF;
flr.mF    = mF;
flr.cFsd  = cFsd;

end

function se = jse(avg)

   ntrls  = size(avg,1);

   js = jackknife(@mean, avg);
   se = sqrt(ntrls-1)*std(js, [], 1);
   
end

function flr = msk_stats_cF(cF, msk)

msk(isnan(msk)) = 0;
msk = logical(msk);

if sum(msk) >= 3
   flr.cFm(1, :) = squeeze( mean(cF(msk,1,:)) );
   flr.cFm(2, :) = squeeze( mean(cF(msk,2,:)) );
   flr.cFm(3, :) = squeeze( mean(cF(msk,3,:)) );
   flr.cFm(4, :) = squeeze( mean(cF(msk,4,:)) );

   flr.cFse(1, :) = jse( squeeze(cF(msk,1,:)) );
   flr.cFse(2, :) = jse( squeeze(cF(msk,2,:)) );
   flr.cFse(3, :) = jse( squeeze(cF(msk,3,:)) );
   flr.cFse(4, :) = jse( squeeze(cF(msk,4,:)) );
else
   flr = struct();
end

end


function flr = msk_stats_mF(mF, msk)

msk(isnan(msk)) = 0;
msk = logical(msk);

if sum(msk) >= 3
   flr.mFm(1, :) = squeeze( mean(mF(msk,1,:)) );
   flr.mFm(2, :) = squeeze( mean(mF(msk,2,:)) );
   flr.mFm(3, :) = squeeze( mean(mF(msk,3,:)) );
   flr.mFm(4, :) = squeeze( mean(mF(msk,4,:)) );

   flr.mFse(1, :) = jse( squeeze(mF(msk,1,:)) );
   flr.mFse(2, :) = jse( squeeze(mF(msk,2,:)) );
   flr.mFse(3, :) = jse( squeeze(mF(msk,3,:)) );
   flr.mFse(4, :) = jse( squeeze(mF(msk,4,:)) );
else
   flr = struct();
end

end



function flr = msk_stats_zF(zF,msk, flr)

msk(isnan(msk)) = 0;
msk = logical(msk);

if sum(msk) >= 3
   flr.zFm  = squeeze( mean(zF(msk,:,:),1) );
   flr.zFsd = squeeze(  std(zF(msk,:,:), [], 1) );
   
   %flr.zFse = jse(  squeeze(zF(msk,:,:)) );
else
   flr = struct();
end

end