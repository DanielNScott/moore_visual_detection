function dqual = get_behave_summaries(dqual)
% Takes the data quality structure containing the trial validity mask
% and computes some summary info.

for mouse_num = 1:numel(dqual.mouse)
   
   dqual.mouse{mouse_num}.valid_cnt = [];
   dqual.mouse{mouse_num}.trial_cnt = [];
   dqual.mouse{mouse_num}.valid_frc = [];

   dqual.mouse{mouse_num}.valid_cnt_total = 0;
   dqual.mouse{mouse_num}.trial_cnt_total = 0;

   for day_num = 1:numel(dqual.mouse{mouse_num}.valid)
      
      valid_cnt = sum(  dqual.mouse{mouse_num}.valid{day_num}.msk);
      trial_cnt = numel(dqual.mouse{mouse_num}.valid{day_num}.msk);
      
      valid_frc = valid_cnt / trial_cnt;
      
      dqual.mouse{mouse_num}.valid_cnt(end+1) = valid_cnt;
      dqual.mouse{mouse_num}.trial_cnt(end+1) = trial_cnt;
      dqual.mouse{mouse_num}.valid_frc(end+1) = valid_frc;
      
      dqual.mouse{mouse_num}.valid_cnt_total = dqual.mouse{mouse_num}.valid_cnt_total + valid_cnt;
      dqual.mouse{mouse_num}.trial_cnt_total = dqual.mouse{mouse_num}.trial_cnt_total + trial_cnt;
      
   end
   dqual.mouse{mouse_num}.valid_frc_total = dqual.mouse{mouse_num}.valid_cnt_total ./ dqual.mouse{mouse_num}.trial_cnt_total;
end

end