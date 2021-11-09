function [] = plot_flr_evoked(evoked, mid, dstr, cid, varargin)

% Default plot layout, modify if input
dvec = [-1,1,1,1];
pvec = get_plotvec(varargin, dvec);

ntrls  = size(evoked,2);

subplotpv(pvec,1)
plot(evoked(cid,:), 'LineWidth', 2)

title(['Mouse ', num2str(mid), ', ', dstr, ', Cell ', num2str(cid)])
grid on
ylim([-2000, 2000])
xlim([1,ntrls])

xlabel('Time [ms]')
ylabel('dF/F [BL STD]')

end