function data = to_nan(data, el)
   data = real(data);
   data(data == el) = NaN;
end