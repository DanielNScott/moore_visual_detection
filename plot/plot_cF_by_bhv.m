function lm = plot_cF_by_bhv(flr, bhv, mstr)

lm = cell(3,1);
plt = 0;

epochs = {'Stim', 'Wait', 'Out'};
%regs   = {'Lick', 'Stim', 'Velocity', 'Rew', 'pLFP'};
regs   = {'Lick', 'Stim', 'Vel.', 'Hit'};

nregs = numel(regs);

k = 1;
ncells = size(flr.dF,3);

%for i = 1:ncells
%   regs{i} = ['Cell ' num2str(i)];
%end

msk = bhv.msk.(mstr);
% figure()
% fnum1 = get(gcf,'Number');

figure()
fnum2 = get(gcf,'Number');
% 
% figure()
% fnum3 = get(gcf,'Number');
for ep = 1:3
   
   warning off
   lm{ep} = pred_cF_by_bhv(flr, bhv, ep+1, ep+1, msk);
   warning on
   
%    for reg = 1:nregs
%       plt = plt + 1;
%       
%       figure(fnum1)
%       subplot(3,nregs, plt);
%       
%       histogram(lm{ep}.pval(reg,:), 'BinEdges', 0:0.05:1)
%       ylabel('Cell Count')
%       xlabel('P-Value')
%       title([epochs{ep}, ' by ', regs{reg}])
%    end
   
   % Figure for all the coefficients in this epoch
   figure(fnum2)
   for reg = 1:nregs
      subplot(3, nregs, k)
      
      pmsk = lm{ep}.pval(reg,:) < 0.05;
      pind = find( pmsk);
      nind = find(~pmsk);
      
      errorbar( pind, lm{ep}.model(reg, pind), 2*lm{ep}.SEs(reg, pind),'o'); hold on;
      errorbar( nind, lm{ep}.model(reg, nind), 2*lm{ep}.SEs(reg, nind),'o','Color',[0.6, 0.6, 0.6]);
      xlim([0, length(pmsk)+1])
      plot([0, length(pmsk)+1], [0,0], '--k')
      ylim([-1, 1])
      
      grid on
      title([epochs{ep}, ' Ep. ', regs{reg} ,' Enc.'])
      xlabel('Cell Number')
      ylabel('Coeff.')
      
      k = k+1;
   end
   
%    figure(fnum3)
%    subplotc(3,2,ep)
%    imagesc_lab(lm{1}.rho)
%    colorbar()
%    title('Design Matrix Correlations')
%    
%    subplot(3,2, 2*ep)
%    plot(lm{ep}.rsqr, '-o', 'LineWidth', 2)
%    xlabel('Cell ID')
%    ylabel('R^2')
%    ylim([0,1])
%    xlim([0,ncells+1])
%    grid on
%    title('Variance Explained')

   %suptitle(['Regression Coefficients, Epoch ', num2str(ep)])
end
set(gcf,'Position', [100          50        1408         914])

end
   