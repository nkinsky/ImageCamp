function [ local_stat, distal_stat, both_stat] = twoenv_get_ind_mean(Mouse_struct, local_sub_use, distal_sub_use, varargin )
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
%   at the same sessions in both the square and the circle.  Number of
%   columns must be consistent across all

%% Initialize variables and get varargins

% Defaults
temp_local = [];
temp_distal = [];
temp_both = []; both_sub_use = [];
metric_type = 'corr_matrix';

% Pull in varargins
for j = 1:length(varargin)
   if strcmpi(varargin{j},'both_sub_use')
       both_sub_use = varargin{j+1};
   end
   if strcmpi(varargin{j},'metric_type')
       metric_type = varargin{j+1};
   end
end

%% Check if arena type is specified in the vectors - if not, then add it in

local_sub_use = check_indices_type(local_sub_use);
distal_sub_use = check_indices_type(distal_sub_use);
both_sub_use = check_indices_type(both_sub_use);

%% Create _stat variables

local_stat = calc_group_stats(Mouse_struct, local_sub_use, 2, metric_type);
local_stat.PV_stat = calc_PV_group_stats(Mouse_struct, local_sub_use, 2);
temp3 = calc_group_shuffled_stats(Mouse_struct, local_sub_use, 2);
local_stat.shuffle_stat = temp3;
temp5 = calc_PV_group_shuffled_stats(Mouse_struct, local_sub_use, 2);
local_stat.PV_stat.shuffle_stat = temp5;

distal_stat = calc_group_stats(Mouse_struct, distal_sub_use,1, metric_type);
distal_stat.PV_stat = calc_PV_group_stats(Mouse_struct, distal_sub_use,1);

if ~isempty(both_sub_use)
    both_stat = calc_group_stats(Mouse_struct, both_sub_use,1);
    temp2 = calc_group_shuffled_stats(Mouse_struct, both_sub_use, 1);
    both_stat.shuffle_stat = temp2;
    
    both_stat.PV_stat = calc_PV_group_stats(Mouse_struct, both_sub_use,1);
    temp4 = calc_PV_group_shuffled_stats(Mouse_struct, both_sub_use, 1);
    both_stat.PV_stat.shuffle_stat = temp4;
else
    both_stat = [];
end
    
end

%% sub-function to check indices
function [indices_fix] = check_indices_type(indices_in)
%%
num_comparisons = size(indices_in,1);
if size(indices_in,2) == 2
    indices_fix = zeros(2*num_comparisons,3);
    indices_fix(1:num_comparisons,1) = ones(num_comparisons,1);
    indices_fix(num_comparisons + 1:end,1) = 2*ones(num_comparisons,1);
    indices_fix(:,2:3) = repmat(indices_in,2,1);
else
    indices_fix = indices_in;
end
%%
end

%% sub-fuction to get correlations out and calculate mean/sem
function [stat_use] = calc_group_stats(animal_struct, sub_use, local_flag, metric_type)
% local_flag: 1 = use distal aligned comparisons, 2 = use local aligned
% comparisons, metric_type = 'corr_matrix' (default) or 'min_dist_matrix'

% If not specified, pull from corr_matrix
if nargin < 4
    metric_type = 'corr_matrix';
end

all_out = [];
all_out2 = cell(size(sub_use,1),1);
all_means = nan(size(sub_use,1),1);
temp = [];
num_comparisons = size(sub_use,1);
for k = 1:length(animal_struct)
    for arena_use = 1:2
        sub_use_byarena = find(arena_use == sub_use(:,1)); % Pull-out subs for appropriate arena
        for m = 1:length(sub_use_byarena)
%             indices_use = make_mega_sub2ind(size(animal_struct(k).(metric_type){local_flag,arena_use}),...
%                 sub_use(sub_use_byarena(m),2),sub_use(sub_use_byarena(m),3)); % convert subs to indices
            
            temp = squeeze(animal_struct(k).(metric_type){local_flag,arena_use}...
                (sub_use(sub_use_byarena(m),2),sub_use(sub_use_byarena(m),3),:)); % Get appropriate correlations
            all_out = [all_out; temp]; % Add appropriate comparisons into temp_out
            all_out2{sub_use_byarena(m)} = temp;
            all_means(sub_use_byarena(m)) = nanmean(temp);
        end
    end
end

stat_use.all = all_out; % Aggregates all the correlations into one array
stat_use.all_out2 = all_out2; % separates the correlations out to match sub_use
stat_use.all_means = all_means; % Means of all the correlations - corresponds to sub_use
stat_use.mean = nanmean(all_out);
stat_use.sem = nanstd(all_out)/sqrt(num_comparisons); % Don't think this is valid stats...

end

%% sub-fuction to get correlations out and calculate mean/sem
function [stat_use] = calc_PV_group_stats(animal_struct, sub_use, local_flag, metric_type)
% local_flag: 1 = use distal aligned comparisons, 2 = use local aligned
% comparisons, metric_type = 'PV_corr' (default) or PV_dist'

