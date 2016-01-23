function [ ] = plot_simplified_summary(local_stat, distal_stat, varargin )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% figure(110)
% set(gcf,'Position',[1988 286 1070 477])

%% Colors for bars
bar_colors = {'b','y','r'};

%%
error_on = 1; % default
plot_shuffle = 0; % default
both_stat = local_stat; % Faked variable here, not used in actual plots
plot_both_stat = 0; % default
for j = 1:length(varargin)
   if strcmpi(varargin{j},'error_on')
       error_on = varargin{j+1};
   elseif strcmpi(varargin{j},'plot_shuffle')
       plot_shuffle = varargin{j+1};   
   elseif strcmpi(varargin{j},'both_stat')
       both_stat = varargin{j+1};
       plot_both_stat = 1;
   end
end

%% Parse out variables for below

[separate_win_local_mean, separate_win_local_sem] = parse_stat_vars(local_stat.separate_win);
[separate_win_distal_mean, separate_win_distal_sem] = parse_stat_vars(distal_stat.separate_win);
[separate_win_both_mean, separate_win_both_sem] = parse_stat_vars(both_stat.separate_win);

[sep_conn1_local_mean, sep_conn1_local_sem] = parse_stat_vars(local_stat.sep_conn1);
[sep_conn1_distal_mean, sep_conn1_distal_sem] = parse_stat_vars(distal_stat.sep_conn1);
[sep_conn1_both_mean, sep_conn1_both_sem] = parse_stat_vars(both_stat.sep_conn1);

[sep_conn2_local_mean, sep_conn2_local_sem] = parse_stat_vars(local_stat.sep_conn2);
[sep_conn2_distal_mean, sep_conn2_distal_sem] = parse_stat_vars(distal_stat.sep_conn2);
[sep_conn2_both_mean, sep_conn2_both_sem] = parse_stat_vars(both_stat.sep_conn2);

[before_after_local_mean, before_after_local_sem] = parse_stat_vars(local_stat.before_after);
[before_after_distal_mean, before_after_distal_sem] = parse_stat_vars(distal_stat.before_after);
[before_after_both_mean, before_after_both_sem] = parse_stat_vars(both_stat.before_after);

% separate_win_local_mean = local_stat.separate_win.mean;
% separate_win_distal_mean = distal_stat.separate_win.mean;
% separate_win_both_mean = both_stat.separate_win.mean;
% separate_win_local_sem = local_stat.separate_win.sem;
% separate_win_distal_sem = distal_stat.separate_win.sem;
% separate_win_both_sem = both_stat.separate_win.sem;

% sep_conn1_local_mean = local_stat.sep_conn1.mean;
% sep_conn1_distal_mean = distal_stat.sep_conn1.mean;
% sep_conn1_both_mean = both_stat.sep_conn1.mean;
% sep_conn1_local_sem = local_stat.sep_conn1.sem;
% sep_conn1_distal_sem = distal_stat.sep_conn1.sem;
% sep_conn1_both_sem = both_stat.sep_conn1.sem;
% 
% sep_conn2_local_mean = local_stat.sep_conn2.mean;
% sep_conn2_distal_mean = distal_stat.sep_conn2.mean;
% sep_conn2_both_mean = both_stat.sep_conn2.mean;
% sep_conn2_local_sem = local_stat.sep_conn2.sem;
% sep_conn2_distal_sem = distal_stat.sep_conn2.sem;
% sep_conn2_both_sem = both_stat.sep_conn2.sem;
% 
% before_after_local_mean = local_stat.before_after.mean;
% before_after_distal_mean = distal_stat.before_after.mean;
% before_after_both_mean = both_stat.before_after.mean;
% before_after_local_sem = local_stat.before_after.sem;
% before_after_distal_sem = distal_stat.before_after.sem;
% before_after_both_sem = both_stat.before_after.sem;

%% Plot stuff
if plot_both_stat == 0
    h = bar([separate_win_local_mean, separate_win_distal_mean;  ...
        sep_conn1_local_mean, sep_conn1_distal_mean; sep_conn2_local_mean, sep_conn2_distal_mean;...
        before_after_local_mean, before_after_distal_mean]);
    h(1).FaceColor = bar_colors{1};
    h(2).FaceColor = bar_colors{2};
elseif plot_both_stat == 1
    h = bar([separate_win_local_mean, separate_win_distal_mean, separate_win_both_mean;  ...
        sep_conn1_local_mean, sep_conn1_distal_mean sep_conn1_both_mean; ...
        sep_conn2_local_mean, sep_conn2_distal_mean, sep_conn2_both_mean;...
        before_after_local_mean, before_after_distal_mean, before_after_both_mean]);
    h(1).FaceColor = bar_colors{1};
    h(2).FaceColor = bar_colors{2};
    h(3).FaceColor = bar_colors{3};
end
hold on
if error_on == 1
    errorbar(h(1).XData + h(1).XOffset, [separate_win_local_mean, ...
        sep_conn1_local_mean, sep_conn2_local_mean, before_after_local_mean], [separate_win_local_sem, ...
        sep_conn1_local_sem, sep_conn2_local_sem, before_after_local_sem],'k.')
    errorbar(h(2).XData + h(2).XOffset, [separate_win_distal_mean, ...
        sep_conn1_distal_mean, sep_conn2_distal_mean, before_after_distal_mean], [separate_win_distal_sem, ...
        sep_conn1_distal_sem, sep_conn2_distal_sem, before_after_distal_sem],'k.')
    if plot_both_stat == 1
       errorbar(h(3).XData + h(3).XOffset, [separate_win_both_mean, ...
        sep_conn1_both_mean, sep_conn2_both_mean, before_after_both_mean], [separate_win_both_sem, ...
        sep_conn1_both_sem, sep_conn2_both_sem, before_after_both_sem],'k.') 
    end
end

if plot_shuffle == 1
        h2 = plot(get(gca,'XLim'),[shuffle_mean shuffle_mean],'r--');
    if plot_both_stat == 0
        h_legend = legend([h(1) h(2) h2],'Local cues aligned','Distal cues aligned','Chance (Shuffled Data)');
    elseif plot_both_stat == 1
        h_legend = legend([h(1) h(2) h(3) h2],'Local cues aligned','Distal cues aligned','Both aligned','Chance (Shuffled Data)');
    end
else
    if plot_both_stat == 0
        h_legend = legend([h(1) h(2)],'Local cues aligned','Distal cues aligned');
    elseif plot_both_stat == 1
        h_legend = legend([h(1) h(2) h(3)],'Local cues aligned','Distal cues aligned', 'Both aligned');
    end
end
set(gca,'XTickLabel',{'Separate','Separate - Connected Day 1',...
    'Separate - Connected Day 2','Before - After'})
ylabel('Transient Map Mean Correlations - Individual Neurons')
hold off
ylims_given = get(gca,'YLim');

end

%% sub-function
function [stat_out_mean, stat_out_sem] = parse_stat_vars(stat_var_in)
%%
if ~isempty(stat_var_in)
    stat_out_mean = stat_var_in.mean;
    stat_out_sem = stat_var_in.sem;
else
    stat_out_mean = nan;
    stat_out_sem = nan;
end
%%

end


