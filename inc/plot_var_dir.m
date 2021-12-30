
mnum = 1;
dnum = 4;
epch = 2;


bhv = cen{mnum}.bhv{dnum};
flr = cen{mnum}.PVs{dnum};

% 
msk   = bhv.msk.hit;
msk(isnan(msk)) = 0; 
msk = logical(msk);

nds = mus{1}.bhv{4}.nds.amp9;

%strls = bhv.nds.stim;

mdl  = fitglm(squeeze(flr.cF(nds,epch,:)), msk(nds),'Distribution','binomial');

sigs = mdl.Coefficients.pValue(2:end) < 0.05;
wgts = mdl.Coefficients.Estimate(2:end);

dvec = wgts.*sigs;
dvec = dvec./norm(dvec);


%
msk = cen{mnum}.bhv{dnum}.msk.amp9;
msk(isnan(msk)) = 0;
msk = logical(msk);

rp = squeeze(flr.cF(msk,epch,:));
rho = cov(rp);

[v,d] = eig(rho);
d = diag(d);
[d, inds] = sort(d,'descend');
v = v(:,inds);

var = dvec'*rho*dvec;

figure()
subplot(2,3,1)
plot(d,'-o')
grid on; hold on
xl = xlim();
yl = ylim();

plot([xl(1),xl(2)], [var, var], '--r')


subplot(2,3,2)
plot(v(:,1:3),'-o')
grid on

subplot(2,3,3)
plot([sum(d), var, sum(abs(dvec)>= 0.01)])

subplot(2,3,4)
plot(v'*dvec, '-o')
ylim([-1,1]);
grid on

subplot(2,3,5)
plot(dvec, '-o')
grid on




