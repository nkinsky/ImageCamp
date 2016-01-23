function [ combined_stat ] = twoenv_combine_stats(align_type, varargin)
% combined_stat = twoenv_combine_stats(stat_type, varargin)
%
%   align_type is the type of alignment you wish to look at (distal
%   aligned, local aligned, both aligned)
%   
%   varargin is a list of all the mice you want to include

comparison_type = {'separate_win','sep_conn1','sep_conn2','before_after'};

for k = 1:length(comparison_type)
    combined_stat.(comparison_type{k}).all = []; % Pre-allocate
    combined_stat.(comparison_type{k}).all_means = []; % Pre-allocate
    for j = 1:length(varargin)
        % Gets the stats for the appropriate alignment and comparison type
        stats_use = varargin{j}.(align_type).(comparison_type{k});
        
        % Combine the 'all' and 'all_means' fields.  
        if ~isempty(stats_use)
            combined_stat.(comparison_type{k}).all = cat(1, ...
                combined_stat.(comparison_type{k}).all, stats_use.all);
            combined_stat.(comparison_type{k}).all_means = cat(1,...
                combined_stat.(comparison_type{k}).all_means, stats_use.all_means);
        end

    end
    
    % Get mean, sem, and std
    num_samples = length(combined_stat.(comparison_type{k}).all_means);
    combined_stat.(comparison_type{k}).mean = mean(...
        combined_stat.(comparison_type{k}).all_means);
    combined_stat.(comparison_type{k}).sem = std(...
        combined_stat.(comparison_type{k}).all_means)/sqrt(num_samples);
    combined_stat.(comparison_type{k}).mean_all = nanmean(...
        combined_stat.(comparison_type{k}).all);
    combined_stat.(comparison_type{k}).std_all = nanstd(...
        combined_stat.(comparison_type{k}).all);
end

end

