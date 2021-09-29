ps.path  = '/media/dan/My Passport/moore_lab_data_behavior/';
visible = 'Off';

files = dir(ps.path);
nfiles = length(files);

dqual.ids = [10, 11, 12, 13, 16];

date_array = [];
for fnum = 3:nfiles
   ps.fname = files(fnum).name;
   [id, year, month, day] = parse_date_behave(ps.fname);
   
   date_array(end+1,:) = [id, year,month,day];
end

date_array = sortrows(date_array);
dqual.date_array = date_array;

for fnum = 3:nfiles
   ps.fname = files(fnum).name;
   
   run_analysis;
   
   valid_msk = and((parsed.dPrimeHi > 1.2),(parsed.faCont <= 0.35));
   
   plot_parsed_behavior(parsed, visible);
   fig_name = ['./data/figs_new/', ps.fname(1:(end-4)), '_parsed'];
   %savefig( [fig_name '.fig']);
   export_fig([fig_name '.png'], '-png', '-r100')
   
   [id, year, month, day] = parse_date_behave(ps.fname);

   these_days = date_array(date_array(:,1) == id,:);
   num_days = size(these_days,1);
   date_num = find(all(these_days == [id, year, month, day],2));
   
   mouse_num = find(dqual.ids == id);
   
   dqual.mouse{mouse_num}.valid{date_num}.msk = valid_msk;
   dqual.mouse{mouse_num}.valid{date_num}.day = day;
   dqual.mouse{mouse_num}.valid{date_num}.month = month;
   dqual.mouse{mouse_num}.valid{date_num}.year  = year;
   dqual.mouse{mouse_num}.valid{date_num}.fname = ps.fname;
   
   close all
end

% Summarize mouse quality
for mouse_num = 1:numel(dqual.mouse)
   
   dqual.mouse{mouse_num}.valid_cnt = [];
   dqual.mouse{mouse_num}.valid_len = [];
   dqual.mouse{mouse_num}.valid_frc = [];

   dqual.mouse{mouse_num}.valid_cnt_total = 0;
   dqual.mouse{mouse_num}.valid_len_total = 0;

   for day_num = 1:numel(dqual.mouse{mouse_num}.valid)
      
      valid_cnt = sum(dqual.mouse{mouse_num}.valid{day_num}.msk);
      valid_len = numel(dqual.mouse{mouse_num}.valid{day_num}.msk);
      
      valid_frc = valid_cnt / valid_len;
      
      dqual.mouse{mouse_num}.valid_cnt(end+1) = valid_cnt;
      dqual.mouse{mouse_num}.valid_len(end+1) = valid_len;
      dqual.mouse{mouse_num}.valid_frc(end+1) = valid_frc;
      
      dqual.mouse{mouse_num}.valid_cnt_total = dqual.mouse{mouse_num}.valid_cnt_total + valid_cnt;
      dqual.mouse{mouse_num}.valid_len_total = dqual.mouse{mouse_num}.valid_len_total + valid_len;
      
   end
   dqual.mouse{mouse_num}.valid_frc_total = dqual.mouse{mouse_num}.valid_cnt_total ./ dqual.mouse{mouse_num}.valid_len_total;
end

function [id, year, month, day] = parse_date_image(fname)
   id    = str2num(fname(6:7));
   day   = str2num(fname(9:10));
   
   months = {'June', 'July'};
   month_nums = [6,7];
   
   month = fname(11:14);
   month = month_nums(strcmp(month,months));
   
   year  = str2num(fname(15:18));
end


function [id, year, month, day] = parse_date_behave(fname)
   id    = str2num(fname(6:7));
   day   = str2num(fname(26:27));
   month = str2num(fname(24:25));
   year  = str2num(fname(20:23));
end