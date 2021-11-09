function [] = plot_all(mus, desc, varargin)

% Let user select plot groups if desired
if nargin == 2
   sel = {'bhv', 'flr', 'hm-contrast','facr-contrast', 'evoked'};
elseif nargin == 3
   sel = varargin{1};
else
   error('Wrong number of arguments.')
end

% Plot path
plt_path = [pwd(), '/data/figs/'];

% Make the folder for figs
mkdir(plt_path)

% Pad the description string
desc = [', ' desc];

% Loop over mice
for mnum = 1:length(mus)
   
   % Make mouse specific folder
   mus_path = [plt_path, 'm', num2str(mus{1}.mta.id, '%02.f'), '/'];
   mkdir(mus_path)
   
   % Loop over days
   for dnum = 1:length(mus{mnum}.bhv)

      % Get easy to write date string and mouse ID
      dstr = mus{mnum}.nfo{dnum}.dstr;
      mid  = mus{mnum}.mta.id;

      % General title string baseline
      tstr = ['Mouse ', num2str(mid), ', ', dstr];

      
      % Behavior plots
      if any(strcmp(sel, 'bhv'))
         % Plot behavior summary
         plot_bhv(mus{mnum}.bhv{dnum})
         suptitle(['\bf{', tstr, '}'])
         
         export_fig([mus_path, tstr , ', Behavior',desc])
         close all

         % Plot behavior details
         plot_bhv_trls(mus{mnum}.bhv{dnum})
         suptitle(['\bf{', tstr, '}'])
         
         export_fig([mus_path, tstr , ', Behavior Details',desc])
         close all
      end

      
      % Fluorescence plots
      if any(strcmp(sel, 'flr'))
         % Plot fluorescence
         plot_flr_dF_grid(mus{mnum}.PVs{dnum}, 'zF', mid, dstr, [])
         suptitle(['\bf{Mouse ', num2str(mid), ', ', dstr,desc, '}'])
         
         export_fig([mus_path, tstr , ', Cells',desc])
         close all

         % Plot fluorescence by cell
         ncells = size(mus{mnum}.PVs{dnum}.dF,3); % This should use a stored variable
         date_path = [mus_path, dstr, '-Cells/'];
         mkdir(date_path)
         for cnum = 1:ncells
            plot_flr_dF(mus{mnum}.PVs{dnum}.zF, mid, dstr, cnum, [])
            
            fname = [date_path, tstr , ', Cell ', fmt(cnum),desc];
            export_fig(fname)
            close all
         end
      end
      
      
      % Evoked activity
      if any(strcmp(sel, 'evoked'))
         % Plot evoked activity
         plot_flr_evoked_grid(mus{mnum}.PVs{dnum}.ev, mid, dstr)
         
         fname = [mus_path, tstr , ', Cells, Evoked',desc];
         export_fig(fname)
         close all
      end
      
      
      
      % Contrast plots hit - miss
      if any(strcmp(sel, 'hm-contrast'))
         hit  = mus{mnum}.bhv{dnum}.msk.hit;
         miss = mus{mnum}.bhv{dnum}.msk.miss;
         cvec = get_contrast(hit, miss);
         if sum(miss) == 0 || sum(hit) == 0
            continue
         end
         
         % Plot fluorescence
         plot_flr_dF_grid(mus{mnum}.PVs{dnum}, 'zF', mid, dstr, cvec)
         suptitle(['\bf{Mouse ', num2str(mid), ', ', dstr, desc, '}'])
         
         export_fig([mus_path, tstr , ', Cells', desc, ', hit-miss'])
         close all

         % Plot fluorescence by cell
         ncells = size(mus{mnum}.PVs{dnum}.dF,3); % This should use a stored variable
         date_path = [mus_path, dstr, '-Cells/'];
         mkdir(date_path)
         for cnum = 1:ncells
            plot_flr_dF(mus{mnum}.PVs{dnum}.zF, mid, dstr, cnum, cvec)
            
            fname = [date_path, tstr , ', Cell ', fmt(cnum), desc, ', hit-miss'];
            export_fig(fname)
            close all
         end
      end
      
      
      % Contrast plots fa - cr
      if any(strcmp(sel, 'facr-contrast'))
         hit  = mus{mnum}.bhv{dnum}.msk.fa;
         miss = mus{mnum}.bhv{dnum}.msk.cr;
         cvec = get_contrast(hit, miss);
         if sum(miss) == 0 || sum(hit) == 0
            continue
         end
         
         % Plot fluorescence
         plot_flr_dF_grid(mus{mnum}.PVs{dnum}, 'zF', mid, dstr, cvec)
         suptitle(['\bf{Mouse ', num2str(mid), ', ', dstr, desc, '}'])
         
         export_fig([mus_path, tstr , ', Cells', desc, ', fa-cr'])
         close all

         % Plot fluorescence by cell
         ncells = size(mus{mnum}.PVs{dnum}.dF,3); % This should use a stored variable
         date_path = [mus_path, dstr, '-Cells/'];
         mkdir(date_path)
         for cnum = 1:ncells
            plot_flr_dF(mus{mnum}.PVs{dnum}.zF, mid, dstr, cnum, cvec)
            
            fname = [date_path, tstr , ', Cell ', fmt(cnum), desc, ', fa-cr'];
            export_fig(fname)
            close all
         end
      end
      
      
   end % day loop
end % mouse loop

end

function str = fmt(num)
   str = num2str(num, '%02.f');
end

