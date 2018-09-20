function [ ha ] = alt_plot_perf(perf_bool, varargin )
% ha = alt_plot_perf(perf_bool, varargin )
%   Plots performance for each trial indicated in perf_bool with a 10 trial
%   moving average window. Can specify 'window' (10 = default) and 'ha' (axes to plot
%   into) as parameters.  if no ha specified, creates a new figure;

ip = inputParser;
ip.addRequired('perf_bool', @(a) all(islogical(a)));
ip.addParameter('window', 10, @(a) a > 0 && round(a) == a);
ip.addParameter('ha', gca, @ishandle);
ip.addParameter('legend_flag', true, @islogical)
ip.addParameter('criteria', 75, @(a) a >= 0 & a <=100)
ip.addParameter('learning', false, @islogical);
ip.parse(perf_bool,varargin{:});
window = ip.Results.window;
ha = ip.Results.ha;
legend_flag = ip.Results.legend_flag;
criteria = ip.Results.criteria;
learning = ip.Results.learning;
% Identify if new figure window was opened
new_fig = ~any(cellfun(@(a) all(ishandle(a)), varargin)) & length(get(groot,'Children')) == 1;
if new_fig % Set to nice size if a new figure
    set(gcf,'Position',[780 460 800 380])
end

xlims = [0 length(perf_bool) + 1];
ylims = [-20 120];
axes(ha);
h(1) = plot(100*perf_bool,'*'); 
hold on; 
h(2) = plot(100*movmean(perf_bool,window),'-');
h(3) = plot([0 length(perf_bool) + 1],[criteria, criteria], 'r--');
xlim(xlims); ylim(ylims); 
if legend_flag
    legend(h,{'Ind. Trials', [num2str(window) ' Trial Mov. Avg'],...
        'Criteria'});
end
xlabel('Trial #')
ylabel('Performance')
make_plot_pretty(gca)

% plot an X through it if learning for easy viewing later
if learning
    plot(xlims,ylims,'k-.',xlims,[ylims(2) ylims(1)],'k-.')
end

end

