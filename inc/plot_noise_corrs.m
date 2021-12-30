

mnum = 1;
dnum = 4;
nds  = mus{1}.bhv{4}.nds.amp9;
epch = 2;

flr = mus{mnum}.PVs{dnum};



rho = corr(squeeze(flr.cF(nds,epch,:)));
sig = cov( squeeze(flr.cF(nds,epch,:)));


[v, d] = eig(sig);

d = diag(d);
[d, sinds] = sort(d, 'descend');
v = v(:,sinds);

figure()

subplot(2,2,1)
histogram(get_upper(rho))
grid on
xlim([-1,1])

subplot(2,2,2)
sim = corr(flr.amp9.mFm(2:4,:));
aug = v(:,2)*diag(d(2))*v(:,2)';

plot(get_upper(sim), get_upper(sig), 'o')
grid on


subplot(2,2,3)
csum = cumsum(d);
fve  = csum./csum(end);

plot(d./sum(d), '-o'); hold on
%yyaxis right
%plot(fve, '-o')
%ylim([0,1])
fmt()

subplot(2,2,4)
plot(v(:,1), '-o'); hold on;
plot(v(:,2), '-o')
fmt()


function [] = fmt()
grid on
xlim([0,17])
end