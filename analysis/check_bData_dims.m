function [] = check_bData_dims(bData, nStim)

% bData.contrast has one extra the gets cut (at end, an artefact)
nStim1 = nStim;
nStim2 = length(bData.contrast)-1;
nStim3 = bData.completedTrials;
nStim4 = length(bData.responses);

% 
if not(all([nStim1, nStim2, nStim3] == nStim4))
   disp(['WARNING: Inconsistent trial nums: ' mat2str([nStim1, nStim2, nStim3, nStim4])])
end

end