function [] = plot_flr_evoked_grid(evoked, mid, date_str)

nCells = size(evoked,1);

figure()
for cellID = 1:nCells
   
   % Plot all the individual cells
   plot_flr_evoked(evoked, mid, date_str, cellID, [0,4,5,cellID])
   
   % Overwrite the fully detailed info
   legend('off')
   title(['Cell ', num2str(cellID)])
   if cellID <= 15;    xlabel(''); end
   if mod(cellID-1,5); ylabel(''); end
end

% Label figure
suptitle(['\bf{Mouse ', num2str(mid), ', ' date_str,'}'])

set(gcf,'Position', [78          15        1511         929])
end