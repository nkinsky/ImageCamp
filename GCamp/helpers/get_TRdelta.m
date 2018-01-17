function [TR1, TR2] = get_TRdelta( neuron_map, sesh1, sesh2, varargin )
% [TR1, TR2] = get_TRdelta( neuron_map, sesh1, sesh2, varargin )
%  Gets difference in Transient event Rate (TR)between two sessions with a map
%  between them. Optional parameter 'plot_flag' set to true plots results
%  in bar graph form with individual points overlaid to a new figure if set
%  to true or an existing axes handle if set to that. Parameter 'include_silent'
%  (default = false) set to true includes cells that have a 0 in their
%  neuron map, indicating that they have 

%% Parse Inputs
ip = inputParser;
ip.addRequired('neuron_map',@isnumeric);
ip.addRequired('sesh1', @isstruct);
ip.addRequired('sesh2', @isstruct);
ip.addParameter('plot_flag', false, @(a) islogical(a) || ishandle(a));
ip.addParameter('silent_include', false, @islogical);
ip.addParameter('neuron_map_rev', [], @isnumeric); % If above is true, must add this - neuron map from sesh2 to sesh1
ip.addParameter('calc_half',false, @islogical); % Use this to calculate half1 v half2
ip.parse(neuron_map, sesh1, sesh2, varargin{:});
plot_flag = ip.Results.plot_flag;
silent_include = ip.Results.silent_include;
neuron_map_rev = ip.Results.neuron_map_rev;
calc_half = ip.Results.calc_half;

% Get axes to plot plot into if appropriate
if ~ishandle(plot_flag) && plot_flag
    hplot = figure; 
    set(gcf,'Position',[2266 128 1004 804]);
elseif ishandle(plot_flag)
    hplot = plot_flag;
    plot_flag = true;
end

% Get

%% Organize Data
sesh_use{1} = sesh1;
sesh_use{2} = sesh2;

%% Get TR for each session
% Get valid neurons (active in both and with a good mapping between
% sessions) in each session
valid_ind = ~isnan(neuron_map) & neuron_map ~= 0;
valid_neurons{1} = find(valid_ind);
valid_neurons{2} = neuron_map(valid_ind);
if silent_include
    % This is a bit more complicated since you need to look for both cells
    % that are 0s in the neuron_map but also cells that are 0s in the
    % reverse map...
    
    % First identify neurons that become silent in the other session
    off_neurons = find(neuron_map == 0); 
    on_neurons = find(neuron_map_rev == 0);
    
    % Debugging/checking code here
%     silent1 = find(arrayfun(@(a) ~any(a == neuron_map_rev), valid_ind1)); % ID cells in sesh1 missing from session21 map
%     silent2 = find(arrayfun(@(a) ~any(a == neuron_map), valid_ind2)); % Ditto for sesh2

%     invalid_neurons{1} = find(isnan(neuron_map)); % Identify badly mapped neurons in each session
%     invalid_neurons{2} = find(isnan(neuron_map_rev)); % Identify badly mapped neurons in each session
    % The above is good for sanity checks but is not used 
end

for j = 1:2
    
    dirstr = ChangeDirectory(sesh_use{j}.Animal, sesh_use{j}.Date,...
        sesh_use{j}.Session,0);
    load(fullfile(dirstr,'FinalOutput.mat'),'PSAbool')
    sesh_use{j}.duration = size(PSAbool,2)/20/60; % time in minutes
    if calc_half % split time in 2 if 1st half v 2nd half
        sesh_use{j}.duration = sesh_use{j}.duration/2; 
        half_ind = floor(size(PSAbool,2)/2);
        if j == 1
            PSAbool = PSAbool(:,1:half_ind);
        elseif j == 2
            PSAbool = PSAbool(:,(half_ind+1):end);
        end
    end 
    
    % Pre-allocate with nans - total # cells active in session 1
    if j == 1
        sesh_use{1}.TR = nan(size(PSAbool,1),1);
