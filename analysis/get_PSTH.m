function [dF] = get_PSTH(deltaF, dFWindow, nStim, stimInds)

pre  = dFWindow(1);
post = dFWindow(2);

windowLen = post - pre + 1;
nCells = size(deltaF,2);

dF = zeros(nStim, windowLen, nCells);
% Get the event triggered average for fluorescence
for cellID = 1:nCells  
    for stimid = 2:nStim
       windowBeg = stimInds(stimid) + pre;
       windowEnd = stimInds(stimid) + post;
       window = windowBeg:windowEnd;
       
       dF(stimid, :, cellID) = deltaF(window, cellID);
    end
end

end