function [id, year, month, day] = parse_date_image(fname)
   id    = str2num(fname(6:7));
   day   = str2num(fname(9:10));
   
   months = {'June', 'July'};
   month_nums = [6,7];
   
   month = fname(11:14);
   month = month_nums(strcmp(month,months));
   
   year  = str2num(fname(15:18));
end