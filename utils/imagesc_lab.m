function [] = imagesc_lab(M)

imagesc(M)
for i = 1:size(M,1)
   for j = 1:size(M,2)
      text(i - 0.1,j, ['\bf{' sprintf('%0.1f', M(i,j)) '}'])
   end
end
xticks([1:size(M,1)])
yticks([1:size(M,2)])

end