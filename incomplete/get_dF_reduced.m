function [dFR, coefs, basis, svals] = get_dF_reduced(dF, ndims, trials, window)

[d1,d2,d3] = size(dF(:,window,:));

dFR   = zeros([d1, d2, d3]);

coefs = zeros([d1, ndims, d3]);
basis = zeros([d2, ndims, d3]);
svals = zeros([d1,    d3    ]);

flp_pt = floor(length(window)/2);

for i = 1:size(dF,3)
   
   [U,S,V] = svd(squeeze(dF(trials,window,i)));

   dFR(:,:,i) = U(:,1:ndims)*S(1:ndims,:)*V';

   % Flip 
   if V(flp_pt,1) < 0
      V(:,1) = -V(:,1);
      U(:,1) = -U(:,1);
   end
   
   if V(flp_pt,2) < 0
      V(:,2) = -V(:,2);
      U(:,2) = -U(:,2);
   end
   
   coefs(:,:,i) = U(:, 1:ndims);
   basis(:,:,i) = V(:, 1:ndims);
   svals(:,i) = diag(S(1:d1, 1:d1));

end

end