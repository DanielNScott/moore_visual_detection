function [ stim_trials ] = get_stim_trials( type, orientation, contrast )
%GET_STIM_TRIALS Summary of this function goes here
%   Detailed explanation goes here

if strcmp(type, 'Orientation')
   stim_trials{1} = orientation == 90;
   stim_trials{2} = orientation == 0;
   stim_trials{3} = orientation == 270;
   
elseif strcmp(type, 'Contrast')
   stim_trials{1} = contrast <= 2 & contrast ~= 0;
   stim_trials{2} = or(contrast == 5, contrast == 10) ;
   stim_trials{3} = contrast > 10;
   
else
   error('Error: Stim. trial type not recognized.')
end

end

