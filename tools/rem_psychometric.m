function bhv = rem_psychometric(bhv)

bhv = rmfield(bhv, 'psych_phit');
bhv = rmfield(bhv, 'psych_smps');
bhv = rmfield(bhv, 'psych_levs');

end