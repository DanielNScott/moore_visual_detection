
%%
% Align sample frequencies

frameSamples = (frameDelta:frameDelta:frameDelta*size(somaticF,2))*1000;
imTime  = ((frameSamples)/1000);
hertz = 1/frameDelta*1000;

% baseline data with df/f

blCutOffs = computeQuantileCutoffs(somaticF);
somaticF_BLs=slidingBaseline(somaticF,500,blCutOffs);
deltaFDS = (somaticF - somaticF_BLs)./somaticF_BLs;


% upsample data
tseries = timeseries(deltaFDS',imTime);
tseries_rs = resample(tseries,bData.sessionTime);
deltaF = tseries_rs.Data;

% parse the behavior for Hits, Misses, FAs, and CRs 

% find the timing in ms of each reward and lick
[rewardOnSamps, rewardOnVect] = getStateSamps(bData.teensyStates,4,1);
[licks, licksVect] = getStateSamps(bData.thresholdedLicks, 1, 1);

% Considering whisker stimulation

[stimOnSamps,stimOnVect]=getStateSamps(bData.teensyStates,2,1);
[catchOnSamps,catchOnVect]=getStateSamps(bData.teensyStates,3,1);
stimSamps = [stimOnSamps, catchOnSamps];
stimSamps = sort(stimSamps);
whiskerSample = stimSamps; 
[rewardOnSamps, rewardOnVect] = getStateSamps(bData.teensyStates,4,1);
[licks, licksVect] = getStateSamps(bData.thresholdedLicks, 1, 1);
lickWindow = 1500;

% loop over the first one hundred trials and extract hit/miss information
    for n = 2:100
        % for touch
        %parsed.amplitude(n)=bData.c1_amp(n);
        % for vision
        parsed.amplitude(n)=bData.contrast(n);
        tempLick = find(bData.thresholdedLicks(stimSamps(n):stimSamps(n)+lickWindow)==1);
        tempRun = find(bData.binaryVelocity(stimSamps(n):stimSamps(n)+ lickWindow) == 1);

        % check to see if the animal licked in the window
        if numel(tempLick)>0
            % it licked
            parsed.lick(n) = 1;
            parsed.lickLatency(n) = tempLick(1) - stimSamps(n);
            parsed.lickCount(n) = numel(tempLick);
            if parsed.amplitude(n)>0
                parsed.response_hits(n) = 1;
                parsed.response_miss(n) = 0;
                parsed.response_fa(n) = NaN;
                parsed.response_cr(n) = NaN;
            elseif parsed.amplitude(n) == 0
                parsed.response_fa(n) = 1;
                parsed.response_cr(n) = 0;
                parsed.response_hits(n) = NaN;
                parsed.response_miss(n) = NaN;
            end
        elseif numel(tempLick)==0
            parsed.lick(n) = 0;
            parsed.lickLatency(n) = NaN;
            parsed.lickCount(n) = 0;
            if parsed.amplitude(n)>0
                parsed.response_hits(n) = 0;
                parsed.response_miss(n) = 1;
                parsed.response_fa(n) = NaN;
                parsed.response_cr(n) = NaN;
            elseif parsed.amplitude(n) == 0
                parsed.response_fa(n) = 0;
                parsed.response_cr(n) = 1;
                parsed.response_hits(n) = NaN;
                parsed.response_miss(n) = NaN;
            end
        end
        
        % extract whether or not the mouse ran during the report window
        if numel(tempRun) > 0
            parsed.run(n) = 1;
            tempVel = bData.velocity(stimSamps(n):stimSamps(n)+ lickWindow);
            parsed.vel(n) = nanmean(abs(tempVel));
        else
            parsed.run(n) = 0;
            parsed.vel(n) = 0;
        end
        
        parsed.depth(n) = depth;
    end
    
parsed.contrast = parsed.amplitude;


% pre/post are ms before/after stimulus onset
pre = 1000;
post = 3000;


zStackCellMat=[];

% Get the event triggered average for fluorescence
for cellID = 1:size(somaticF,1)
    cell = deltaF(:,cellID); % this is the cell you want
  
    for stimid = 2:100
        whiskfluormat(stimid,:) = cell(whiskerSample(stimid) - pre: whiskerSample(stimid)+ post);
    end
    zStackCellMat(:,:,cellID) = whiskfluormat;
end


% Make subplots for each cell
    figure
    for cellID = 1:size(somaticF, 1)
        subplot (3,4,cellID)
        %plot([-1*pre:post],(zstackcellmat(:,:,cellID)'))
        plot([-1*pre:post], mean((zStackCellMat(:,:,cellID)'),2)-mean(mean(zStackCellMat(:,1:900,cellID))))
        title(['Cell', num2str(cellID)])
        ylim([-0.05,0.1])
        xlim([-1000,3000])
    end

%%



% capture evoked scores for every trial of every cell
zStackCellMatBaselined = (zStackCellMat(:,:,:)  -mean(zStackCellMat(:,1:900,:),2));

preScore = zStackCellMatBaselined(:,1:1000,:);
postScore = zStackCellMatBaselined(:,1000:2000,:);

preScore2 = trapz(preScore,2);
preScore2 = squeeze(preScore2);

postScore2 = trapz(postScore,2);
postScore2 = squeeze(postScore2);

evoked = (postScore2-preScore2)';


% calculate correlation between cells
corrMatrix = corr(evoked');

% convenience downsample for now to 100
orientation = bData.orientation;
orientation = orientation(1:100);

contrast = bData.contrast;
contrast = contrast(1:100);

stim_trials{1} = orientation == 90;
stim_trials{2} = orientation == 0;
stim_trials{3} = orientation == 270;

sig = {};
sig{1} = mean(evoked(:,stim_trials{1}),2);
sig{2} = mean(evoked(:,stim_trials{2}),2);
sig{3} = mean(evoked(:,stim_trials{3}),2);

sig = [sig{1}' ; sig{2}' ; sig{3}' ];

sigcorr = corr(sig);

sig_normed = sig;
for i = 1:11
   sig_normed(:,i) = sig(:,i)./norm(sig(:,i));
end

%
ncovs = {};
for i = 1:3
   ncovs{i} = cov(evoked(:,stim_trials{i})');

end

% 
ncs = {};
evecs = {};
evals = {};
for i = 1:3
   ncs{i} = corr(evoked(:,stim_trials{i})');
   
   [v,d] = eig(ncs{i});
   [d,j] = sort(diag(d), 'descend');
   v = v(:,j);
   
   evecs{i} = v;
   evals{i} = d;
end

ncs_avg = cell2mat(ncs);
ncs_avg = reshape(ncs_avg, 11,11,3);
ncs_avg = mean(ncs_avg, 3);

% Define rank orderings of total correlation in each case
[~, ranks1] = sort(sum(abs(ncs{1})), 'descend');
[~, ranks2] = sort(sum(abs(ncs{2})), 'descend');
[~, ranks3] = sort(sum(abs(ncs{3})), 'descend');
