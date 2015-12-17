function PV_across_days = compare_PV_across_days( PV_corr_mean, PV_corr_shuffle_mean, PV_corr, PV_corr_shuffle, day )
% PV_across_days = compare_PV_across_days( PV_corr_mean, PV_corr_shuffle_mean, PV_corr, PV_corr_shuffle, day )
%
%   Pulls out the appropriate parts of the input PV matrices specified in
%   the n x 2 vector day, where each row is a comparison and each column is
%   the appropriate session

PV_across_days.mean = cell(1,length(day));
PV_across_days.mean_shuffle = cell(1,length(day));
PV_across_days.mid = cell(1,length(day));
PV_across_days.mid_shuffle = cell(1,length(day));

for j = 1:length(day)
    compare_sesh = day{j};
    
    temp = [];
    temp_shuf = [];
    temp_mid = [];
    temp_mid_shuf = [];
    for k = 1:size(compare_sesh,1)
       temp = [ temp; PV_corr_mean(compare_sesh(k,1), compare_sesh(k,2))];
       temp_shuf = [ temp_shuf; PV_corr_shuffle_mean(compare_sesh(k,1), compare_sesh(k,2))];
       temp_mid = [ temp_mid; PV_corr(compare_sesh(k,1), compare_sesh(k,2),3,3)];
       temp_mid_shuf = [ temp_mid_shuf; PV_corr_shuffle(compare_sesh(k,1), compare_sesh(k,2),3,3)];
    end
    PV_across_days.mean{j} = temp;
    PV_across_days.mean_shuffle{j} = temp_shuf;
    PV_across_days.mid{j} = temp_mid;
    PV_across_days.mid_shuffle{j} = temp_mid_shuf;
    
end

end

