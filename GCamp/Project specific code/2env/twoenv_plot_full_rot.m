function [h] = twoenv_plot_full_rot( corr_means, rot_array, gr_remap_log, varargin )
% hfig = twoenv_plot_full_rot( corr_means, rot_array, gr_remap_log, varargin )
%   Overlays all tuning curves from twoenv_rot_analysis_full on top of one
%   another.  gr_remap_log is output from twoenv_batch_analysis4
%   .remapping_type.global.(circle/square/circ2square).  Circles are corrs
%   for a given coherent comparison.  Xs are global remapping sessions.


ip = inputParser;
ip.addRequired('corr_means',@isnumeric);
ip.addRequired('rot_array', @isnumeric);
ip.addRequired('gr_remap_log', @(a) islogical(a) || isnumeric(a));
ip.addParameter('h', nan, @ishandle);
ip.addParameter('CI', [], @isnumeric);
ip.parse(corr_means, rot_array, gr_remap_log, varargin{:});

h = ip.Results.h;
CI = ip.Results.CI;

if ~ishandle(h)
    h = figure;
end

[gc_i, gc_j] = find(~isnan(nanmean(corr_means,3))); % Identify all good comparisons
num_comps = length(gc_i);
%% Plot out curves on top of one another
figure(h);
set(gcf,'Position', [2400 200 1000 600]);
% hold off; 
plot_dot = {'ko','rx'};
n_coh = 0;
n_gr = 0;
for j = 1:num_comps
        row = gc_i(j);
        col = gc_j(j);
        corr_means_use = squeeze(corr_means(row,col,:))';
        
        % Get best angle and correlation at that angle
        [corr_at_best, idx] = max(corr_means_use);
        best_angle = rot_array(idx);
        
        remap_type = gr_remap_log(row,col);
        
        plot([rot_array, 360], [corr_means_use corr_means_use(1)],...
            'color', [0.7 0.7 0.7 0.5]);
        hold on;
        hl_temp = plot(best_angle, corr_at_best, plot_dot{remap_type + 1}, ...
            'LineWidth',2);
        if remap_type == 0
            hl(1) = hl_temp;
            n_coh = n_coh + 1;
        elseif remap_type == 1
            hl(2) = hl_temp;
            n_gr = n_gr + 1;
        end
        
end

CI_means = squeeze(nanmean(nanmean(CI,1),2)); % Hack to get ~CI - mean of all CIs..
hl(3:4) = plot([rot_array,360],[CI_means CI_means(:,1)], 'color', [0.2 0 0.7 0.8]);
hl(5) = plot([rot_array,360],[mean(CI_means,1) mean(CI_means(:,1),1)], ...
    'color', [0.2 0 0.7 0.8], 'LineStyle', ':');
% hold off

set(gca,'XTick',[0:90:360]);
xlabel('Local Cue Mismatch');
ylabel('Mean Correlation')
hl_use = hl(1:2); legend_use = {'Coherent','Global Remap'};
legend(hl_use([n_coh, n_gr] > 0), legend_use([n_coh, n_gr] > 0))
xlim([-10 370])

end

