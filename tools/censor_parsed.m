function parsed = censor_parsed(parsed, msk, trials)

   fields = fieldnames(parsed);
   for fs = fields'
      fs = fs{:};
      
      field_len = numel(parsed.(fs));
      
      if field_len == length(msk)
         parsed.(fs) = parsed.(fs)(msk);
      else
         parsed.(fs) = intersect(parsed.(fs), trials);
      end
   end

end