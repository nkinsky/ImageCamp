function [ local_stat, distal_stat, both_stat ] = twoenv_get_ind_mean(Mouse_struct, local_sub_use, distal_sub_use, varargin )
% [ local_stat, distal_stat, both_stat ] = twoenv_get_ind_mean(Mouse_struct, local_sub_use, distal_sub_use, varargin )
% Takes Mouse_struct and pulls out all the appropriate correlations whose
% subs are listed in local_sub_use, distal_sub_use, and optionally
% both_sub_use.
%
%   local_sub_use, distal_sub_use, both_use_sub: either a nx2 or nx3 array with the last
%   two columns being the pointers to the session comparison (e.g. [5 8] or
%   [1 5 8] compares the 5th session to the 8th session).  If there are 3
%   columns then the 1st column designates which arena to look at (1 =
%   square, 2 = octagon).  If there are only two columns then it will look
%   at the same sessions in both the square and the circle

%% Initialize variables and get varargins
temp_local = [];
temp_distal = [];
temp_both = []; both_sub_use = [];
for j = 1:length(varargin)
   if strcmpi(varargin{j},'both_sub_use')
       both_sub_use = varargin{j+1};
   end
end

%% Check for

for k = 1:length(Mouse_struct)
    for j = 1:2
            local_indices_use = make_mega_sub2ind(size(Mouse_struct(k).corr_matrix{1,j}),...
                local_sub_use(:,1),local_sub_use(:,2));
            distal_indices_use = make_mega_sub2ind(size(Mouse_struct(k).corr_matrix{1,j}),...
                distal_sub_use(:,1),distal_sub_use(:,2));
            
            temp_distal = [temp_distal; Mouse_struct.corr_matrix{1,j}(distal_indices_use)];
            temp_local = [temp_local; Mouse_struct.corr_matrix{2,j}(local_indices_use)];
            
            if ~isempty(both_sub_use)
               both_indices_use = make_mega_sub2ind(size(Mouse_struct(k).corr_matrix{1,j}),...
                   both_sub_use(:,1),both_sub_use(:,2));
               temp_both = [temp_both; Mouse_struct.corr_matrix{2,j}(both_indices_use)];
            end
    end
end

local_stat.all = temp_local;
local_stat.mean = nanmean(temp_local);
local_stat.sem = nanstd(temp_local)/sqrt(length(local_indices_use));

distal_stat.all = temp_distal;
distal_stat.mean = nanmean(temp_distal);
distal_stat.sem = nanstd(temp_distal)/sqrt(length(distal_indices_use));

if isempty(both_sub_use)
    both_stat = [];
else
    both_stat.all = temp_both;
    both_stat.mean = nanmean(temp_both);
    both_stat.sem = nanstd(temp_both)/sqrt(length(both_indices_use));
end
    
end

