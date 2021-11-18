function [] = plot_flr_rpbm(flr, msk_strs, corder, cid)
% Plot fluorescence response period by mask

%ngrps  = numel(unique(groups));
nitems = numel(msk_strs);
nslots = nitems + 1;

ctrs   = (0:3)*nslots;
offs   = ((1:nitems)-1)*0.5 - (nslots/2/2 - 0.5);% + (groups(1:nitems)-1)*1;

l = 1;
for k = 1:nitems
   fs = msk_strs{k};

   %plot(mean(cen{1}.PVs{2}.cF(msk,:,cid)), '-o'); hold on;
   x   = ctrs + offs(l);
   y   =   flr.(fs).cFm(:,cid);
   err = 2*flr.(fs).cFse(:,cid);
   
   errorbar(x, y, err, 'o', 'Color', corder(l,:), 'LineWidth', 2); hold on;
   l = l + 1;
end
ylim([-2,2])
xticks(ctrs)
xticklabels({'BL', 'Resp.', 'Wait', 'Rew.'})

xlabel('Trial Period')
ylabel('Avg. dF/F')

grid on
legend(msk_strs, 'Location','NorthWest', 'Interpreter', 'None')

end