function [ ] = alt_plot_perf_batch(MD, window, legend_flag)
% alt_plot_perf_batch(MD, window, lc_omit )
%   window default = 10 trial smoothing. Automatically omits files with
%   "looping" or "forced" from plotting in the learning curves
%   

%% Set up variables and get learning data
if nargin < 3
    legend_flag = true;
    if nargin < 2
        window = 10;
    end
end
crit = 70; % Our performance criteria

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
   alt_plot_perf(logical(perf_by_trial{j}), 'ha', ha, 'window', window,...
       'learning', omit_lc(j), 'legend_flag', legend_flag);
   title([num2str(j) ' - ' mouse_name_title(MD(j).Date)])
end

% now plot learning curves
subplot_auto(num_sessions + 1,num_sessions + 1);
perf_plot = 100*nanmean([perf_calc, perf_notes],2);
sessions_plot = find(~omit_lc);
plot(sessions_plot, perf_plot(~omit_lc),'.-')
hold on; plot([0.5, num_sessions + 0.5], [crit crit],'r--')
xlim([0.5, num_sessions + 0.5]); ylim([-20 120]);
xlabel('Days'); ylabel('Performance')
title(mouse_name_title(MD(1).Animal))
make_plot_pretty(gca)

end

