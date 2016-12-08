% DNMP figure export

plot_pval = false;

sesh = MD(180);
rot_degrees = -90; % How much to rotate the TMaps
rot_amt = rot_degrees/90;
IChack = false;
if IChack
    plot_pval = false;
end

trial_types = {'Forced L', 'Forced R', 'Free L', 'Free R'}; % {'Forced','Free'};
file_name_append = {'_forced_left.mat', '_forced_right.mat', '_free_left.mat', '_free_right.mat'}; %{'_forced.mat','_free.mat'}; % Must match block types above
plot_file = 'PFcompare_wpvalues_rot';

%% Plot actual comparisons

% load all the variables
if ~IChack
    load(fullfile(sesh.Location,'NormTraces.mat'),'trace');
    load(fullfile(sesh.Location,'T2output.mat'),'FT');
elseif IChack
    disp('Using data from ICout_hack.mat and NormTraces_hack.mat')
    load(fullfile(sesh.Location,'NormTraces_hack.mat'),'trace');
%     load(fullfile(sesh.Location,'ICout_hack.mat'),'FT');
end
numFrames_full = size(trace,2);

% load on_off_ind.mat
load('exclude_frames.mat','on_maze_exclude');
on_maze_log_full = exc_to_inc(on_maze_exclude,numFrames_full);

trials = load(fullfile(sesh.Location,['PlaceMapsv2' file_name_append{1}]),'TMap_gauss',...
    'RunOccMap','pval','isrunning','FToffset','FT');
FT = trials(1).FT;
FToffset = trials(1).FToffset;
isrunning_all = false(size(trials(1).isrunning));
NumNeurons = length(trials(1).TMap_gauss);
NumFrames = size(FT,2);
for k = 2:length(trial_types)
    trials(k) = load(fullfile(sesh.Location,['PlaceMapsv2' file_name_append{k}]),'TMap_gauss',...
        'RunOccMap','pval','isrunning','FToffset','FT');
    isrunning_all = isrunning_all | trials(k).isrunning;
end

% on_maze_log = false(1,NumFrames); off_maze_log = false(1,NumFrames);
% on_maze_log(on_maze_ind) = true;
% off_maze_log(off_maze_ind) = true;

for k = 1:length(trial_types)
    load(fullfile(sesh.Location,['PFstatsv2' file_name_append{k}]),'PFnumhits');
    trials(k).PFnumhits = PFnumhits;
end

trace_use = trace(:,FToffset-1:end);
on_maze_log = on_maze_log_full(1,FToffset-1:end);

figure(543)
set(gcf,'Position',[1 41 1920 964]);
cm = colormap('jet');
neurons_plot = [10 11 13 16 28 40 47]; %54; %[50 54 63 74];%[17 18 19 20 23 25 26 27 28 31 36 39 42 44 47 54 55 56];
for j = 1:length(neurons_plot)
    
    % Refresh figure every 100 to prevent slowdowns
    if round(j/50) == (j/50)
        close 543
        figure(543)
        set(gcf,'Position',[1 41 1920 964]);
    end
    for k = 1:length(trials)
        if length(trials) == 2
            subplot(2,2,k)
        elseif length(trials) == 4
            sub_ref = { [ 1 2 5 6] [3 4 7 8] [9 10 13 14] [ 11 12 15 16]};
            ha{k} = subplot(5,4,sub_ref{k});
        end
        [~, nan_map] = make_nan_TMap(trials(k).RunOccMap,trials(k).TMap_gauss{neurons_plot(j)},...
            'perform_smooth',1);
        scale_max(k) = nanmax(nan_map(:));
            imagesc_nan(rot90(nan_map,rot_amt),cm,[1 1 1]);
        title(['Neuron ' num2str(neurons_plot(j)) ' ' trial_types{k} ' Trials'])
%         axis off
        xlabel(['                                                                    Number hits = ' num2str(max(trials(k).PFnumhits(neurons_plot(j),:)))])
        if plot_pval
            ylabel(['pval = ' num2str(1 - trials(k).pval(neurons_plot(j)))])
        end
    end
    
    % Match heat map scales so that the same color means the same transient
    % probability in each map
    scale_max = nanmax(scale_max);
    if isnan(scale_max) || scale_max == 0
        scale_max = 1;
    end
    clim_range = [-scale_max/50 scale_max];
    for k = 1:length(trials)
       set(ha{k},'CLim',clim_range);
    end
    
    
    % Plot trace
    if length(trials) == 2
        subplot(2,2,[3 4])
    elseif length(trials) == 4
        subplot(5,4,17:20)
    end
    plot(1:NumFrames,trace_use(neurons_plot(j),:),'b-',find(FT(neurons_plot(j),:) & ~isrunning_all),trace_use(neurons_plot(j),FT(neurons_plot(j),:) & ~isrunning_all),'g.',...
        find(FT(neurons_plot(j),:) & isrunning_all & on_maze_log),trace_use(neurons_plot(j),FT(neurons_plot(j),:) & isrunning_all & on_maze_log),'r.');
    
    export_fig(plot_file,'-pdf','-append')
% waitforbuttonpress
    
end

%% Control comparisons

load(fullfile(sesh.Location,'PlaceMapsv2_onmaze.mat'),'TMap_half',...
    'RunOccMap')
title_str_append = {' 1st half Trials', ' 2nd half Trials'};

NumNeurons = length(TMap_half(1).TMap_gauss);

figure(550)
cm = colormap('jet');
for j = 1:NumNeurons
    
    for k = 1:2
        subplot(1,2,k)
        [~, nan_map] = make_nan_TMap(RunOccMap,TMap_half(k).TMap_gauss{j},...
            'perform_smooth',1);
        imagesc_nan(nan_map,cm,[1 1 1]);
        title(['Neuron ' num2str(j) title_str_append{k}])
    end
    
     export_fig('PFcompare_control','-pdf','-append')
% waitforbuttonpress

end