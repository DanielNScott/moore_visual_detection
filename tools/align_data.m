function mus = align_data(mus)

% Fields to align: Add other by-day fields here.
flds = {'bhv', 'PVs', 'nfo'};

% Loop over mice
for mnum = 1:length(mus)
      
   % Loop over days
   dind = 1;
   days = 1:length(mus{mnum}.bhv);
   for dnum = days
      
      % Check if any fields are empty at this index
      empty = 0;
      for fld = flds
         fs = fld{1};
         empty = empty || isempty(mus{mnum}.(fs){dind});
      end
      
      % If any are empty, subset all of them
      if empty
         keep = setdiff(days,dind);
         
         for fld = flds
            fs = fld{1};
            mus{mnum}.(fs) = mus{mnum}.(fs)(keep);
         end
         
         % Throw out the file associated with this day
         mus{1}.mta.files = mus{1}.mta.files(keep);
         
         % We just got rid of a day, so we need ot decrement dind
         dind = dind - 1;
      end
      
      % Track dnum, except when removals happen
      dind = dind + 1;
   end
end


end