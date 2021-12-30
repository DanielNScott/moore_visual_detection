function ps = init_params(ps)

   % Analysis parameters
   %ps.path  = './data/';
   %ps.fname = 'cix27_25Feb2019.mat';
   %ps.path  = '/media/dan/My Passport/moore_lab_data/';
   %ps.fname = 'PV6s_10_17June2021.mat';
   %ps.dqualf = 'dqual_10_13.mat';

   % Only parse behavior and return
   ps.re_parse_behavior = 1;

   % Flourescence params
   ps.baseInds = 1:1000;
   ps.respInds = 1000:2000;
   ps.dFBLWindowLen = 500;

   ps.inclPy = 0;

   % Force truncation of nStim for known problems
   ps.nStimMax = Inf;

   % Pre/post are ms before/after stimulus onset
   ps.dFWindow = [-1000,3000];

   % Response period length
   ps.lickWindow = 1000;
   ps.epochs{1} = -1000:0;
   ps.epochs{2} =  1:1000;
   ps.epochs{3} =  1001:2000;
   ps.epochs{4} =  2001:3000;
   

   ps.hitRateLB = 0.3;
   ps.faRateLB  = 0.02;

   % Compute noise correlation densities over trials for every ms. 
   % (Takes a while! Make get_nc_density_dynamics faster...)
   ps.byStepNCDynamics = 0;

   % Save the processed .mat file?
   ps.save_proc = 1;

   % Plot things?
   ps.plot_flg = 0;

end