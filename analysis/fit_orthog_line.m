
function [m,b] = fit_orthog_line(x,y)
   
   mu_x = mean(x);
   mu_y = mean(y);

   x_ctr = x - mu_x;
   y_ctr = y - mu_y;
   
   p = [x_ctr,y_ctr];
   n = length(p);
   [v,d] = eig(1/(n-1)*p'*p);
   [d,i] = sort(diag(d),'descend');
   v = v(:,i);
   
   m = v(2,1)./v(1,1);
   b = mu_y-mu_x*m;

end