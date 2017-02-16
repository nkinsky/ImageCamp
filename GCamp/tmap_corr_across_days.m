function [corr_matrix, pop_corr_struct, min_dist_matrix, vec_diff_matrix, pass_thresh, ...
    corr_win, corr_shuffle_matrix, min_dist_shuffle_matrix, pop_corr_shuffle_matrix] = ...
    tmap_corr_across_days(working_dir,varargin)
% [corr_matrix, pop_corr_struct, min_dist_matrix, vec_diff_matrix, pass_thresh, ...
%    corr_win, corr_shuffle_matrix, min_dist_shuffle_matrix] = ...
%    tmap_corr_across_days(working_dir,varargin)
%
% Gets correlations between calcium transient heat maps (TMaps) across
% days.  Requires all TMaps to have the same grid size/spacing (done by
% running batch_align_pos), then running PFA.
%
%   INPUTS:
%
%       working_dir: the base working directory for the sessions you wish
%           to analyze.  Must contain batch_session_map (obtained from
%           neuron_reg_batch) pointing to all the analyzed sessions.  If
%           left empty you will be prompted to choose the working
%           directory.
%
%       varargins (enter as ...,'rotate_to_std',1):
%           'rotate_to_std': default = 0.  1 = analyze placemaps that have
%           been rotated such that all local cues align.  See
%           CalculatePlaceFields and PFA.
%
%           'population_corr': default = 0. 1 = do a population correlation
%           of ALL the valid TMaps...
%
%           'trans_rate_thresh': the minimum transient rate, in Hz, you
%           wish to consider for cells.  Default = 0 (all cells).  Cells
%           below the threhsold will no be considered in the analysis.
%
%           'pval_thresh': threshold for p-values to use.  Any cells below
%           this value will not be included.  If left empty all pvalues are
%           fair game.
%
%           'plot_confusion_matrix': default = 0 (no plot).  1 = plot every
%           session correlation versus all the others in a confusion
%           matrix.
%
%           'archive_name_append': this will be appended to the end of the
%           PlaceMaps.mat and PlaceMaps_rot_to_std.mat when loading if you
%           are using differently named files
%           
%           'within_session': default = 0.  1 will only look at within session
%           correlations using TMap(1).Tmap_half vs. TMap(2).Tmap_half
%
%           'num_shuffles': default = 0.  Any integer greater than 0 specifies
%           the number of times you wish to calculate correlations between
%           sessions with the 2nd session shuffled.
%
%           'version_use: default = 'T4' (Finaloutput.mat and Placefields.mat).
%           Also supports T2 (ProcOut.mat & PlaceMaps.mat)
%
%   OUTPUTS:
%
%       corr_matrix: an n x n x num_neurons matrix where n = the total number of
%       sessions, where entry corr_matrix(i,j,k) is the correlation of TMaps
%       for neuron k between the ith and jth sessions.
%
%       pop_corr_struct: similar to the corr_matrix, but with one
%       population correlation and its corresponding p-value per session
%       comparison, using a population vector of EVERY neuron's TMap
%       (linearized).
%
%       pass_thresh: a n x n x num neurons logical matrix indicating if
%       that neuron passed the thresholds for inclusion.
%% Variable
SR = 20; %fps
PF_thresh = 0.9;

%% Get varargins

p = inputParser;

p.addRequired('working_dir', @ischar);
p.addParameter('rotate_to_std', 0, @(a) islogical(a) || a == 0 || a == 1);
p.addParameter('population_corr', 0, @(a) islogical(a) || a == 0 || a == 1);
p.addParameter('trans_rate_thresh', 0, @(a) a >= 0);
p.addParameter('pval_thresh', 0, @(a) a >= 0);
p.addParameter('plot_confusion_matrix', 0, @(a) islogical(a) || a == 0 || a == 1);
p.addParameter('archive_name_append', '', @ischar);
p.addParameter('within_session', 0, @(a) islogical(a) || a == 0 || a == 1);
p.addParameter('num_shuffles', 0, @(a) a >= 0 && round(a,0) == a);
p.addParameter('version_use', 'T2', @(a) ischar(a) && length(a) == 2);

p.parse(working_dir, varargin{:});
rotate_to_std = p.Results.rotate_to_std;
population_corr = p.Results.population_corr;
trans_rate_thresh = p.Results.trans_rate_thresh;
pval_thresh = p.Results.pval_thresh;
plot_confusion_matrix = p.Results.plot_confusion_matrix;
archive_name_append = p.Results.archive_name_append;
within_session = p.Results.within_session;
num_shuffles = p.Results.num_shuffles;
version_use = p.Results.version_use;

%% Get working directory
orig_dir = cd; % Get original directory
if ~exist('working_dir','var') || isempty(working_dir)
    working_dir = uigetdir('Pick your working directory:');