%         if silent_include
%             sesh_use{1}.TR = nan(size(PSAbool,1)+length(on_neurons),1);
%         elseif ~silent_include
%             sesh_use{1}.TR = nan(size(PSAbool,1),1);
%         end
        sesh_use{2}.TR = sesh_use{1}.TR;
    end
    
    % Calc transient rate (per min) for cells active both sessions
    sesh_use{j}.TR(valid_neurons{1}) = get_num_trans(PSAbool(valid_neurons{j},:))...
        /sesh_use{j}.duration;
    if silent_include % Add in silent cell TRs
        if j == 1 % Step 2 - add in neurons that turn "off" in session 2
            sesh_use{1}.TR(off_neurons) = get_num_trans(PSAbool(off_neurons,:))...
                /sesh_use{1}.duration; % Add in proper TR for "off" cells in session 1
            sesh_use{2}.TR(off_neurons) = 0; % Set "off" neurons' TRs to 0 in session 2
%             silent_ind = (length(sesh_use{j}.TR)+1):(length(sesh_use{j}.TR) + ...
%                 length(silent1));
%             sesh_use{j}.TR = [sesh_use{j}.TR; zeros(length(silent1),1)];           
        elseif j == 2 % Step 3 - add in neurons that turn "on" in session 2
            on_ind = (length(sesh_use{2}.TR)+1):(length(sesh_use{2}.TR) + ...
                length(on_neurons));
            sesh_use{2}.TR(on_ind) = get_num_trans(PSAbool(on_neurons,:))...
                /sesh_use{j}.duration; % Add in TR for "on" neurons in session 2
            sesh_use{1}.TR(on_ind) = 0; % Make TR zero for "on" neurons in session 1
        end
    end
    
end

valid_final_bool = ~isnan(sesh_use{1}.TR) & ~isnan(sesh_use{2}.TR);
sesh_use{1}.TR = sesh_use{1}.TR(valid_final_bool); TR1 = sesh_use{1}.TR;
sesh_use{2}.TR = sesh_use{2}.TR(valid_final_bool); TR2 = sesh_use{2}.TR;

%% Plot it
if plot_flag
    num_neurons = length(sesh_use{1}.TR);
    
    figure(hplot)
    subplot(2,2,1)
    % Get means of each and plot bar graph
    mean_use = cellfun(@(a) mean(a.TR), sesh_use);
    max_use = cellfun(@(a) max(a.TR), sesh_use);
    min_use = cellfun(@(a) min(a.TR), sesh_use);
    hb = bar(mean_use);
    hb.BarWidth = 0.3;
    xlim([0.5 2.5]); ylim([min(min_use)-0.5, max(max_use)+0.5]);
    hold on
    
    % Plot each point with a line between it (make line light?)
    h = plot([ones(1,num_neurons); 2*ones(1,num_neurons)],...
        [sesh_use{1}.TR'; sesh_use{2}.TR'],'b-');
    arrayfun(@(a) set(a,'Color',[0 0 1 0.2]),h);
    hold off
    set(gca,'XTickLabel',{'Session 1','Session 2'})
    ylabel('Transient Event Rate (trans/min)')
    
    subplot(2,2,2)
    diff_all = sesh_use{2}.TR - sesh_use{1}.TR;
    diff_mean = mean(diff_all);
    diff_std = std(diff_all);
    hb2 = bar(diff_mean); hb2.BarWidth = 0.3; hold on
    heb2 = errorbar(1,diff_mean, diff_std);
    xlim([0.5 1.5]); ylim([min(diff_all)-1 max(diff_all)+1]);
    h2 = plot(ones(size(diff_all)), diff_all, 'bo');
    arrayfun(@(a) set(a,'Color',[0 0 1 0.2],'MarkerSize',12),h2);
    ylabel('Absolute Diff TR (trans/min)')
    
    subplot(2,2,3)
    diff_all_norm = diff_all./mean([sesh_use{2}.TR sesh_use{1}.TR],2);
    diff_mean_norm = mean(diff_all_norm);
    diff_std_norm = std(diff_all_norm);
    hb2 = bar(diff_mean_norm); hb2.BarWidth = 0.3; hold on
    heb2 = errorbar(1,diff_mean_norm, diff_std_norm);
    xlim([0.5 1.5]); ylim([min(diff_all_norm)-1 max(diff_all_norm)+1]);
    h2 = plot(ones(size(diff_all_norm)), diff_all_norm, 'bo');
    arrayfun(@(a) set(a,'Color',[0 0 1 0.2],'MarkerSize',12),h2);
    ylabel('Norm. Diff TR (trans/min)')
    
    subplot(2,2,4)
    histogram(diff_all_norm,30);
    xlabel('Norm. Diff TR (trans/min)'); ylabel('Neurons')
    xlim([-2.2, 2.2])
    
end
%%

end

