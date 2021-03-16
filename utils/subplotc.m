function [] = subplotc(r,c,i)

% Convert from column major to row major.
% Note this is high overhead relative to just calculating.

% Grid of indices:
inds = reshape(1:r*c, r, c)';

% Find is row-major
cind = find(inds == i);

% Create subplot
subplot(r,c, cind)

end
