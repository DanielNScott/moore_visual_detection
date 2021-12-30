function [vec] = log0(vec)
   vec(vec ~= 0) = log(vec(vec~=0));
end