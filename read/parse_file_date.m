function [id, year, month, day] = parse_file_date(fname, fmt)

if strcmp(fmt,'behavior')
   id    = str2num(fname(6:7));
   day   = str2num(fname(26:27));
   month = str2num(fname(24:25));
   year  = str2num(fname(20:23));
elseif strcmp(fmt, 'full')
   id    = str2num(fname(6:7));
   day   = str2num(fname(9:10));
   month = str2num(fname(12:13));
   year  = str2num(fname(15:18));
else
   error('Unknown format, use "behavior" or "full"')
end
   
end