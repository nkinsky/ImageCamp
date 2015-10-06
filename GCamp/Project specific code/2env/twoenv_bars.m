function [ ] = twoenv_bars( mega_mean, shuffle_comb, num_active,h_use )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    h_use = [];
end
%% Get basic stats - not done for population correlations yet

% Better way to do things in the future is to get values for ALL neuron correlations in
% each session and group them together somehow after classifying them due
% to the various comparisons below
mean_simple_norot = mean(mega_mean(1).matrix,3);
mean_simple_rot = mean(mega_mean(2).matrix,3);
if isnan(sum(mean_simple_rot(:))) || isnan(sum(mean_simple_norot(:)))
    disp('Note - some sessions have NO good correlations due to not meeting the threshold - be sure to check!')
    mean_simple_norot = nanmean(mega_mean(1).matrix,3);
    mean_simple_rot = nanmean(mega_mean(2).matrix,3);
end

% Population Simple Means
% mean_simple_pop_norot = mean(mega_mean(1).pop_matrix,3);
% mean_simple_pop_rot = mean(mega_mean(2).pop_matrix,3);

% Shuffled Simple means
mean_shuffle_simple = nanmean(squeeze(nanmean(shuffle_comb,1)),3);
shuffle_mean = nanmean(shuffle_comb(:));

% Indices for various comparisons - wow, that's a lot of work
before_win = [1 2 ; 1 3; 1 4; 2 3; 2 4; 3 4]; before_win_ind = sub2ind([8 8],before_win(:,1), before_win(:,2));
before_win_norot = [1 2; 1 4; 2 4; 3 4]; before_win_norot_ind = sub2ind([8 8],before_win(:,1), before_win(:,2));
after_win = [7 8]; after_win_ind = sub2ind([8 8],after_win(:,1), after_win(:,2));
after_win_norot = [7 8]; after_win_norot_ind = sub2ind([8 8],after_win_norot(:,1), after_win_norot(:,2));
before_after = [1 7; 2 7; 3 7; 4 7; 1 8; 2 8 ;3 8; 4 8]; before_after_ind = sub2ind([8 8],before_after(:,1), before_after(:,2));
before_after_norot = [2 7; 4 7; 1 8; 2 8 ; 3 8]; before_after_norot_ind = sub2ind([8 8],before_after_norot(:,1), before_after_norot(:,2));
before_5 = [1 5; 2 5; 3 5; 4 5]; before_5_ind = sub2ind([8 8],before_5(:,1), before_5(:,2));
before_5_norot = [2 5; 4 5]; before_5_norot_ind = sub2ind([8 8],before_5_norot(:,1), before_5_norot(:,2));
before_6 = [1 6; 2 6 ; 3 6; 4 6]; before_6_ind = sub2ind([8 8],before_6(:,1), before_6(:,2));
before_6_norot = [1 6; 2 6; 3 6; 4 6]; before_6_norot_ind = sub2ind([8 8],before_6_norot(:,1), before_6_norot(:,2));
after_5 = [5 7; 5 8]; after_5_ind = sub2ind([8 8],after_5(:,1), after_5(:,2));
after_5_norot = [5 8]; after_5_norot_ind = sub2ind([8 8],after_5_norot(:,1), after_5_norot(:,2));
after_6 = [6 7; 6 8]; after_6_ind = sub2ind([8 8],after_6(:,1), after_6(:,2));
after_6_norot = [6 7; 6 8]; after_6_norot_ind = sub2ind([8 8],after_6_norot(:,1), after_6_norot(:,2));

% Mean of individual correlations
before_win_mean = mean(mean_simple_rot(before_win_ind));
before_win_sem = std(mean_simple_rot(before_win_ind))/sqrt(length(before_win_ind));
before_win_norot_mean = mean(mean_simple_norot(before_win_norot_ind));
before_win_norot_sem = std(mean_simple_norot(before_win_norot_ind))/sqrt(length(before_win_norot_ind));
before_win_shuffle_mean = mean(mean_shuffle_simple(before_win_ind));
before_win_shuffle_sem = std(mean_shuffle_simple(before_win_ind))/sqrt(length(before_win_ind));

