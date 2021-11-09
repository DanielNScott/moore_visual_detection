figure()

subplot(1,3,1)
plot(DP_Thr, DP_Thr_c, 'o')
fmt()
title('DP')

subplot(1,3,2)
plot(SP_all, SP_all_c, 'o')
fmt()
title('SP')

subplot(1,3,3)
plot(SP_all_c, SP_all  , 'o'); hold on
plot(SP_all_c, DP_Thr_c, 'o')

xlim([0,1])
ylim([0,1])
grid on
hold on
plot([0,1], [0,1], '-k')
title('Both')

xlabel('SP_all_c')
ylabel('SP_all')
yyaxis right
ylabel('DP_Thr_c')

set(gcf,'Position', [100         592        1466         352])


figure()

subplot(1,2,1)
plot(sort(DP_Thr_c - SP_all_c), 'o')
%hold on; plot(SP_all_c, 'o')
%grid on

subplot(1,2,2)
plot(DP_Thr_c, SP_all_c, 'o')
grid on
%xlabel

function [] = fmt()
   xlim([0,1])
   ylim([0,1])
   grid on
   hold on
   plot([0,1], [0,1], '-k')
   
   xlabel('all')
   ylabel('valid')
end