function [] = plot_dF(dF)

nCells = size(dF,3);
figure()
for cellID = 1:nCells
  subplot (3,4,cellID)
  %plot([-1*pre:post],(dF(:,:,cellID)'))
  plot([-1*pre:post], mean((dF(:,:,cellID)'),2) - mean(mean(dF(:,1:900,cellID))))
  title(['Cell', num2str(cellID)])
  ylim([-0.05, 0.1])
  xlim([-1000, 3000])
end
end