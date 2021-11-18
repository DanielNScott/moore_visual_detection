function [] = plot_flr_dF_typed_grid(flr, mid, date_str, msks)

nCells = size(flr.dF,3);

figure()
for cellID = 1:nCells
   
   % Plot all the individual cells
   %plot_flr_dF(dF, mid, date_str, cellID, cvec, [0,4,5,cellID])
   %msks = {'hit', 'miss',};
   plot_flr_dF_typed(flr, msks, mid, date_str, cellID, [0,4,5,cellID])
   
   % Overwrite the fully detailed info
   if cellID > 1; legend('off'); end
   title(['Cell ', num2str(cellID)])
   if cellID <= 15;    xlabel(''); end
   if mod(cellID-1,5); ylabel(''); end
end

% Label figure
suptitle(['\bf{Mouse ', num2str(mid), ', ' date_str, '}'])

set(gcf,'Position', [78          15        1511         929])
end