function slevs = get_contrast_levels(contrast, levels)

%clevs.Zero    = clip(find(contrast ==   0), nStim);
%clevs.Low     = clip(find(contrast <   20 & contrast >   0), nStim);
%clevs.Mid     = clip(find(contrast >=  20 & contrast <  50), nStim);
%clevs.High    = clip(find(contrast >=  50 & contrast < 100), nStim);
%clevs.Hundred = clip(find(contrast == 100), nStim);

nStim  = length(contrast);

% Generate levels if empty matrix provided
if isempty(levels)
   levels = unique(contrast);
end

for i = 1:numel(levels)
   slevs{i} = clip(find(contrast == levels(i)), nStim);
end

end

function [field] = clip(field, nStims)

field = intersect(field, 1:nStims);

end