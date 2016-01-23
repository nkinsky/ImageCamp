function [ local_stat_all, distal_stat_all, both_stat_all ] = twoenv_combine_ind_stats( Mouse_struct)
%UNTITLED6 Hack to combine all correlations values, mean correlations, and
%sems of correlations from each mouse (hack because I am just taking the
%mean of means for now).  Need to update to, AT LEAST, use the all_means
%field from each mouse's _stat2 structure...

group_get_ref = {'separate_win','sep_conn1','sep_conn2','before_after'};
stat_get_ref = {'all','mean','sem'};
% stat_get_ref = {'all','all_means','mean','sem'};

local_stat_all = struct();
distal_stat_all = struct();
both_stat_all = struct();

for j = 1:length(group_get_ref)
    for k = 1:length(stat_get_ref)
        local_temp = [];
        distal_temp = [];
        both_temp = [];
        try
            for ll = 1:length(Mouse_struct)
                
                % Get stats from each animal - keep empty if not there
                empty_check = getfield(Mouse_struct(ll).local_stat2,group_get_ref{j});
                if ~isempty(empty_check)
                    local_temp = [local_temp; getfield(Mouse_struct(ll).local_stat2,...
                        group_get_ref{j},stat_get_ref{k})];
                else
                    local_temp = [local_temp; nan]; % Set to nans if empty
                end
                
                empty_check = getfield(Mouse_struct(ll).distal_stat2,group_get_ref{j});
                if ~isempty(empty_check)
                    distal_temp = [distal_temp; getfield(Mouse_struct(ll).distal_stat2,...
                        group_get_ref{j},stat_get_ref{k})];
                else
                    distal_temp = [distal_temp; nan];
                end
                
                empty_check = getfield(Mouse_struct(ll).both_stat2,group_get_ref{j});
                if ~isempty(empty_check)
                    both_temp = [both_temp; getfield(Mouse_struct(ll).both_stat2,...
                        group_get_ref{j},stat_get_ref{k})];
                else
                    both_temp = [both_temp; nan];
                end
                
            end
            local_stat_all = setfield(local_stat_all,group_get_ref{j},stat_get_ref{k},nanmean(local_temp));
            distal_stat_all = setfield(distal_stat_all,group_get_ref{j},stat_get_ref{k},nanmean(distal_temp));
            both_stat_all = setfield(both_stat_all,group_get_ref{j},stat_get_ref{k},nanmean(both_temp));
        catch
            disp('Error catching')
            keyboard
        end
    end
    
end

% keyboard

end


