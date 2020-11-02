function [reg_stats, reg_stats_chance, hfig] = reg_qc_plot_batch(base, reg, varargin)
% [reg_stats, hfig] = reg_qc_plot_batch(base, reg, num_shuffles (opt), ...
%   num_shifts(opt), shift_dist(opt), ...)
%
%   Plots histograms and ecdfs for centroid distance and |orientation diff|
%   for all neuron ROIs matched together between sessions.
%
%   INPUTS:
%
%   base, reg: sessions in MD format. All sessions in reg will be
%   registered to base.
%
%   num_shuffles (optional): Calculates chance level distributions by
%       shuffling cell identify in the second session. Meaningless for 
%       centroid distance. default = 100
%
%   num_shifts (optional): Similar to shuffling but takes a good
%   registration and shifts all ROIs the distance specified in shift_dist.
%   Identifies how sensitive your imaging window is to a bad registration
%   due to lateral shifts
%
%   shift_dist (optional): number of pixels to shift ROIs in reg session
%
%   name_append (name-pair): name to append to batch_session_map in base
%   session
%
%   batch_mode (name-pair): 0 = directly register each reg session to base
%   session, 1 = use a batch_session_map to do registration (recommended
%   since this tosses any ambiguous mappings between sessions), 2 = similar
%   to 1 but includes registration between all cells recorded, including
%   those that might be silent in the 1st session).  Default = 0. 1 is
%   recommended if you have run neuron_reg_batch.
%
%   hfig (name-pair): figure handle. default = plot into new figure.


%% Parse inputs
p = inputParser;
p.addRequired('base', @isstruct);
p.addRequired('reg', @isstruct);
p.addOptional('num_shuffles', 100, @(a) isnumeric(a) && round(a) == a && a >= 0);
p.addOptional('num_shifts', 0, @(a) isnumeric(a) && round(a) == a && a >= 0);
p.addOptional('shift_dist', 4, @(a) isnumeric(a) && a > 0);
p.addParameter('batch_mode', 0, @(a) a == 0 || a == 1 || a == 2);
p.addParameter('batchmap_dir', '', @(a) isempty(a) || exist(a,'dir'));
p.addParameter('name_append', '', @(a) ischar(a) || iscell(a) && (length(a) == 1 ...
    || length(a) == length(reg)));
p.addParameter('orient_only', false, @islogical); % only calculate orient_diff if true
% Saves reg. stats to base_dir. Note that chance stats are ONLY for base
% session 1 to itself!
p.addParameter('save_stats', false, @islogical); 
p.addParameter('hfig', [], @ishandle);
p.parse(base, reg, varargin{:});

num_shuffles = p.Results.num_shuffles;
num_shifts = p.Results.num_shifts; 
shift_dist = p.Results.shift_dist;
batch_mode = p.Results.batch_mode;
batchmap_dir = p.Results.batchmap_dir;
name_append = p.Results.name_append;
hfig = p.Results.hfig;
save_stats = p.Results.save_stats;
orient_only = p.Results.orient_only;

if length(reg) > 1
    multi_sesh = 1;
else
    multi_sesh = 0;
end

if ischar(name_append)
    temp = name_append;
    clear name_append
    name_append = cell(1, 1+length(reg));
    [name_append{:}] = deal(temp);
end

% Check to make sure you don't accidentally overwrite previous results
if save_stats
    persistent proceed
    if ~exist('proceed', 'var') || isempty(proceed)
        proceed = input('save_stats=true. You will overwrite ANY existing reg_stats files. Is this ok? (y/n): ', 's');
    end
    if strcmpi(proceed,'n')
        disp('Exiting Function...')
    elseif strcmpi(proceed,'y')
        disp('Proceeding...')
    end
end
        
%% Plot

if isempty(hfig)
    hfig = figure; set(gcf,'Position',[700 220 980 720]);
end

reg_stats = cell(length(reg),1);
legend_text = cell(1, length(reg));
reg_stats_chance = [];
legend_text{1} = [mouse_name_title(reg(1).Date) ' - #' num2str(reg(1).Session)];
he_cd = gobjects(length(reg),1); he_od = gobjects(length(reg),1);
hhist_cd = gobjects(length(reg),1); hhist_od = gobjects(length(reg),1);


try
    reg_stats{1} = neuron_reg_qc(base, reg(1), 'batch_mode', batch_mode, ...
        'name_append', name_append{1}, 'orient_only', orient_only, ...
        'save_stats', save_stats, 'batchmap_dir', batchmap_dir);
    [he_cd(1), hhist_cd(1), he_od(1), hhist_od(1)] = reg_qc_plot(reg_stats{1}.cent_d, reg_stats{1}.orient_diff, ...
        reg_stats{1}.avg_corr, hfig, 'multi_sesh', multi_sesh);    
