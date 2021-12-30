function [vecs, vals] = plot_var_evecs_by_epoch(flr, bhv)

rho = [];
flip = [2,2,2; 3,2,2; 2,1,1; 2,1,2; 3,1,1; 3,1,2];
for ep = 1:3

   msk1 = bhv.msk.hit;
   sig1 = cov(squeeze(flr.cF(msk1,ep+1,:)));
   [v,d] = eig(sig1);
   d = diag(d);
   [d, nds] = sort(d,'descend');
   v = v(:,nds);
   vecs{1,ep} = v(:,1:3);
   vals{1,ep} = d;

   msk2 = bhv.msk.miss;
   sig2 = cov(squeeze(flr.cF(msk2,ep+1,:)));
   [v,d] = eig(sig2);
   d = diag(d);
   [d, nds] = sort(d,'descend');
   v = v(:,nds);
   vecs{2,ep} = v(:,1:3);
   vals{2,ep} = d;

%    for i = 1:5
%       rho(i,ep) = v1(:,i)'*v2(:,i);
%       if any(all([i,ep] == flip(:,1:2),2))
%          
%          v2(:,i)   = -v2(:,i);
%          rho(i,ep) = -rho(i,ep);
%       end
%    end



end

figure()
A = [vecs{1,1}, vecs{1,2}, vecs{1,3}];
B = [vecs{2,1}, vecs{2,2}, vecs{2,3}];

C = A'*A;

for i = 1:3
   ind = 3 + find(abs(C(i,4:6)) == max(abs(C(i,4:6))));
   if C(i,ind) < 0 
      A(:,i) = -A(:,i);
   end
end

D = A'*B;

for i = 1:3
   ind = find(abs(D(i,1:3)) == max(abs(D(i,1:3))));
   if D(i,ind) < 0 
      B(:,i) = -B(:,i);
   end
end

for i = 1:3
   ind = 3 + find(abs(D(i,4:6)) == max(abs(D(i,4:6))));
   if D(i,ind) < 0 
      B(:,ind) = -B(:,ind);
   end
end

for i = 1:3
   ind = 6 + find(abs(D(i,7:9)) == max(abs(D(i,7:9))));
   if D(i,ind) < 0 
      B(:,ind) = -B(:,ind);
   end
end

% E = B'*B;
% 
% for i = 1:3
%    ind = 3 + find(abs(E(i,4:6)) == max(abs(E(i,4:6))));
%    if E(i,ind) < 0 
%       B(:,i) = -B(:,i);
%    end
% end

F = [A,B];
F = F'*F;

for i = 1:length(F)
   for j = 1:length(F)
      if i > j
         F(i,j) = NaN;
      end
   end
end

imagesc(F);
hold on

% Add vertical guides
breaks = 0.5:3:18.5;
for i = 1:numel(breaks)
   plot([breaks(i), breaks(i)], [0.5, breaks(i)], '-k', 'LineWidth', 2)
end

% Add horizontal guides
for i = 1:numel(breaks)
   plot([breaks(i), 18.5], [breaks(i), breaks(i)], '-k', 'LineWidth', 2)
end

% Add guides for segregation by hit / miss
plot([9.5, 18.5], [9.5, 9.5], '-r', 'LineWidth',2)
plot([9.5,  9.5], [0.5, 9.5], '-r', 'LineWidth',2)

%
title('PC Similarity by Epoch & Type')
xticks(1:18)
yticks(1:18)

types = {'hit', 'miss'};
periods = {'stim', 'wait', 'out'};

l = 1;
for i = 1:2
   for j = 1:3
      for k = 1:3
         lab{l} = ['PC', num2str(k), ', ', periods{j}, ', ', types{i}];
         l = l+1;
      end
   end
end
xticklabels(lab)
xtickangle(45)
yticklabels(lab)
colorbar()

% Repack
vecs{1,1} = A(:,1:3);
vecs{1,2} = A(:,4:6);
vecs{1,3} = A(:,7:9);

vecs{2,1} = B(:,1:3);
vecs{2,2} = B(:,4:6);
vecs{2,3} = B(:,7:9);

ncells = size(A,1);
periods = {'Stim', 'Wait', 'Out'};

figure()
for ep = 1:3
   subplot(4,3, ep)
   plot(vals{1,ep}, '-o'); hold on;
   plot(vals{2,ep}, '-o')
   grid on
   legend({'hit', 'miss'})
   xlim([0,ncells+1])
   xlabel('Cell ID')
   ylabel('Loading')
   title([periods{ep} ' Period Variances'])

   subplot(4,3, 3 + ep)
   plot(vecs{1,ep}(:,1), '-o'); hold on
   plot(vecs{2,ep}(:,1), '-o')
   ylim([-1,1])
   grid on
   legend({'hit', 'miss'}, 'Location', 'SouthWest')
   xlim([0,ncells+1])
   xlabel('Cell ID')
   ylabel('Loading')
   title('First Eigenvectors')

   subplot(4,3, 6 + ep)
   plot(vecs{1,ep}(:,2), '-o'); hold on
   plot(vecs{2,ep}(:,2), '-o')
   ylim([-1,1])
   grid on
   legend({'hit', 'miss'}, 'Location', 'SouthWest')
   xlim([0,ncells+1])
   xlabel('Cell ID')
   ylabel('Loading')
   title('Second Eigenvectors')

   subplot(4,3, 9 + ep)
   plot(vecs{1,ep}(:,3), '-o'); hold on
   plot(vecs{2,ep}(:,3), '-o')
   ylim([-1,1])
   grid on
   legend({'hit', 'miss'}, 'Location', 'SouthWest')
   xlim([0,ncells+1])
   xlabel('Cell ID')
   ylabel('Loading')
   title('Third Eigenvectors')
end

set(gcf,'Position', [100          59        1464         915])

end