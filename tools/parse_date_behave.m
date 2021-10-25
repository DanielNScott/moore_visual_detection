function [id, year, month, day] = parse_date_behave(fname)
   id    = str2num(fname(6:7));
   day   = str2num(fname(26:27));
   month = str2num(fname(24:25));
   year  = str2num(fname(20:23));
end