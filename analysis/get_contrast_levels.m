function [clevs] = get_contrast_levels(contrast, nStim)

clevs.Zero = clip(find(contrast == 0), nStim);
clevs.Low = clip(find(contrast < 20 & contrast >0), nStim);
clevs.Mid = clip(find(contrast>=20 & contrast <50), nStim);
clevs.High = clip(find(contrast>=50 & contrast <100), nStim);
clevs.Hundred = clip(find(contrast == 100), nStim);

end

function [field] = clip(field, nStims)

field = intersect(field, 1:nStims);

end