end
%% 1) Load both Reg_NeuronID files (updatemasks = 0 and updatemasks = 1).
disp('Loading Reg_NeuronIDs and batch_session_map')

load(fullfile(working_dir,'batch_session_map.mat'));

num_neurons = size(batch_session_map(1).map,1);
num_sessions = length(batch_session_map(1).session);

%% 2) Get base directory and directories of all the subsequent registered sessions, ...
% & load up the TMaps for each of these sessions

batch_session_map = fix_batch_session_map(batch_session_map);
Animal = batch_session_map(1).session(1).Animal;
sesh = batch_session_map(1).session;

disp(['Loading TMaps for each session and calculating PF centroids for ' version_use ' data'])
if strcmpi(version_use,'T2')
    for j = 1:num_sessions
        ChangeDirectory(Animal, sesh(j).date,...
            sesh(j).session);
        if rotate_to_std == 0
            load(['PlaceMaps' archive_name_append '.mat'],'TMap_gauss','pval');
        elseif rotate_to_std == 1
            load(['PlaceMaps_rot_to_std' archive_name_append '.mat'],'TMap_gauss','pval');
        end
        sesh(j).TMap = TMap_gauss;
        if within_session == 1
            if rotate_to_std == 0
                load(['PlaceMaps' archive_name_append '.mat'],'TMap_half');
            elseif rotate_to_std == 1
                load(['PlaceMaps_rot_to_std' archive_name_append '.mat'],'TMap_half');
            end
            sesh(j).TMap_half = TMap_half;
        end
        sesh(j).pval_use = 1-pval;
        sesh(j).pval_pass = sesh(j).pval_use <= pval_thresh;
        
        % Get transient rates and those that pass the threshold
        load('ProcOut.mat','NumTransients','NumFrames');
        sesh(j).trans_rate = NumTransients/(NumFrames/SR);
        sesh(j).trans_rate_pass = sesh(j).trans_rate >= trans_rate_thresh;
        
        % Get Place Field centroid locations for each session
        [~, sesh(j).PF_centroid] = get_PF_centroid(sesh(j).TMap,PF_thresh);
    end
    
elseif strcmpi(version_use,'T4')
    for j = 1:num_sessions
        dirstr = ChangeDirectory(Animal, sesh(j).Date, sesh(j).Session, 0);
        if rotate_to_std == 0
            load(fullfile(dirstr,['Placefields' archive_name_append '.mat']),'TMap_gauss','pval');
        elseif rotate_to_std == 1
            load(fullfile(dirstr,['Placefields_rot_to_std' archive_name_append '.mat']),'TMap_gauss','pval');
        end
        sesh(j).TMap = TMap_gauss;
        sesh(j).pval_use = pval;
        if within_session == 1
            if rotate_to_std == 0
                temp = importdata(fullfile(dirstr,['Placefields' archive_name_append '_half.mat']));
            elseif rotate_to_std == 1
                temp = importdata(fullfile(dirstr,['Placefields_rot_to_std' archive_name_append '_half.mat']));
            end
            sesh(j).TMap_half(1).TMap_gauss = temp{1}.TMap_gauss;
            sesh(j).TMap_half(2).TMap_gauss = temp{2}.TMap_gauss;
            clear temp
        end
        
        sesh(j).pval_pass = sesh(j).pval_use <= pval_thresh;
        
        % Get transient rates and those that pass the threshold
        load(fullfile(dirstr,'FinalOutput.mat'),'PSAbool');
        NumTransients = get_num_trans(PSAbool);
        NumFrames = size(PSAbool,2);
        sesh(j).trans_rate = NumTransients/(NumFrames/SR);
        sesh(j).trans_rate_pass = sesh(j).trans_rate >= trans_rate_thresh;
        
        % Get Place Field centroid locations for each session
        [~, sesh(j).PF_centroid] = get_PF_centroid(sesh(j).TMap,PF_thresh);
    end
end


%% 3) Get correlations between the TMaps for all cells across each day.  

% Visualize with individual cell and all cell confusion matrices? Or just
% bar graphs for day 1 to day 2, day 2 to day 3, and day 1 to day 3?

