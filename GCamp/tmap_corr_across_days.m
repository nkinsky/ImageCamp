function [corr_matrix, pop_corr_struct, min_dist_matrix, pass_thresh, ...
    corr_win, corr_shuffle_matrix, min_dist_shuffle_matrix] = ...
    tmap_corr_across_days(working_dir,varargin)
% [corr_matrix, pop_corr_struct, min_dist_matrix, pass_thresh, ...
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
rotate_to_std = 0; % default
population_corr = 0; % default
trans_rate_thresh = 0; % default
plot_confusion_matrix = 0; % default
pval_thresh = 0; % default
archive_name_append = [];
within_session = 0; % default
shuffle = 0; % default
for j = 1:length(varargin)
   if strcmpi(varargin{j},'rotate_to_std')
       rotate_to_std = varargin{j+1};
   end
   if strcmpi(varargin{j},'population_corr')
       population_corr = varargin{j+1};
   end
   if strcmpi(varargin{j},'trans_rate_thresh')
       trans_rate_thresh = varargin{j+1};
   end
   if strcmpi(varargin{j},'pval_thresh')
       pval_thresh = varargin{j+1};
   end
   if strcmpi(varargin{j},'plot_confusion_matrix')
       plot_confusion_matrix = varargin{j+1};
   end
   if strcmpi(varargin{j},'archive_name_append')
       archive_name_append = varargin{j+1};
   end
   if strcmpi(varargin{j},'within_session')
       within_session = varargin{j+1};
   end
   if strcmpi(varargin{j},'num_shuffles')
       num_shuffles = varargin{j+1};
   end
end

%% Get working directory
orig_dir = cd; % Get original directory
if ~exist('working_dir','var') || isempty(working_dir)
    working_dir = uigetdir('Pick your working directory:');
end
%% 1) Load both Reg_NeuronID files (updatemasks = 0 and updatemasks = 1).
disp('Loading Reg_NeuronIDs and batch_session_map')

% load(fullfile(working_dir,'Reg_NeuronIDs_updatemasks0.mat')) % Load Masks - is this even necessary?
load(fullfile(working_dir,'batch_session_map.mat'));

num_neurons = size(batch_session_map(1).map,1);
num_sessions = length(batch_session_map(1).session);

%% 2) Get base directory and directories of all the subsequent registered sessions, ...
% & load up the TMaps for each of these sessions

Animal = batch_session_map(1).session(1).mouse;
sesh = batch_session_map(1).session;

disp('Loading TMaps for each session and calculating PF centroids')
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
   sesh(j).PF_centroid = get_PF_centroid(sesh(j).TMap,PF_thresh);
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
            if (sesh1_neuron ~= 0) && (sesh2_neuron ~= 0)
                % Check if the neuron passes the threshold test from both
                % sessions
                sesh1_thresh_pass = sesh(k).trans_rate_pass(sesh1_neuron) & ...
                    sesh(k).pval_pass(sesh1_neuron);
                sesh2_thresh_pass = sesh(ll).trans_rate_pass(sesh2_neuron) & ...
                    sesh(ll).pval_pass(sesh2_neuron);
                try % error catching statement
                    if sesh1_thresh_pass || sesh2_thresh_pass
                        temp = corrcoef(sesh(k).TMap{sesh1_neuron}(:),...
                            sesh(ll).TMap{sesh2_neuron}(:));
                        corr_matrix(k,ll,j) = temp(1,2);
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

% ticker = 1;
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
                        ~isnan(sum(sesh(k).TMap{sesh1_neuron}(:))) && ~isnan(sum(sesh(ll).TMap{sesh2_neuron}(:)))% ~isempty(sesh1_neuron) && ~isempty(sesh2_neuron) && ~isnan(sesh1_neuron) && ~isnan(sesh2_neuron)
                    sesh1_pop = [sesh1_pop; sesh(k).TMap{sesh1_neuron}(:)];
                    sesh2_pop = [sesh2_pop; sesh(ll).TMap{sesh2_neuron}(:)];
                end
%                 disp(ticker);
%                 ticker = ticker + 1;
            end
            [r_temp, p_temp] = corrcoef(sesh1_pop,sesh2_pop);
            pop_corr(k,ll) = r_temp(1,2);
            p_pop_corr(k,ll) = p_temp(1,2);
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
            temp = get_PF_centroid_diff(sesh(k).PF_centroid,...
                sesh(ll).PF_centroid, neuron_map_use,1); % get PF differences from 1st to second session
            for j = 1:length(temp)
                neuron_index = neuron_map_base(j);
                if neuron_index ~= 0;
                    min_dist_matrix(k,ll,neuron_index) = temp(j);
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
        win_ok = cellfun(@(a,b) sum(isnan(a(:))) == 0 & sum(isnan(b(:))) == 0, ...
            sesh(j).TMap_half(1).TMap_gauss, sesh(j).TMap_half(2).TMap_gauss);
        win_ok_ind = find(win_ok);
        % Get within session correlations
        for k = 1:length(win_ok_ind)
            temp = corrcoef(sesh(j).TMap_half(1).TMap_gauss{win_ok_ind(k)}(:), ...
                sesh(j).TMap_half(2).TMap_gauss{win_ok_ind(k)}(:));
            corr_win(j,k) = temp(1,2);
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
                for j = 1:length(ok_ind{1})
                    sesh1_neuron = batch_session_map(1).map(ok_ind{1}(j),k+1);
                    sesh2_neuron = batch_session_map(1).map(ok_ind{2}(j),ll+1);
                    map1_2_shuffle(sesh1_neuron) = sesh2_neuron;
                    temp = corrcoef(sesh(k).TMap{sesh1_neuron}(:),...
                        sesh(ll).TMap{sesh2_neuron}(:));
                    corr_shuffle_matrix(n,k,ll,ok_ind{1}(j)) = temp(1,2);
                end
                % Calculate distances between place fields
%                 neuron_map_use = get_neuronmap_from_batchmap(batch_session_map.map,...
%                     k,ll);
                temp = get_PF_centroid_diff(sesh(k).PF_centroid,...
                    sesh(ll).PF_centroid, map1_2_shuffle,1);
                for j = 1:length(temp)
                    neuron_index = neuron_map_base(j);
                    if neuron_index ~= 0;
                        min_dist_shuffle_matrix(n,k,ll,j) = temp(j);
                    end
                end
                
            end
        end
    end
else
    corr_shuffle_matrix = [];
end

toc
%% Plot

if plot_confusion_matrix == 1
    
    for j = 1:size(corr_matrix,1);
        for k = 1:size(corr_matrix,2);
            corr_mat_plot(j,k) = nanmean(squeeze(corr_matrix(j,k,:)));
        end
    end

figure
imagesc(corr_mat_plot)

end

%% Return to original directory
cd(orig_dir);
end