before_after_mean = mean(mean_simple_rot(before_after_ind));
before_after_sem = std(mean_simple_rot(before_after_ind))/sqrt(length(before_after_ind));
before_after_norot_mean = mean(mean_simple_norot(before_after_norot_ind));
before_after_norot_sem = std(mean_simple_norot(before_after_norot_ind))/sqrt(length(before_after_norot_ind));
before_after_shuffle_mean = mean(mean_shuffle_simple(before_after_ind));
before_after_shuffle_sem = std(mean_shuffle_simple(before_after_ind))/sqrt(length(before_after_ind));

before_5_mean = mean(mean_simple_rot(before_5_ind));
before_5_sem = std(mean_simple_rot(before_5_ind))/sqrt(length(before_5_ind));
before_5_norot_mean = mean(mean_simple_norot(before_5_norot_ind));
before_5_norot_sem = std(mean_simple_norot(before_5_norot_ind))/sqrt(length(before_5_norot_ind));
before_5_shuffle_mean = mean(mean_shuffle_simple(before_5_ind));
before_5_shuffle_sem = std(mean_shuffle_simple(before_5_ind))/sqrt(length(before_5_ind));

before_6_mean = mean(mean_simple_rot(before_6_ind));
before_6_sem = std(mean_simple_rot(before_6_ind))/sqrt(length(before_6_ind));
before_6_norot_mean = mean(mean_simple_norot(before_6_norot_ind));
before_6_norot_sem = std(mean_simple_norot(before_6_norot_ind))/sqrt(length(before_6_norot_ind));
before_6_shuffle_mean = mean(mean_shuffle_simple(before_6_ind));
before_6_shuffle_sem = std(mean_shuffle_simple(before_6_ind))/sqrt(length(before_6_ind));

after_5_mean = mean(mean_simple_rot(after_5_ind));
after_5_sem = std(mean_simple_rot(after_5_ind))/sqrt(length(after_5_ind));
after_5_norot_mean = mean(mean_simple_norot(after_5_norot_ind));
after_5_norot_sem = std(mean_simple_norot(after_5_norot_ind))/sqrt(length(after_5_norot_ind));
after_5_norot_sem = after_5_sem; % Fake it for now...only have one sample currently
after_5_shuffle_mean = mean(mean_shuffle_simple(after_5_ind));
after_5_shuffle_sem = std(mean_shuffle_simple(after_5_ind))/sqrt(length(after_5_ind));

after_6_mean = mean(mean_simple_rot(after_6_ind));
after_6_sem = std(mean_simple_rot(after_6_ind))/sqrt(length(after_6_ind));
after_6_norot_mean = mean(mean_simple_norot(after_6_norot_ind));
after_6_norot_sem = std(mean_simple_norot(after_6_norot_ind))/sqrt(length(after_6_norot_ind));
after_6_shuffle_mean = mean(mean_shuffle_simple(after_6_ind));
after_6_shuffle_sem = std(mean_shuffle_simple(after_6_ind))/sqrt(length(after_6_ind));

