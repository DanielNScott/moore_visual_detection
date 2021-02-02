function [corrs] = get_corrs(evoked, sig, stim_trials, nCells)

% Initialize structure
corrs = struct;

% Raw correlation between cells
corrs.raw = corr(evoked');

% Signal vector correlations;
corrs.sig = corr(sig);

%
% ncovs = {};
% for i = 1:3
%    ncovs{i} = cov(evoked(:,stim_trials{i})');
% end

% Noise correlations, their eigenvalues, and eigenvectors
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
ncs_avg = reshape(ncs_avg, nCells, nCells,3);
ncs_avg = mean(ncs_avg, 3);

% Package
corrs.ncs = ncs;
corrs.ncs_evals = evals;
corrs.ncs_evecs = evecs;
corrs.ncs_avg = ncs_avg;

end

