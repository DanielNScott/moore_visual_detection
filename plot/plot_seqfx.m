function [] = plot_seqfx(pAvgs)

nCells = size(pAvgs.pre,1);
nrows  = ceil(nCells/5);
for c = 1:nCells
   subplot(nrows,5,c)
   plot(pAvgs.post(c,1:(end-1)),pAvgs.pre(c,2:end),'o')
   grid on
end

end