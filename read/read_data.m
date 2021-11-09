function mus = read_data()

% Settings
path      = '/media/dan/My Passport/moore_lab_data/';
visible   = 'Off';
plot_figs = 0;
fmt       = 'full';

% Set these to any mouse ids desired
ids = [10];

% Date range (YYY, MM, DD) to keep files from.
beg = [2021, 6, 23];
fin = [2021, 6, 26];

% Parameters establishing data validity
ps.min_dP_hi = 1.2;
ps.max_fa    = 0.35;


% ------- Do stuff ----------
files = dir(path);

disp('Initializing analysis parameters.')
ps = init_params(ps);

disp('Getting dates for files.')
[~, files] = get_date_array(files, fmt, ps, beg, fin, ids);

disp('Parsing behavior...')
mus = read_behavior_loop(files, ids, path, fmt, ps);

disp('Generating summary data.')
mus = add_stats_valid(mus);

disp('Done.')
end

% -------- Functions -------------

function [date_array, fout] = get_date_array(files, fmt, ps, beg, fin, ids)
   nfiles = length(files);

   % Initialize
   date_array = [];
   fcnt = 0;
   
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

      if pst_beg && pre_end && has_id
         fcnt = fcnt + 1;
         date_array(end+1,:) = [id, year, month, day];
         fout{fcnt,1} = ps.fname;
      end
   end
   
   % Sort temporally
   [date_array, inds] = sortrows(date_array);
   fout = fout(inds);
end


function mus = read_behavior_loop(files, ids, path, fmt, ps)

   % The path for run_analysis.m
   ps.path = path;
   nfiles = length(files);
   
   % Files are in a preprocessed list, sorted temporally
   for fnum = 1:nfiles
      ps.fname = files{fnum};
      disp(['Processing file ',num2str(fnum), ': ', ps.fname])
      
      % Get session data
      [id, year, month, day] = parse_file_date(ps.fname, fmt);

      % Now dnum is fnum;
      dnum = fnum;
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

         %
         valid_msk  = and((bhv.dPrimeHi > ps.min_dP_hi),(bhv.faCont <= ps.max_fa));
         valid_trls = find(valid_msk);
      catch ME
         warning(ME.message)
      end

      % Get fluorescence
      try
         PVs = parse_fluorescence_from_file([ps.path ps.fname], ps, bhv, stimInds);
         mus{mnum}.PVs{dnum} = PVs;         
      catch ME
         warning(ME.message)
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