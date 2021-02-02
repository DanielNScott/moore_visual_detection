function [clevs] = get_contrast_levels(contrast)

clevs.Zero = find(contrast == 0);
clevs.Low = find(contrast < 20 & contrast >0);
clevs.Mid = find(contrast>=20 & contrast <50);
clevs.High = find(contrast>=50 & contrast <100);
clevs.Hundred = find(contrast == 100);

end