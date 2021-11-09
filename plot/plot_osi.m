function [] = plot_osi(sigMat)

out = bsxfun(@rdivide, sigMat, max(sigMat,[],2));
out = out';

osi = (max(out, [], 2) - min(out, [], 2)) ./ (max(out, [], 2) + min(out, [], 2));

figure
nhist(osi)
xlabel('Orientation Selectivity Index')
ylabel('Number of PV Cells')
xlim([0,1])
legend('All Cells', 'location', 'northwest')
title('Orientation Selectivity of V1 PV Cells')

end