% Mean of population correlations
% pop_before_win_mean = mean(mean_simple_pop_rot(before_win_ind));
% pop_before_win_sem = std(mean_simple_pop_rot(before_win_ind))/sqrt(length(before_win_ind));
% pop_before_win_norot_mean = mean(mean_simple_pop_norot(before_win_norot_ind));
% pop_before_win_norot_sem = std(mean_simple_pop_norot(before_win_norot_ind))/sqrt(length(before_win_norot_ind));
% 
% pop_before_after_mean = mean(mean_simple_pop_rot(before_after_ind));
% pop_before_after_sem = std(mean_simple_pop_rot(before_after_ind))/sqrt(length(before_after_ind));
% pop_before_after_norot_mean = mean(mean_simple_pop_norot(before_after_norot_ind));
% pop_before_after_norot_sem = std(mean_simple_pop_norot(before_after_norot_ind))/sqrt(length(before_after_norot_ind));
% 
% pop_before_5_mean = mean(mean_simple_pop_rot(before_5_ind));
% pop_before_5_sem = std(mean_simple_pop_rot(before_5_ind))/sqrt(length(before_5_ind));
% pop_before_5_norot_mean = mean(mean_simple_pop_norot(before_5_norot_ind));
% pop_before_5_norot_sem = std(mean_simple_pop_norot(before_5_norot_ind))/sqrt(length(before_5_norot_ind));
% 
% pop_before_6_mean = mean(mean_simple_pop_rot(before_6_ind));
% pop_before_6_sem = std(mean_simple_pop_rot(before_6_ind))/sqrt(length(before_6_ind));
% pop_before_6_norot_mean = mean(mean_simple_pop_norot(before_6_norot_ind));
% pop_before_6_norot_sem = std(mean_simple_pop_norot(before_6_norot_ind))/sqrt(length(before_6_norot_ind));
% 
% pop_after_5_mean = mean(mean_simple_pop_rot(after_5_ind));
% pop_after_5_sem = std(mean_simple_pop_rot(after_5_ind))/sqrt(length(after_5_ind));
% pop_after_5_norot_mean = mean(mean_simple_pop_norot(after_5_norot_ind));
% pop_after_5_norot_sem = std(mean_simple_pop_norot(after_5_norot_ind))/sqrt(length(after_5_norot_ind));
% pop_after_5_norot_sem = pop_after_5_sem; % Fake it for now...only have one sample currently
% 
% pop_after_6_mean = mean(mean_simple_pop_rot(after_6_ind));
% pop_after_6_sem = std(mean_simple_pop_rot(after_6_ind))/sqrt(length(after_6_ind));
% pop_after_6_norot_mean = mean(mean_simple_pop_norot(after_6_norot_ind));
% pop_after_6_norot_sem = std(mean_simple_pop_norot(after_6_norot_ind))/sqrt(length(after_6_norot_ind));

%% Plot individual neuron means

if isempty(h_use)
    figure
else
    figure(h_use)
end
h = bar([before_win_mean, before_win_norot_mean; before_after_mean, before_after_norot_mean; ...
    before_5_mean, before_5_norot_mean; after_5_mean, after_5_norot_mean; ...
    before_6_mean, before_6_norot_mean; after_6_mean, after_6_norot_mean]);
hold on
errorbar(h(1).XData + h(1).XOffset, [before_win_mean, before_after_mean, ...
    before_5_mean, after_5_mean, before_6_mean, after_6_mean], [before_win_sem, ...
    before_after_sem, before_5_sem, after_5_sem, before_6_sem, after_6_sem],...
    '.')
errorbar(h(2).XData + h(2).XOffset, [before_win_norot_mean, before_after_norot_mean, ...
    before_5_norot_mean, after_5_norot_mean, before_6_norot_mean, after_6_norot_mean], [before_win_norot_sem, ...
    before_after_norot_sem, before_5_norot_sem, after_5_norot_sem, before_6_norot_sem, after_6_norot_sem],...
    '.')
h2 = plot(get(gca,'XLim'),[shuffle_mean shuffle_mean],'r--');
set(gca,'XTickLabel',{'Before within','Before-After','Before-Day5','After-Day5',...
    'Before-Day6','After-Day6'})
ylabel(['Transient Map Mean Correlations - Individual Neurons active ' num2str(num_active) ' days only'])
h_legend = legend([h(1) h(2) h2],'Rotated (local cues align)','Not-rotated (distal cues align)','Shuffled');
hold off



end