catch ME
    switch ME.identifier
        case {'MATLAB:load:couldNotReadFile', 'MATLAB:imagesci:imread:fileDoesNotExist'}
            disp(['ERROR IN BASE SESSION : ' base.Date ' session ' num2str(base.Session)])
            return  % Exit if you find this error after displaying warning!
        otherwise
            rethrow(ME)
    end
end

try
    reg_stats_chance = neuron_reg_qc(base, base, 'batch_mode', batch_mode, ...
        'shuffle', num_shuffles, 'shift', num_shifts, 'shift_dist', shift_dist, ...'
        'name_append', name_append{1}, 'save_stats', save_stats, ...
        'orient_only', orient_only, 'batchmap_dir', batchmap_dir); % If the last registration is bad you can get a bad shuffled distribution here...
catch ME
    switch ME.identifier
        case {'MATLAB:load:couldNotReadFile', 'MATLAB:imagesci:imread:fileDoesNotExist'}
            disp(['ERROR IN BASE SESSION : ' base.Date ' session ' num2str(base.Session)])
            return  % Exit if you find this error after displaying warning!
        otherwise
            rethrow(ME)
    end
end

% Run through each session pair now.
for j = 2:length(reg)   
    try
        reg_stats{j} = neuron_reg_qc(base, reg(j), 'batch_mode', batch_mode,...
            'name_append', name_append{j}, 'save_stats', save_stats,...
            'orient_only', orient_only, 'batchmap_dir', batchmap_dir);
        [he_cd(j), hhist_cd(j), he_od(j), hhist_od(j)] = reg_qc_plot(reg_stats{j}.cent_d, ...
            reg_stats{j}.orient_diff, reg_stats{j}.avg_corr, hfig, 'multi_sesh', 1);
        legend_text{j} = [mouse_name_title(reg(j).Date) ' - #' num2str(reg(j).Session)];
        reg_stats{j}.session = reg(j);
    catch ME  % error catching - keep going if you can't find FinalOutput of ICmovie_min_proj for one session
        switch ME.identifier
            case {'MATLAB:load:couldNotReadFile', 'MATLAB:imagesci:imread:fileDoesNotExist'}
                disp(['ERROR IN: ' base.Date ' session ' num2str(base.Session) ...
                    ' to ' reg(j).Date ' session ' num2str(reg(j).Session)])
            otherwise
                rethrow(ME)
        end
    end
end

% reg_stats{length(reg)} = neuron_reg_qc(base, reg(end), 'batch_mode', batch_mode, ...
%     'shuffle', num_shuffles, 'shift', num_shifts, 'shift_dist', shift_dist, ...'
%     'name_append', name_append); % If the last registration is bad you can get a bad shuffled distribution here...
% legend_text{length(reg)} = [mouse_name_title(reg(end).Date) ' - #' num2str(reg(end).Session)];
% reg_qc_plot(reg_stats{end}.cent_d, reg_stats{end}.orient_diff, ...
%         reg_stats{end}.avg_corr, h, 'multi_sesh', multi_sesh);
    
% [hCIe_shift, hCIhist_shift] = reg_qc_plot(reg_stats{1}.shift.cent_d, ...
%     reg_stats{1}.shift.orient_diff, ...
%     reg_stats{1}.shift.avg_corr, hfig, 'plot_shuf', 1);
% [hCIe_shuf, hCIhist_shuf] = reg_qc_plot([], reg_stats{1}.shuffle.orient_diff, ...
%     [], hfig, 'plot_shuf', 1);

[hCIe_shift_cd, hCIhist_shift_cd, hCIe_shift_od, hCIhist_shift_od] = ...
    reg_qc_plot(reg_stats_chance.shift.cent_d, ...
    reg_stats_chance.shift.orient_diff, ...
    reg_stats_chance.shift.avg_corr, hfig, 'plot_shuf', 1);
[~, ~, hCIe_shuf_od, hCIhist_shuf_od] = ...
    reg_qc_plot([], reg_stats_chance.shuffle.orient_diff, ...
    [], hfig, 'plot_shuf', 1);


%% Make legends work

% First rule out any session pairs with no matching neurons
good_reg_bool = arrayfun(@isgraphics, hhist_cd); 
hhist_cd = hhist_cd(good_reg_bool);
hhist_od = hhist_od(good_reg_bool);
he_cd = he_cd(good_reg_bool);
he_od = he_od(good_reg_bool);
legend_text = legend_text(good_reg_bool);
if num_shifts > 0 && num_shuffles == 0
    legend_cd = cat(2,legend_text,[num2str(round(shift_dist)) '-pixel shift']);
    legend_od = cat(2,legend_text,[num2str(round(shift_dist)) '-pixel shift']);
    legend(cat(1,hhist_cd,hCIhist_shift_cd(1)),legend_cd)
    legend(cat(1,he_cd,hCIe_shift_cd(1)),legend_cd)
    legend(cat(1,hhist_od,hCIhist_shift_od(1)),legend_od)
    legend(cat(1,he_od,hCIe_shift_od(1)),legend_od)
