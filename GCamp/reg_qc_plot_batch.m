function [reg_stats] = reg_qc_plot_batch(base, reg, varargin)
% reg_stats = reg_qc_plot_batch(base, reg, num_shuffles (opt), num_shifts(opt), shift_dist(opt), ...)
% Default is 100 shuffles, 10 shifts, and 4 pixel shift
%%% NRK 1) need to update this for including batch map with ALL masks
%%% included!!!
% 2) Eliminate average correlation.  Make plotting centroid_angle an option
% in a second graph (or do it automatically?)
% 3) Add this into the end of neuron_reg_batch


%% Parse inputs
p = inputParser;
p.addRequired('base', @isstruct);
p.addRequired('reg', @isstruct);
p.addOptional('num_shuffles', 100, @(a) isnumeric(a) && round(a) == a && a > 0);
p.addOptional('num_shifts', 0, @(a) isnumeric(a) && round(a) == a && a >= 0);
p.addOptional('shift_dist', 4, @(a) isnumeric(a) && a > 0);
p.addParameter('batch_mode',0, @(a) a == 0 || a == 1 || a == 2);
p.addParameter('name_append','',@ischar);
p.parse(base, reg, varargin{:});

num_shuffles = p.Results.num_shuffles;
num_shifts = p.Results.num_shifts; 
shift_dist = p.Results.shift_dist;
batch_mode = p.Results.batch_mode;
name_append = p.Results.name_append;

if length(reg) > 1
    multi_sesh = 1;
else
    multi_sesh = 0;
end

%% Plot

h = figure;

reg_stats = cell(length(reg),1);
legend_text = cell(1, length(reg));

reg_stats{1} = neuron_reg_qc(base, reg(1), 'batch_mode', batch_mode, ...
    'shuffle', num_shuffles, 'shift', num_shifts, 'shift_dist', shift_dist, ...'
    'name_append', name_append); % If the last registration is bad you can get a bad shuffled distribution here...
legend_text{1} = [mouse_name_title(reg(1).Date) ' - #' num2str(reg(1).Session)];
reg_qc_plot(reg_stats{1}.cent_d, reg_stats{1}.orient_diff, ...
        reg_stats{1}.avg_corr, h, 'multi_sesh', multi_sesh);

for j = 2:length(reg)
    
    reg_stats{j} = neuron_reg_qc(base, reg(j), 'batch_mode', batch_mode,...
        'name_append', name_append);
    reg_qc_plot(reg_stats{j}.cent_d, reg_stats{j}.orient_diff, ...
        reg_stats{j}.avg_corr, h, 'multi_sesh', 1);
    legend_text{j} = [mouse_name_title(reg(j).Date) ' - #' num2str(reg(j).Session)];
    reg_stats{j}.session = reg(j);
end

% reg_stats{length(reg)} = neuron_reg_qc(base, reg(end), 'batch_mode', batch_mode, ...
%     'shuffle', num_shuffles, 'shift', num_shifts, 'shift_dist', shift_dist, ...'
%     'name_append', name_append); % If the last registration is bad you can get a bad shuffled distribution here...
% legend_text{length(reg)} = [mouse_name_title(reg(end).Date) ' - #' num2str(reg(end).Session)];
% reg_qc_plot(reg_stats{end}.cent_d, reg_stats{end}.orient_diff, ...
%         reg_stats{end}.avg_corr, h, 'multi_sesh', multi_sesh);
    
reg_qc_plot(reg_stats{1}.shift.cent_d, reg_stats{1}.shift.orient_diff, ...
    reg_stats{1}.shift.avg_corr, h, 'plot_shuf', 1);
reg_qc_plot([], reg_stats{1}.shuffle.orient_diff, [], h, 'plot_shuf', 1);

for j=1:4
    subplot(2,2,j)
    if num_shifts > 0
        legend(legend_text{:}, [num2str(round(shift_dist)) '-pixel shift'])
    else
        legend(legend_text{:})
    end
end

if num_shuffles > 0
    subplot(2,2,2)
    legend(updatelegend(gca,'Shuffled'));
    subplot(2,2,4)
    legend(updatelegend(gca,'Shuffled'));
end

end

%% Update legend string
function [legend_str] = updatelegend(ax, update_str)

temp = get(ax,'Legend');
legend_str = cat(2, temp.String, update_str);

end

