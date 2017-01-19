function [reg_stats] = reg_qc_plot_batch(base, reg)
%%% NRK -2)  need to update this for including batch map with ALL masks
%%% included!!!
% 2) Need to make # shuffles an input


h = figure;

reg_stats = cell(length(reg),1);
legend_text = cell(1, length(reg));
for j = 1:length(reg)-1
    
    reg_stats{j} = neuron_reg_qc(base,reg(j));
    reg_qc_plot(reg_stats{j}.cent_d, reg_stats{j}.orient_diff, ...
        reg_stats{j}.avg_corr,h);
    legend_text{j} = [mouse_name_title(reg(j).Date) ' - #' num2str(reg(j).Session)];
    reg_stats{j}.session = reg(j);
end
reg_stats{length(reg)} = neuron_reg_qc(base, reg(end), 'shuffle',10, 'shift', 100);
legend_text{length(reg)} = [mouse_name_title(reg(end).Date) ' - #' num2str(reg(end).Session)];
reg_qc_plot(reg_stats{end}.cent_d, reg_stats{end}.orient_diff, ...
        reg_stats{end}.avg_corr,h);
    
reg_qc_plot(reg_stats{end}.shift.cent_d, reg_stats{end}.shift.orient_diff, ...
    reg_stats{end}.shift.avg_corr, h, 'plot_shuf', 1);
reg_qc_plot([], reg_stats{end}.shuffle.orient_diff, [], h, 'plot_shuf', 1);

subplot(2,2,1)
legend(legend_text{:},'shift')

subplot(2,2,2)
legend(legend_text{:},'shuffled')

subplot(2,2,3)
legend(legend_text{:},'shift')

end

