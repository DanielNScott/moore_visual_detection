function mus = censor_data(mus, varargin)

% Accept an alternative msk field as a censoring mask if given
if nargin ==1
   cfld = 'vld';
elseif nargin == 2
   cfld = varargin{1};
else
   error('Second argument should be a field name to use as a mask.')
end
   

% Loop over mice
for mnum = 1:numel(mus)
   
   % Number of days
   ndays = numel(mus{mnum}.bhv);
   
   % Remove any days with no imaging
   for dnum = 1:ndays
      
      % Alias (or, since matlab, copy)
      % Inefficient, but easier to read, and not a big deal.
      bhv = mus{mnum}.bhv{dnum};
      PVs = mus{mnum}.PVs{dnum};
      ind = mus{mnum}.bhv{dnum}.nds.(cfld);

      % If an alternative mask is supplied, nans => zeros.
      msk = mus{mnum}.bhv{dnum}.msk.(cfld);
      msk = logical(msk == 1);
            
      % Strip the derived psychometric quantities
      mus{mnum}.bhv{dnum} = rem_psychometric(bhv);
      bhv = mus{mnum}.bhv{dnum};
      
      % Censor remaining fields
      mus{mnum}.bhv{dnum} = censor_bhv(bhv, msk, ind, '');
      bhv = mus{mnum}.bhv{dnum};
      
      % Recompute psychometric quants
      mus{mnum}.bhv{dnum} = add_psychometric(bhv);
      
      % Censor fluorescence
      mus{mnum}.PVs{dnum} = censor_fluor(PVs, msk);
      
   end

end

% Recompute valid stats
mus = add_stats_valid(mus);

end

function fluor = censor_fluor(fluor, valid_msk)

if ~isempty(fluor)
   fluor.dF  = fluor.dF(valid_msk, :, :);
   fluor.zF  = fluor.zF(valid_msk, :, :);
   fluor.ev  = fluor.ev(:, valid_msk);
end

end

function bhv = censor_bhv(bhv, msk, ind, type)

   % Number of trials
   ntrls = length(msk);

   % List all the field names
   fields = fieldnames(bhv);
   
   % Iterate over them
   for fs = fields'
      fs = fs{:};
      
      % Fields w/ special processing
      if strcmp(fs, 'n_trials')
         bhv.(fs) = length(bhv.amp);
      end

      % How long is this field?
      field_len = numel(bhv.(fs));
      
      % If this is a scalar, ignore it
      if field_len == 1 && ~isstruct(bhv.(fs))
         continue
      end
      
      % For mask and index structures, recurse
      if strcmp(fs, 'msk')
         bhv.(fs) = censor_bhv(bhv.(fs), msk, ind, 'msk');
         continue
         
      elseif strcmp(fs, 'nds')
         bhv.(fs) = censor_bhv(bhv.(fs), msk, ind, 'nds');
         continue
      end
      
      % Otherwise, use whatever type this is
      if any(strcmp(type, {'msk', ''}))
         % Masks or vecs of scalars: apply mask 
         bhv.(fs) = bhv.(fs)(msk);
      
      elseif strcmp(type, 'nds')
         % Indices: we need to recompute
         
         % Generate a new mask
         new = zeros(ntrls,1);
         
         % Find inds shared by field and valid, set them to 1
         set = intersect(bhv.(fs), ind);
         new(set) = 1;
         
         % Convert back to indices in valid chunk
         bhv.(fs) = find(new(msk));
      end
   end
end