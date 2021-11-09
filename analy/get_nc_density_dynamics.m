function hist = get_nc_density_dynamics(rho)
% 

smRho = smooth_matrix_series(rho);

maxTime = size(smRho,3);

hist = [];
figure()
for t = 1:maxTime

   curHist = histogram(get_upper(smRho(:,:,t)), 'BinEdges', -1:0.05:1);
   hist(:,t) = curHist.Values;
   
   %grid on
   %imagesc(squeeze(smRho(:,:,t)) - eye(16))
   %title(['Time: ' num2str(t)])
   %drawnow()
   %pause(0.0001);
end
close

end