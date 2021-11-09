% Script settings
path      = '/media/dan/My Passport/moore_lab_data_behavior/';
visible   = 'Off';
plot_figs = 0;

ftype = 'full';
%id_select = [10, 13];

% Just set these to any mouse ids you want that have files
% attached to them (and it will skip other files)
dqual.ids = [10, 13];


% ------- Script ----------
files = dir(path);

disp('Getting dates for files.')
dqual.date_array = get_date_array(files);

disp('Parsing behavior...')
dqual = parse_behavior_loop(files, dqual, path, plot_figs, visible);

disp('Generating summary data.')
dqual = get_behave_summaries(dqual);

disp('Done.')


% -------- Functions -------------

function date_array = get_date_array(files)
   nfiles = length(files);

   date_array = [];
   
   % Start at 3 because first two are directory links (. and ..).
   for fnum = 3:nfiles
      ps.fname = files(fnum).name;
      [id, year, month, day] = parse_date_behave(ps.fname);

      date_array(end+1,:) = [id, year,month,day];
   end
   
   date_array = sortrows(date_array);
end


function dqual = parse_behavior_loop(files, dqual, path, plot_figs, visible)

   % The path for run_analysis.m
   ps.path = path;
   nfiles = length(files);
   
   % Start at 3 because first two are directory links (. and ..).
   for fnum = 3:nfiles
      ps.fname = files(fnum).name;

      disp(['Processing file ',num2str(fnum-2), ': ', ps.fname])

      
      % Get session data
      [id, year, month, day] = parse_date_behave(ps.fname);

      these_days = dqual.date_array(dqual.date_array(:,1) == id,:);
      num_days = size(these_days,1);
      date_num = find(all(these_days == [id, year, month, day],2));

      mouse_num = find(dqual.ids == id);

      
      % Behavioral analysis
      if any(id == dqual.ids)
         ps.behavior_only = 1;
         parsed = parse_behavior_from_file(ps);
         
         % Save parsed data to a mat file
         parsed_file = ['./data/' ps.fname(1:(end-4)), '_parsed.mat'];
         save(parsed_file, 'parsed')

         valid_msk = and((parsed.dPrimeHi > 1.2),(parsed.faCont <= 0.35));

         if plot_figs
            plot_parsed_behavior(parsed, visible);
            fig_name = ['./data/figs_new/', ps.fname(1:(end-4)), '_parsed'];
            %savefig( [fig_name '.fig']);
            export_fig([fig_name '.png'], '-png', '-r100')
         end

         dqual.mouse{mouse_num}.valid{date_num}.day   = day;
         dqual.mouse{mouse_num}.valid{date_num}.month = month;
         dqual.mouse{mouse_num}.valid{date_num}.year  = year;
         dqual.mouse{mouse_num}.valid{date_num}.fname = ps.fname;
         dqual.mouse{mouse_num}.valid{date_num}.msk   = valid_msk;
         dqual.mouse{mouse_num}.id = id;
      else
         disp(['Skipping file: ' ps.fname])
      end

      close all
   end

end