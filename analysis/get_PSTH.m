function [dF] = get_PSTH(deltaF, dFWindow, nStim, stimInds, offsets)

% This is a list of offsets to the stimulus time centering. 
if isempty(offsets)
   offsets = zeros(nStim,1);
end

% Pre event and post event time durations
pre  = dFWindow(1);
post = dFWindow(2);

windowLen = post - pre + 1;
nCells = size(deltaF,2);

dF = zeros(nStim, windowLen, nCells);
% Get the event triggered average for fluorescence
for cellID = 1:nCells
    for stimid = 2:nStim
       
       % For e.g. lick latencies, some trials are NaNs
       if isnan(offsets(stimid))
          
          % Fill row with nans. Should be the same as adding a NaN, but this is explicit.
          dF(stimid, :, cellID) = NaN;          
       else
          
          % Generic PSTH windowing, shifted by offset
          windowBeg = stimInds(stimid) + offsets(stimid) + pre;
          windowEnd = stimInds(stimid) + offsets(stimid) + post;
          window = windowBeg:windowEnd;

          dF(stimid, :, cellID) = deltaF(window, cellID);
       end
    end
end

end