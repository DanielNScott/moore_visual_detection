function [] = plot_baselining(dF, stim_trials, somaticF, deltaFDS)
% This was made with one particular dF and needs fixing / updating

figure();


for i = 1:3
   subplot(3,1,i)
   plot(mean(mean(dF(stim_trials{i},:,:)),3)');
   xlim([1,4000])
   
   title(['S', num2str(i),' PST Response'])
   grid on
   xlabel('Time [ms]')
   ylabel('dF/F')
end


subplot(2,1,1);
plot(somaticF(1,:)')
xlim([1,72000])

grid on
title('Somatic Flourescence')
ylabel('F')
xlabel('Frame')

subplot(2,1,2); 
plot(deltaFDS(1,:)')
xlim([1,72000])

title('Somatic Flourescence Baselined')
ylabel('F')
xlabel('Frame')
grid on

end