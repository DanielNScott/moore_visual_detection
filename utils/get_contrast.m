function cvec = get_contrast(msk1, msk2)
   
   % Treat nans as not in mask
   msk1(isnan(msk1)) = 0;
   msk2(isnan(msk2)) = 0;
   
   cvec = 1/sum(msk1)*msk1 - 1/sum(msk2)*msk2;
   
end