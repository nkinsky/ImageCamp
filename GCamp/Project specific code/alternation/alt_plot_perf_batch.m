function [perf_plot, hf_lc ] = alt_plot_perf_batch(MD, varargin)
% perf_by_day = alt_plot_perf_batch(MD, ... )
%   window default = 10 trial smoothing. Automatically omits files with
%   "looping" or "forced" from plotting in the learning curves. See
%   function for parameters.
%   

%% Set up variables and get learning data
ip = inputParser;
ip.addRequired('MD', @isstruct);
ip.addParameter('window', 10, @(a) round(a) == a && a >= 1); % smoothing window for daily perf
ip.addParameter('legend_flag', true, @islogical); %plot legend
ip.addParameter('lc_smooth_window', nan, @(a) isnan(a) || ...
    round(a) == a && a > 1); % smoothing window for learning curves, nan = don't plot smoothed
ip.addParameter('crit', 70, @(a) a > 0 && a < 100); % performance criteria
ip.parse(MD, varargin{:});
window = ip.Results.window;
legend_flag = ip.Results.legend_flag;
lc_smooth_window = ip.Results.lc_smooth_window;
crit = ip.Results.crit;

num_sessions = length(MD);
[perf_calc, perf_notes, perf_by_trial] = alt_get_perf(MD);

%% Identify Looping or Forced Alternation Sessions
MD = complete_MD(MD); % Add in all data if not there already
omit_lc = ~alt_get_sesh_type(MD);

%% Plot
figure;
% Plot daily curves for all sessions
for j = 1:num_sessions
   ha = subplot_auto(num_sessions + 1,j);
   try
       alt_plot_perf(logical(perf_by_trial{j}), 'ha', ha, 'window', window,...
           'learning', omit_lc(j), 'legend_flag', legend_flag);
   catch
       text(0.1, 0.5, 'No trial-by-trial data for this session')
       axis off  
   end
   title([num2str(j) ' - ' mouse_name_title(MD(j).Date)])
end

% now plot learning curves
for j = 1:2
    %%
    if j == 1
        subplot_auto(num_sessions + 1,num_sessions + 1);
    elseif j == 2
        hf_lc = figure; set(gcf, 'Position', [2340, 190, 870, 520])
    end

    perf_plot = 100*nanmean([perf_calc, perf_notes],2);
    sessions_plot = find(~omit_lc);
    hact = plot(sessions_plot, perf_plot(~omit_lc),'o-');
    hold on; 
    hcrit = plot([0.5, num_sessions + 0.5], [crit crit],'r--');
    if ~isnan(lc_smooth_window)
        hsm = plot(sessions_plot, movmean(perf_plot(~omit_lc), ...
            lc_smooth_window, 'Endpoints','shrink'), 'g-.');
        legend(cat(1,hact,hsm,hcrit),{'Actual',['Smoothed ' ...
            num2str(lc_smooth_window)], 'Criteria'})
    else
        legend(hcrit,'Criteria')
    end
    xlim([0.5, num_sessions + 0.5]); ylim([50 90]);
    xlabel('Days'); ylabel('Performance')
    title(mouse_name_title(MD(1).Animal))
    make_plot_pretty(gca)
    %%
    
end

end

