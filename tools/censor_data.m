function mus = censor_data(mus, varargin)

% Accept an alternative msk field as a censoring mask if given
if nargin == 1
   cfld = 'vld';
elseif nargin == 2
   cfld = varargin{1};
else
   error('Second argument should be a field name to use as a mask.')
end

% Critical fields
key_flds = {'hit', 'miss', 'fa', 'cr'};

% Loop over mice
for mnum = 1:numel(mus)
   
   % Number of days
   ndays = numel(mus{mnum}.bhv);
   
   % Remove any days with no imaging
   for dnum = 1:ndays
      
      % Whole day removal flag
      rm = 0;
      
      % Alias (or, since matlab, copy)
      % Inefficient, but easier to read, and not a big deal.
      bhv = mus{mnum}.bhv{dnum};
      PVs = mus{mnum}.PVs{dnum};
      ind = mus{mnum}.bhv{dnum}.nds.(cfld);

      % If an alternative mask is supplied, nans => zeros.
      msk = mus{mnum}.bhv{dnum}.msk.(cfld);
      msk = logical(msk == 1);
      
      % Sometimes the fluorescence data ends early
      lflr = size(PVs.dF,1);
      msk(lflr:end) = 0;
      ind = ind(ind < lflr);
            
      % Strip the derived psychometric quantities
      mus{mnum}.bhv{dnum} = rem_psychometric(bhv);
      bhv = mus{mnum}.bhv{dnum};
      
      % Censor remaining fields
      mus{mnum}.bhv{dnum} = censor_bhv(bhv, msk, ind, '');
      bhv = mus{mnum}.bhv{dnum};
      
      % Recompute psychometric quants
      mus{mnum}.bhv{dnum} = add_psychometric(bhv);
      
      % Censor fluorescence
      mus{mnum}.PVs{dnum} = censor_fluor(PVs, msk(1:lflr));
      
      % Critical fields we want stats on
      for fs = key_flds
         rm = or(nansum(mus{mnum}.bhv{dnum}.msk.(fs{1})) < 3, rm);
      end
      
      % Remove
      if rm
         mus{mnum}.bhv{dnum} = [];
      end
   end
end

% Remove any mice/days that were set as empty
mus = align_data(mus);

% Recompute valid stats
mus = add_stats_valid(mus);

end

function fluor = censor_fluor(fluor, valid_msk)

if ~isempty(fluor)
   % Should be programmatic but...
   
   fluor.dF  = fluor.dF(valid_msk, :, :);
%    fluor.zF  = fluor.zF(valid_msk, :, :);
%    
%    fluor.bsd = fluor.bsd(valid_msk, :);
%    
%    fluor.ev  = fluor.ev(valid_msk, :);
%    fluor.p1  = fluor.p1(valid_msk, :);
%    fluor.p2  = fluor.p2(valid_msk, :);
%    fluor.p3  = fluor.p3(valid_msk, :);
%    fluor.p4  = fluor.p4(valid_msk, :);
%    
%    fluor.p1sd  = fluor.p1sd(valid_msk, :);
%    fluor.p2sd  = fluor.p2sd(valid_msk, :);
%    fluor.p3sd  = fluor.p3sd(valid_msk, :);
%    fluor.p4sd  = fluor.p4sd(valid_msk, :);
   
   % ... sometimes this is fine.
end

end

function bhv = censor_bhv(bhv, msk, ind, type)

   % Number of trials
   ntrls = length(msk);

   if ~strcmp(type, 'cell')
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

         % For mask, index, and cell structures, recurse
         if strcmp(fs, 'msk')
            bhv.(fs) = censor_bhv(bhv.(fs), msk, ind, 'msk');
            continue

         elseif strcmp(fs, 'nds')
            bhv.(fs) = censor_bhv(bhv.(fs), msk, ind, 'nds');
            continue

         elseif iscell(bhv.(fs))
            bhv.(fs) = censor_bhv(bhv.(fs), msk, ind, 'cell');
            continue
         end

         % Otherwise, use whatever type this is
         if any(strcmp(type, {'msk', ''}))
            % Masks or vecs of scalars: apply mask
            if size(bhv.(fs), 2) > 1
               bhv.(fs) = bhv.(fs)(msk,:);
            else
               bhv.(fs) = bhv.(fs)(msk);
            end

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
   else
      % Cell was input, just go down list of elements and censor
      for i = 1:numel(bhv)
         bhv{i} = bhv{i}(msk);
      end
   end
end