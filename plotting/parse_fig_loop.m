ps.path  = '/media/dan/My Passport/moore_lab_data/';
files = dir(ps.path);

for fnum = 3:53
   ps.fname = files(fnum).name;
   
   run_analysis;
   
   plot_parsed_behavior(parsed);
   fig_name = [ps.fname(1:(end-4)), '_parsed_amp'];
   savefig( [fig_name '.fig']);
   export_fig([fig_name '.png'], '-png', '-r100')
   
   close all
end