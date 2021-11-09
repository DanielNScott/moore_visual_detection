function pvec = get_plotvec(in, def)
% A varargin interpreter for plot arrangement

nin = length(in);

if nin == 0
   pvec = def;
   
elseif nin == 1
   pvec = in{1};
   
elseif nin > 2
   error('')
end

end