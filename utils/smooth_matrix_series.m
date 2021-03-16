function Msm = smooth_matrix_series(M)

ker = exp(-(0:0.01:3))./sum(exp(-(0:0.01:3)));

[nrows, ncols, ntimes] = size(M);

Msm = NaN(nrows,ncols,ntimes-length(ker)+1);
for i = 1:nrows
   for j = i:ncols
      Msm(i,j,:) = conv(squeeze(M(i,j,:)),ker,'valid');
   end
end



end