

tstep = 1/1000;
psi = {};

i = 0;
for f = [10:13]
   i = i+1;
   
   bnd = ceil(4*5/(2*pi*f)/tstep)*tstep;
   x = (-bnd):tstep:bnd;
   
   psi{i} = exp(-(2*pi*f*x/5).^2/2).*cos(2*pi*f*x);
   psi{i} = psi{i}/sqrt((psi{i}*psi{i}'));
   
   ip(:,f) = conv(dF(3,:,3), psi{i}, 'same')';
   
   figure()
   plot(ip(:,f))
   
end