% If not specified, pull from PV_corr
if nargin < 4
    metric_type = 'PV_corr';
end

all_out = [];
all_out2 = cell(size(sub_use,1),1);
all_means = nan(size(sub_use,1),1);
temp = [];
num_comparisons = size(sub_use,1);
for k = 1:length(animal_struct)
    for arena_use = 1:2
        sub_use_byarena = find(arena_use == sub_use(:,1)); % Pull-out subs for appropriate arena
        for m = 1:length(sub_use_byarena)

            temp = squeeze(animal_struct(k).PV_corrs2{local_flag,arena_use}.(metric_type)(...
                sub_use(sub_use_byarena(m),2),sub_use(sub_use_byarena(m),3),:)); % Get appropriate correlations indicate in sub_use
            all_out = [all_out; temp]; % Add appropriate comparisons into temp_out
            all_out2{sub_use_byarena(m)} = temp;
            all_means(sub_use_byarena(m)) = nanmean(temp);
        end
    end
end

stat_use.all = all_out; % Aggregates all the correlations into one array
stat_use.all_out2 = all_out2; % separates the correlations out to match sub_use
stat_use.all_means = all_means; % Means of all the correlations - corresponds to sub_use
stat_use.mean = nanmean(all_out);
stat_use.sem = nanstd(all_out)/sqrt(num_comparisons); % Don't think this is valid stats...

end

%% sub-function to get shuffled correlations out

function [stat_use] = calc_group_shuffled_stats(animal_struct, sub_use, local_flag, metric_type)
% local_flag: 1 = use distal aligned comparisons, 2 = use local aligned
% comparisons, metric_type = 'shuffle_matrix' (default) or dist_shuffle_matrix'

% If not specified, pull from corr_matrix
if nargin < 4
    metric_type = 'shuffle_matrix';
end

all_out = [];
all_out2 = cell(size(sub_use,1),1);
all_means = nan(size(sub_use,1),1);
temp = [];
num_comparisons = size(sub_use,1);
for k = 1:length(animal_struct)
    for arena_use = 1:2
        sub_use_byarena = find(arena_use == sub_use(:,1)); % Pull-out subs for appropriate arena
        for m = 1:length(sub_use_byarena)
            temp = animal_struct(k).(metric_type){local_flag,arena_use}(:,...
                sub_use(sub_use_byarena(m),2),sub_use(sub_use_byarena(m),3),:); % Get appropriate correlations
            all_out = [all_out; temp(:)]; % Add appropriate comparisons into temp_out
            all_out2{sub_use_byarena(m)} = temp(:);
            all_means(sub_use_byarena(m)) = nanmean(temp(:));
        end
    end
end

stat_use.all = all_out; % Aggregates all the correlations into one array
stat_use.all_out2 = all_out2; % separates the correlations out to match sub_use
stat_use.all_means = all_means; % Means of all the correlations - corresponds to sub_use
stat_use.mean = nanmean(all_out);
stat_use.sem = nanstd(all_out)/sqrt(num_comparisons); % Don't think this is valid stats...

end

%% sub-function to get shuffled correlations out

function [stat_use] = calc_PV_group_shuffled_stats(animal_struct, sub_use, local_flag, metric_type)
% local_flag: 1 = use distal aligned comparisons, 2 = use local aligned
% comparisons, metric_type = 'PV_corr_shuffle_mean' (default) or
% 'PV_dist_shuffle_mean'

% If not specified, pull from corr_matrix
if nargin < 4
    metric_type = 'PV_corr_shuffle_mean';
end

all_out = [];
all_out2 = cell(size(sub_use,1),1);
all_means = nan(size(sub_use,1),1);
temp = [];
num_comparisons = size(sub_use,1);
for k = 1:length(animal_struct)
    for arena_use = 1:2
        sub_use_byarena = find(arena_use == sub_use(:,1)); % Pull-out subs for appropriate arena
        for m = 1:length(sub_use_byarena)
            temp = squeeze(animal_struct(k).PV_corrs2{local_flag,arena_use}.(metric_type)(...
                sub_use(sub_use_byarena(m),2),sub_use(sub_use_byarena(m),3),:)); % Get appropriate correlations
            all_out = [all_out; temp(:)]; % Add appropriate comparisons into temp_out
            all_out2{sub_use_byarena(m)} = temp(:);
            all_means(sub_use_byarena(m)) = nanmean(temp(:));
        end
    end
end

stat_use.all = all_out; % Aggregates all the correlations into one array
stat_use.all_out2 = all_out2; % separates the correlations out to match sub_use
stat_use.all_means = all_means; % Means of all the correlations - corresponds to sub_use
stat_use.mean = nanmean(all_out);
stat_use.sem = nanstd(all_out)/sqrt(num_comparisons); % Don't think this is valid stats...

end
