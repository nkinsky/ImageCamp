function [ distal_by_day, local_by_day, both_by_day ] = twoenv_get_drift( Mouse, time_index, indices_aligned, indices_conflict )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


num_animals = length(Mouse);

days_bw_sesh = [0 1 2 3 4 5 6];

% Pre-allocate
local_by_day = cell(1,length(days_bw_sesh));
distal_by_day = cell(1,length(days_bw_sesh));
both_by_day = cell(1,length(days_bw_sesh));
for j = 1:num_animals
    for k = 1:2
        for ll = 1:7
            for mm = ll+1:8
                % Identify row of time_index to use
                row_use_logical = time_index(:,1) == k & ...
                    time_index(:,2) == ll & time_index(:,3) == mm;
                % Logicals to see if the sessions are aligned or in
                % conflict
                try
                aligned_logical = time_index(row_use_logical,1) == indices_aligned{j}(:,1) ...
                    & time_index(row_use_logical,2) == indices_aligned{j}(:,2) ... 
                    & time_index(row_use_logical,3) == indices_aligned{j}(:,3);
                conflict_logical = time_index(row_use_logical,1) == indices_conflict{j}(:,1) ...
                    & time_index(row_use_logical,2) == indices_conflict{j}(:,2) ... 
                    & time_index(row_use_logical,3) == indices_conflict{j}(:,3);
                catch
                    keyboard
                end
                time_span = time_index(row_use_logical,4);
                day_logical = days_bw_sesh == time_span;
                if sum(conflict_logical) == 1
                    local_by_day{day_logical} = [local_by_day{day_logical}; ...
                        squeeze(Mouse(j).corr_matrix{2,k}(ll,mm,:))];
                    distal_by_day{day_logical} = [distal_by_day{day_logical}; ...
                        squeeze(Mouse(j).corr_matrix{1,k}(ll,mm,:))];
                elseif sum(aligned_logical == 1)
                    both_by_day{day_logical} = [both_by_day{day_logical}; ...
                        squeeze(Mouse(j).corr_matrix{1,k}(ll,mm,:))];
                else % error catching
                    disp('Error - session comparison fits neither aligned nor conflicted indices')
                    keyboard
                end
            end
        end
    end
    
end

end

