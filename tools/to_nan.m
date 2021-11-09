function data = to_nan(data, el)
   data(data == el) = NaN;
end