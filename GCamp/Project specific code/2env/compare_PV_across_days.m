function PV_across_days = compare_PV_across_days( PV_corr_mean, PV_corr_shuffle_mean, PV_corr, PV_corr_shuffle, day )
% PV_across_days = compare_PV_across_days( PV_corr_mean, PV_corr_shuffle_mean, PV_corr, PV_corr_shuffle, day )
%
%   Pulls out the appropriate parts of the input PV matrices specified in
%   the n x 2 vector day, where each row is a comparison and each column is
%   the appropriate session.  day should really be called session.

PV_across_days.mean = cell(1,length(day));
PV_across_days.mean_shuffle = cell(1,length(day));
PV_across_days.mid = cell(1,length(day));
PV_across_days.mid_shuffle = cell(1,length(day));

for j = 1:length(day)
    compare_sesh = day{j};
    
    temp = [];
    temp_shuffle = [];
    temp_mid = [];
    temp_mid_shuffle = [];
    temp_all = [];
    temp_all_shuffle = [];
    for k = 1:size(compare_sesh,1)
       temp = [ temp; PV_corr_mean(compare_sesh(k,1), compare_sesh(k,2))];
       temp_shuffle = [ temp_shuffle; PV_corr_shuffle_mean(compare_sesh(k,1), compare_sesh(k,2))];
       temp_mid = [ temp_mid; PV_corr(compare_sesh(k,1), compare_sesh(k,2),3,3)];
       temp_mid_shuffle = [ temp_mid_shuffle; PV_corr_shuffle(compare_sesh(k,1), compare_sesh(k,2),3,3)];
       temp_all = [temp_all; squeeze(PV_corr(compare_sesh(k,1),compare_sesh(k,2),:))];
       temp_all_shuffle = [temp_all_shuffle; squeeze(PV_corr_shuffle(compare_sesh(k,1),compare_sesh(k,2),:))];
    end
    PV_across_days.mean{j} = temp;
    PV_across_days.mean_shuffle{j} = temp_shuffle;
    PV_across_days.mid{j} = temp_mid;
    PV_across_days.mid_shuffle{j} = temp_mid_shuffle;
    PV_across_days.all{j} = temp_all;
    PV_across_days.all_shuffle{j} = temp_all_shuffle;
    
end

end

