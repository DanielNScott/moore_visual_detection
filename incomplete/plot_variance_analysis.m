function [] = plot_variance_analysis(dF, nTrials, hits, miss, ndims)

   for i = 1:nTrials
      sigma(:,:,i) = cov(squeeze(dF(i,:,:))); 

      trList(i) = trace(squeeze(sigma(:,:,i)));

      [v, d] = eig(squeeze(sigma(:,:,i)));

      [d,inds] = sort(diag(d), 'descend');
      v = v(:,inds);

      dList(:,i)  = d(1:2);
      vList1(:,i) = v(:,1);
      vList2(:,i) = v(:,2);

   end

   [~, inds_h] = sort(trList(:,hits ),'descend');
   [~, inds_m] = sort(trList(:,miss),'descend');


   figure();

   subplot(2,3,1)
   plot([dList(:,hits(inds_h) ); trList(:,hits(inds_h)  )]','o')
   grid on
   ylim([0,200])
   title('Hit Trial Population Variance')

   subplot(2,3,2)
   plot([dList(:,miss(inds_m)); trList(:,miss(inds_m) )]','o')
   grid on
   ylim([0,200])
   title('Miss Trial Population Variance')

   subplot(2,3,3)
   histogram(trList(hits),'BinEdges',0:5:200); hold on
   histogram(trList(miss),'BinEdges',0:5:200);
   title('Population Variance Histograms')
   grid on

   subplot(2,3,4)
   histogram(get_upper(abs(vList1(:,[hits])'*vList1(:,[hits])))); hold on;
   histogram(get_upper(abs(vList1(:,[miss])'*vList1(:,[miss]))))
   
   %imagesc(abs(vList1(:,[hits, miss])'*vList1(:,[hits, miss])))
   title('1st Eigenvector abs(Cosine Similarity)')
   %xlabel('Trial Number, Sorted by Hit then Miss')
   %colorbar()

   subplot(2,3,5)
   imagesc(vList2(:,[hits, miss])'*vList2(:,[hits, miss]))
   title('2nd Eigenvector Cosine Similarity')
   xlabel('Trial Number, Sorted by Hit then Miss')
   colorbar()

   sel = miss;
   dFR = zeros(length(sel),4000,16);
   for t = 1:4000
      [U,S,V] = svd(squeeze(dF(sel,t,:)));
      

      if t > 1
         for i = 1:ndims
            if -V(:,i)'*basis(:,i,t-1) > V(:,i)'*basis(:,i,t-1)
               V(:,i) = -V(:,i);
               U(:,i) = -U(:,i);
            end
         end
      else
         if all(size(sel) == size(miss)) && all(sel == miss)
            V(:,1) = -V(:,1);
         end
      end
      
      coefs(:,:,t) = U(:, 1:ndims);
      basis(:,:,t) = V(:, 1:ndims);
      svals(:,t) = diag(S(1:16, 1:16));
      
      dFR(:,t,:) = U(:,1:ndims)*S(1:ndims,:)*V';
   end
   
   vind = get_var_ind(dF);
   vpop = get_var_pop(dF);
   
   
   vindR = get_var_ind(dFR);
   vpopR = get_var_pop(dFR);
   
   figure();
   corder = get(gca, 'ColorOrder');
   plot(sqrt(sum(vind,1))); hold on;
   plot(sqrt(vpop))
   
   plot(sqrt(sum(vindR,1)), '--', 'Color', corder(1,:))
   plot(sqrt(vpopR)       , '--', 'Color', corder(2,:))
   grid on
   
   figure()
   subplot(2,2,1)
   imagesc(squeeze(basis(:,1,:)));
   
   subplot(2,2,2)
   imagesc(squeeze(coefs(:,1,:)));
   
   if ndims > 1
      subplot(2,2,3)
      imagesc(squeeze(basis(:,2,:)))

      subplot(2,2,4)
      imagesc(squeeze(coefs(:,2,:)));
   end
   
   figure()
   imagesc(sqrt(svals))
   colorbar()
   title('Singular Values for Std. by Time')
   xlabel('Time [ms]')
   ylabel('S.V. Number')
   
   basis_mean = mean(squeeze(basis(:,1,1000:2000)),2);
   basis_std  = std(squeeze(basis(:,1,1000:2000)),[],2);
   
   [basis_mean, inds] = sort(basis_mean,'descend');
   basis_std = basis_std(inds);
   
   figure();
   plot(basis_mean, '-o'); hold on;
   plot(basis_mean + basis_std, '--ok');
   plot(basis_mean - basis_std, '--ok');
end

function vind = get_var_ind(dF)
   for i = 1:16
      for t = 1:4000
         vind(i,t) = var(dF(:,t,i));
      end
   end
end

function vpop = get_var_pop(dF)
   
   for t = 1:4000
      vpop(t) = var(sum(dF(:,t,:),3));
   end

end