disp('Getting inter-session correlations (individual neurons)')
pass_thresh = zeros(num_sessions, num_sessions, num_neurons);
for j = 1:num_neurons
    n = 0;
    for k = 1:num_sessions
        for ll = k:num_sessions
            % Get neurons back to original mapping
            sesh1_neuron = batch_session_map(1).map(j,k+1);
            sesh2_neuron = batch_session_map(1).map(j,ll+1);
            % Get the correlations only if both neurons are validly mapped
            if (sesh1_neuron ~= 0 && ~isnan(sesh1_neuron)) && (sesh2_neuron ~= 0 && ~isnan(sesh2_neuron))
                % Check if the neuron passes the threshold test from both
                % sessions
                sesh1_thresh_pass = sesh(k).trans_rate_pass(sesh1_neuron) & ...
                    sesh(k).pval_pass(sesh1_neuron);
                sesh2_thresh_pass = sesh(ll).trans_rate_pass(sesh2_neuron) & ...
                    sesh(ll).pval_pass(sesh2_neuron);
                try % error catching statement
                    if sesh1_thresh_pass || sesh2_thresh_pass
                        corr_matrix(k,ll,j) = corr(sesh(k).TMap{sesh1_neuron}(:),...
                            sesh(ll).TMap{sesh2_neuron}(:),'rows','complete','type','Spearman');
%                         corr_matrix(k,ll,j) = temp(1,2);
                        n = n + 1;
                        pass_thresh(k,ll,j) = 1;
                    else
                        corr_matrix(k,ll,j) = nan;
                        pass_thresh(k,ll,j) = 0;
                    end
                catch
                    disp('error in tmap_across_days')
                    keyboard
                end
            else
                corr_matrix(k,ll,j) = nan;
                pass_thresh(k,ll,j) = 0;
            end
            
        end
        
    end
    corr_numbers(j) = n;
end

%% 3a) Population correlations
if population_corr == 1
    disp('Getting inter-session population correlations')
%     p = ProgressBar(num_sessions);
    for k = 1:num_sessions
        for ll = k:num_sessions
            sesh1_pop = [];
            sesh2_pop = [];
            neuron_use = find(squeeze(pass_thresh(k,ll,:))); % Get neurons that pass all criteria for both sessions
            for j = 1:length(neuron_use)
                sesh1_neuron = batch_session_map(1).map(neuron_use(j),k+1);
                sesh2_neuron = batch_session_map(1).map(neuron_use(j),ll+1);
                % Insert additional check here with a varargin to filter
                % out neurons that don't meet certain criteria? e.g.
                % transient rate and/or information criteria?
                
                if (sesh1_neuron ~= 0) && (sesh2_neuron ~= 0) && ...
                        any(sesh(k).TMap{sesh1_neuron}(:)) || any(sesh(ll).TMap{sesh2_neuron}(:))% ~isempty(sesh1_neuron) && ~isempty(sesh2_neuron) && ~isnan(sesh1_neuron) && ~isnan(sesh2_neuron)
                    sesh1_pop = [sesh1_pop; sesh(k).TMap{sesh1_neuron}(:)];
                    sesh2_pop = [sesh2_pop; sesh(ll).TMap{sesh2_neuron}(:)];
                end
%                 disp(ticker);
%                 ticker = ticker + 1;
            end
            [ pop_corr(k,ll), p_pop_corr(k,ll)] = corr(sesh1_pop, sesh2_pop,...
                'rows','complete','type','Spearman');
            
%             [r_temp, p_temp] = corrcoef(sesh1_pop,sesh2_pop);
%             pop_corr(k,ll) = r_temp(1,2);
%             p_pop_corr(k,ll) = p_temp(1,2);
        end
%         p.progress;
    end
%     p.stop;
    pop_corr_struct.r = pop_corr;
    pop_corr_struct.p = p_pop_corr;
else
    pop_corr_struct = [];
end

%% Get Distances 
disp('Calculating place field distance between sessions');
min_dist_matrix = nan(num_sessions, num_sessions, num_neurons);
for k = 1:num_sessions
    for ll = k:num_sessions
        try
            neuron_map_base = get_neuronmap_from_batchmap(batch_session_map.map,...
                0,k); % Get map from 1st session to all neurons
            neuron_map_use = get_neuronmap_from_batchmap(batch_session_map.map,...
                k,ll); % Get map from 2nd session to 1st session
            [temp_dist, temp_vec] = get_PF_centroid_diff(sesh(k).PF_centroid,...
                sesh(ll).PF_centroid, neuron_map_use,1); % get PF differences from 1st to second session
            % Assign distance comparisons to the appropriate base neuron
            for j = 1:length(temp_dist)
                neuron_index = neuron_map_base(j);
                if neuron_index ~= 0 && ~isnan(neuron_index)
                    min_dist_matrix(k,ll,neuron_index) = temp_dist(j);
                    vec_diff_matrix(k,ll).xy(neuron_index,:) = temp_vec.xy(j,:);
                    vec_diff_matrix(k,ll).uv(neuron_index,:) = temp_vec.uv(j,:);
                end
            end
        catch
            keyboard
        end
    end
