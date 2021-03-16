function [] = plot_all_ncdd(kapa)

figure()
subplot(4,2,1)
plot_nc_density_dynamics(kapa.miss)
title('Miss')

subplot(4,2,2)
plot_nc_density_dynamics(kapa.hit)
title('Hit')

subplot(4,2,3)
plot_nc_density_dynamics(kapa.low)
title('Low')

subplot(4,2,4)
plot_nc_density_dynamics(kapa.high)
title('High')

subplot(4,2,5)
plot_nc_density_dynamics(kapa.low_miss)
title('Low Miss')

subplot(4,2,6)
plot_nc_density_dynamics(kapa.high_hit)
title('High Hit')

subplot(4,2,7)
plot_nc_density_dynamics(kapa.low_hit)
title('Low Hit')

subplot(4,2,8)
plot_nc_density_dynamics(kapa.high_miss)
title('High Miss')
end