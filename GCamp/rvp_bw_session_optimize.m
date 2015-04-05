% Script to compare one session with another and see which RVP correlates
% the best with the other session RVP and if there is any systematic bias
% to it!

startpath = '';
for j = 1:2
    [f p] = uigetfile( '*.mat',['Select Session ' num2str(j) ' rvp file']);
   session(j).file = [p f];
end

sesh = importdata(session(1).file);
sesh(2) = importdata(session(2).file);

best_corr_ind = zeros(size(sesh(1).AvgFrame_DF));
best_corr_val = zeros(size(sesh(1).AvgFrame_DF));
 
 num_bins = length(sesh(1).AvgFrame_DF(:));
 
 for j = 1:num_bins
     temp2 = [];
     for k = 1:num_bins
         temp = corrcoef(sesh(1).AvgFrame_DF{j},sesh(2).AvgFrame_DF{k});
         temp2 = [temp2 temp(1,2)];
     end
          [val, ind] = max(temp2);
          best_corr_ind(j) = ind;
          best_corr_val(j) = val;
          
 end