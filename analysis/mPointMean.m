function out = mPointMean(data, np)


cut_msk = isnan(data);

cut = data(~cut_msk);

padded = [NaN(1,np), cut, NaN(1,np)];

% This should be a bunch of contiguous ones
has_data = ~isnan(padded);


ker = normpdf(-3:6/(np-1):3);
ker = ker./sum(ker);

for i = 1:(length(padded)-np)
   avg(i) = nansum(ker.*padded(i:(i+np-1)));
   
   div = ker*has_data(i:(i+np-1))';
   
   if div > 0
      avg(i) = avg(i)./div;
   else
      avg(i) = NaN;
   end
end
   
center = (np-1)/2 + 1;

avg = avg(center:(end-center));

out = NaN(1,length(data));
out(~cut_msk) = avg;

end