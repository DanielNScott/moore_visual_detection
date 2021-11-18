
% Read in the all the data files (specified in read_data)
mus = read_data();

% Subset the data to those days with behavior and fluorescence
mus = align_data(mus);

% Censor the data to valid trials
cen = censor_data(mus);

% Add a bunch of processed fluorescence
cen = add_flr(cen);


% Now we can plot everything for the valid data
plot_all(cen, ', Valid')


% Maybe we want to deal only with valid, hit trials:
tmp = censor_data(cen, 'hit');
plot_all(tmp, 'Valid Hits')

% Or miss trials
tmp = censor_data(cen, 'miss');
plot_all(tmp, 'Valid Miss')

%
tmp = censor_data(cen, 'fa');
plot_all(tmp, 'Valid Miss')


tmp = censor_data(cen, 'cr');
plot_all(tmp, 'Valid CR')