elseif num_shifts == 0 && num_shuffles > 0
    legend_cd = legend_text;
    legend_od = cat(2,legend_text,[num2str(num_shuffles) ' Shuffles']);
    try
        legend(hhist_cd,legend_cd)
        legend(he_cd,legend_cd)
    catch ME
        % Continue on if legend is empty
        if ~ismember(ME.identifier,{'MATLAB:undefinedVarOrClass','MATLAB:legend:UnknownParameter'})
            keyboard
        end
    end
    try
        legend(cat(1,hhist_od, hCIhist_shuf_od(1)),legend_od)
        legend(cat(1,he_od, hCIe_shuf_od(1)),legend_od)
    catch ME
        % Continue on if legend is empty
        if ~ismember(ME.identifier,{'MATLAB:undefinedVarOrClass','MATLAB:legend:UnknownParameter'})
            keyboard
        end
    end
elseif num_shifts > 0 && num_shuffles > 0
    legend_cd = cat(2,legend_text,[num2str(round(shift_dist)) '-pixel shift']);
    legend_od = cat(2,legend_text,[num2str(round(shift_dist)) '-pixel shift'],...
        [num2str(num_shuffles) ' Shuffles']);
    legend(cat(1,hhist_cd,hCIhist_shift_cd(1)),legend_cd)
    legend(cat(1,he_cd,hCIe_shift_cd(1)),legend_cd)
    legend(cat(1,hhist_od,hCIhist_shift_od(1), hCIhist_shuf_od(1)),legend_od)
    legend(cat(1,he_od,hCIe_shift_od(1), hCIe_shuf_od(1)),legend_od)
elseif num_shifts == 0 && num_shuffles == 0
    legend(hhist_cd, legend_text)
    legend(hhist_od, legend_text)
    legend(he_cd, legend_text)
    legend(he_od, legend_text)
end

if sum(~good_reg_bool) == 1
    text(subplot(2,2,2), 15, 0.8*max(get(subplot(2,2,2),'ylim')), 'Bad registrations for')
    text(subplot(2,2,2), 15, 0.7*max(get(subplot(2,2,2),'ylim')), '(on or around):')
    text(subplot(2,2,2), 15, 0.6*max(get(subplot(2,2,2),'ylim')), legend_text(~good_reg_bool));
end
    
        
% for j=1:4
%     subplot(2,2,j)
%     if num_shifts > 0
%         legend(legend_text{:}, [num2str(round(shift_dist)) '-pixel shift'])
%     else
%         legend(legend_text{:})
%     end
% end
% 
% if num_shuffles > 0
%     subplot(2,2,2)
%     legend(updatelegend(gca,[num2str(num_shuffles) ' Shuffles']));
%     subplot(2,2,4)
%     legend(updatelegend(gca,[num2str(num_shuffles) ' Shuffles']));
% end

subplot(2,2,4)
title(['Base Session: ' mouse_name_title(base.Animal) ' - ' ...
    mouse_name_title(base.Date) ' session ' num2str(base.Session)])

%% Set colors from cool (nearest in time) to warm (furthest in time)
% NRK - this does NOT work for pair-wise registration, so added try/catch for now 
ff = get(gcf);
num_lines = length(ff.Children(end).Children); % Get number of lines drawn
if num_shifts > 0
    num_lines = num_lines -3;
end
cm = flipud(colormap(jet(num_lines)));
try
    if num_shuffles > 0 || num_shifts > 0
        for j = 2:2:4
            % put blank spots in cm_matrix.
            if num_shuffles > 0 && num_shifts > 0
                cm_use= [0 0 1; 0 0 1; 0 0 1; 0 0 0; 0 0 0; 0 0 0; cm];
            else
                cm_use = [0 0 0; 0 0 0; 0 0 0; cm];
            end
            for k = 1: size(cm_use,1)
                ff.Children(j).Children(k).Color = cm_use(k,:);
            end
        end
    else
        for j = 2:2:4
            for k = 1: size(cm,1)
                ff.Children(j).Children.Color = cm(k,:); % Set Shuffled to black
            end
        end
    end
catch
    disp('bypassing colors for lines in reg_qc_plot_batch for now')
end

try
for j = 6:2:8
    if num_shifts > 0
         cm_use = [0 0 0; 0 0 0; 0 0 0; cm];
    else
        cm_use = cm;
    end
    for k = 1: size(cm_use,1)
        ff.Children(j).Children(k).Color = cm_use(k,:);
    end
end
catch
    disp('bypassing colors for lines in reg_qc_plot_batch for now')
end


end

%% Update legend string
function [legend_str] = updatelegend(ax, update_str)

temp = get(ax,'Legend');
legend_str = cat(2, temp.String, update_str);

end

