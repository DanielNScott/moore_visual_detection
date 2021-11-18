function mus = read_data()

% Settings
path      = '/media/dan/My Passport/moore_lab_data/';
visible   = 'Off';
plot_figs = 0;
fmt       = 'full';

% Set these to any mouse ids desired
ids = [10];

% Date range (YYY, MM, DD) to keep files from.
beg = [2021, 6, 15];
fin = [2021, 6, 15];

% A list which, if not empty, supercedes the above
dlist =[];
%dlist = [...
%   2021, 6, 11; ...
%   2021, 6, 15; ...
%   2021, 6, 17; ...
%   2021, 6, 18; ...
%   2021, 6, 24; ...
%   2021, 6, 25; ...
%   2021, 6, 29; ...
%   2021, 6, 30];
   
% Parameters establishing data validity
ps.min_dP_hi = 1.2;
ps.max_fa    = 0.35;

% Filter cutoff frequency
filter = designfilt('lowpassfir', 'FilterOrder', 76, 'CutoffFrequency',5, ...
   'DesignMethod','window','Window',{@kaiser,3},'SampleRate',30);

% ------- Do stuff ----------
files = dir(path);

disp('Initializing analysis parameters.')
ps = init_params(ps);

disp('Getting dates for files.')
[~, files] = get_date_array(files, fmt, ps, beg, fin, dlist, ids);

disp('Parsing behavior...')
mus = read_behavior_loop(files, ids, path, fmt, ps, filter);

disp('Generating summary data.')
mus = add_stats_valid(mus);

disp('Done.')
end

% -------- Functions -------------

function [date_array, fout] = get_date_array(files, fmt, ps, beg, fin, dlist, ids)
   nfiles = length(files);

   % Initialize
   date_array = [];
   fcnt = 0;
   
   % Override beg, fin
   if ~isempty(dlist)
      beg = dlist(1  ,:);
      fin = dlist(end,:);
   end
   
   % Start at 3 because first two are directory links (. and ..).
   for fnum = 3:nfiles
      ps.fname = files(fnum).name;
      
      % Skip folders
      if ~strcmp(ps.fname(1:5), 'PV6s_')
         continue
      end
      
      [id, year, month, day] = parse_file_date(ps.fname, fmt);

      disp(['Getting date & id from: ' ps.fname])
      
      pst_beg = year >= beg(1) && month >= beg(2) && day >= beg(3);
      pre_end = year <= fin(1) && month <= fin(2) && day <= fin(3);
      has_id  = any(id == ids);

      % If there was no day list input, look for all in range.
      if isempty(dlist)
         if pst_beg && pre_end && has_id
            fcnt = fcnt + 1;
            date_array(end+1,:) = [id, year, month, day];
            fout{fcnt,1} = ps.fname;
         end
      else
         % Get any matches to input list.
         matches = all(dlist == [year, month, day],2);
         if any(matches) && has_id
            fcnt = fcnt + 1;
            ind = find(matches);
            date_array(end+1,:) = [id, year, month, day];
            fout{fcnt,1} = ps.fname;
         end
      end
   end
   
   % Sort temporally
   [date_array, inds] = sortrows(date_array);
   fout = fout(inds);
end


function mus = read_behavior_loop(files, ids, path, fmt, ps, filter)

   % The path for run_analysis.m
   ps.path = path;
   nfiles = length(files);
   
   %
   mnum = 0;
   dnum = 0;
   
   % Files are in a preprocessed list, sorted temporally
   for fnum = 1:nfiles
      ps.fname = files{fnum};
      disp(['Processing file ',num2str(fnum), ': ', ps.fname])
      
      % Get session data
      [id, year, month, day] = parse_file_date(ps.fname, fmt);

      % Now dnum is fnum;
      if mnum == find(ids == id)
         dnum = dnum + 1;
      else
         dnum = 1;
      end
      mnum = find(ids == id);
      
      % Skip file if it doesn't have an ID we want
      if ~any(id == ids)
         disp(['Skipping file: ' ps.fname])
         continue
      end
        
      % Get behavior
      try
         [bhv, stimInds] = parse_behavior_from_file(ps);
         mus{mnum}.bhv{dnum} = bhv;
         got_behavior = 1;
      catch ME
         warning(ME.message)
         got_behavior = 0;
      end

      % Get fluorescence
      try
         PVs = parse_fluorescence_from_file([ps.path ps.fname], ps, bhv, stimInds, filter);
         mus{mnum}.PVs{dnum} = PVs;
      catch ME
         warning(ME.message)
      end

      if got_behavior == 1
         valid_msk  = and((bhv.dPrimeHi > ps.min_dP_hi),(bhv.faCont <= ps.max_fa));
         valid_trls = find(valid_msk);
      end
      
      date_str = [num2str(year), '-', num2str(month,'%02.f'),'-', num2str(day,'%02.f')];
      
      % Save session information
      mus{mnum}.nfo{dnum}.day   = day;
      mus{mnum}.nfo{dnum}.month = month;
      mus{mnum}.nfo{dnum}.year  = year;
      mus{mnum}.nfo{dnum}.dstr  = date_str;
      mus{mnum}.nfo{dnum}.fname = ps.fname;

      mus{mnum}.bhv{dnum}.msk.vld = valid_msk;
      mus{mnum}.bhv{dnum}.nds.vld = valid_trls;
      
      mus{mnum}.nfo{dnum}.nvld = sum(valid_msk);
      mus{mnum}.nfo{dnum}.ntrl = length(valid_msk);
      mus{mnum}.nfo{dnum}.fvld = sum(valid_msk)./length(valid_msk);

      % Save mouse metadata
      mus{mnum}.mta.id    = id;
      mus{mnum}.mta.files = files;

      close all
   end

end

% if plot_figs
%    plot_parsed_behavior(parsed, visible);
%    fig_name = ['./data/figs_new/', ps.fname(1:(end-4)), '_parsed'];
%    %savefig( [fig_name '.fig']);
%    export_fig([fig_name '.png'], '-png', '-r100')
% end