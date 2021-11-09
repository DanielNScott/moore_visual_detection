function [] = plot_bhv(bhv)

plot_bhv_psych(bhv , [-1,2,2,1; 0,2,2,2])
plot_bhv_simple(bhv, [0,2,1,2])

set(gcf,'Position', [100   290   767   626])

end