end
% keyboard
%% 4) Within session controls...
if within_session == 1
    disp('Calculating within session correlations')
    for j = 1:num_sessions
        % Get neurons that have non-NaN placefields in both halves
        win_ok = cellfun(@(a,b) any(a(:)) & any(b(:)), ...
            sesh(j).TMap_half(1).TMap_gauss, sesh(j).TMap_half(2).TMap_gauss);
        win_ok_ind{j} = find(win_ok);
    end
    corr_win = nan(num_sessions, max(cellfun(@length, win_ok_ind)));
    for j = 1:num_sessions
        % Get within session correlations
        for k = 1:length(win_ok_ind{j})
            corr_win(j,k) = corr(sesh(j).TMap_half(1).TMap_gauss{win_ok_ind{j}(k)}(:), ...
                sesh(j).TMap_half(2).TMap_gauss{win_ok_ind{j}(k)}(:),...
                'rows','complete','type','Spearman');
        end
    end
else
    corr_win = [];
end

%% 5) Now do above for shuffled neuron identity if desired...
tic
% Shuffles for individual neurons
if num_shuffles >= 1
    disp(['Shuffling sessions ' num2str(num_shuffles) ' times'])
    corr_shuffle_matrix = nan*ones(num_shuffles, num_sessions,num_sessions,num_neurons); % Initialize Shuffled Matrix
    min_dist_shuffle_matrix = nan*ones(num_shuffles, num_sessions,num_sessions,num_neurons); % Initialize Shuffled Matrix
    for n = 1:num_shuffles
        disp(['Shuffle # ' num2str(n) ' in progress'])
        for k = 1:num_sessions
            for ll = k:num_sessions
                ok = squeeze(pass_thresh(k,ll,:)); % Get neurons that pass all criteria for both sessions
                ok_ind{1} = find(ok); % Keep all indices the same for the 1st session
                ok_ind{2} = ok_ind{1}(randperm(length(ok_ind{1}))); % randomize 2nd session indices
                map1_2_shuffle = zeros(size(sesh(k).TMap));
                map1_base = get_neuronmap_from_batchmap(batch_session_map.map,k,ll);
                
                sesh1_pop = [];
                sesh2_pop = [];
                for j = 1:length(ok_ind{1})
                    sesh1_neuron = batch_session_map(1).map(ok_ind{1}(j),k+1);
                    sesh2_neuron = batch_session_map(1).map(ok_ind{2}(j),ll+1);
                    map1_2_shuffle(sesh1_neuron) = sesh2_neuron;
                    corr_shuffle_matrix(n,k,ll,ok_ind{1}(j)) = corr(...
                        sesh(k).TMap{sesh1_neuron}(:),...
                        sesh(ll).TMap{sesh2_neuron}(:),'rows','complete',...
                        'type','Spearman');
                    
                    %%% Population Vectors
                    if (sesh1_neuron ~= 0) && (sesh2_neuron ~= 0) && ...
                            any(sesh(k).TMap{sesh1_neuron}(:)) && ...
                            any(sesh(ll).TMap{sesh2_neuron}(:))% ~isempty(sesh1_neuron) && ~isempty(sesh2_neuron) && ~isnan(sesh1_neuron) && ~isnan(sesh2_neuron)
                        sesh1_pop = [sesh1_pop; sesh(k).TMap{sesh1_neuron}(:)];
                        sesh2_pop = [sesh2_pop; sesh(ll).TMap{sesh2_neuron}(:)];
                    end
                end
                
                % Calculate PV correlations
                try
                    pop_corr_shuffle_matrix(n,k,ll) = corr(sesh1_pop,sesh2_pop,'type','Spearman');
                catch
                    keyboard
                end
%                 pop_corr_shuffle_matrix(n,k,ll) = r_temp(1,2);
                
                
                % Calculate distances between place fields
%                 neuron_map_use = get_neuronmap_from_batchmap(batch_session_map.map,...
%                     k,ll);
                temp = get_PF_centroid_diff(sesh(k).PF_centroid,...
                    sesh(ll).PF_centroid, map1_2_shuffle,1);
                for j = 1:length(temp)
                    neuron_index = neuron_map_base(j);
                    if neuron_index ~= 0
                        min_dist_shuffle_matrix(n,k,ll,j) = temp(j);
                    end
                end
                
                
                
            end
        end
    end
else
    corr_shuffle_matrix = [];
    pop_corr_shuffle_matrix = [];
end

toc
%% Plot

if plot_confusion_matrix == 1
    
    for j = 1:size(corr_matrix,1)
        for k = 1:size(corr_matrix,2)
            corr_mat_plot(j,k) = nanmean(squeeze(corr_matrix(j,k,:)));
        end
    end

figure
imagesc(corr_mat_plot)

end

%% Return to original directory
cd(orig_dir);
end