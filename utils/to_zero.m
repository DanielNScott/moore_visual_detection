function data = to_zero(data, el)

if isnan(el)
   data(isnan(data)) = 0;
else
   data(data == el) = 0;   
end

end