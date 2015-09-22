function [corr_matrix, pop_corr_struct, pass_thresh, corr_win] = tmap_corr_across_days(working_dir,varargin)
% [corr_matrix] = tmap_corr_across_days(working_dir,varargin)
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
%% Sampling Rate
SR = 20; %fps


%% Get varargins
rotate_to_std = 0; % default
population_corr = 0; % default
trans_rate_thresh = 0; % default
plot_confusion_matrix = 0; % default
pval_thresh = 0; % default
archive_name_append = [];
within_session = 0; % default
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

disp('Loading TMaps for each session')
for j = 1:num_sessions
   ChangeDirectory(Animal, sesh(j).date,...
       sesh(j).session);
   if rotate_to_std == 0
       load(['PlaceMaps' archive_name_append '.mat'],'TMap','pval');
   elseif rotate_to_std == 1
       load(['PlaceMaps_rot_to_std' archive_name_append '.mat'],'TMap','pval');
   end
   sesh(j).TMap = TMap;
   sesh(j).TMap_half = TMap_half;
   sesh(j).pval_use = 1-pval;
   sesh(j).pval_pass = sesh(j).pval_use <= pval_thresh;
   % Get transient rates and those that pass the threshold
   load('ProcOut.mat','NumTransients','NumFrames');
   sesh(j).trans_rate = NumTransients/(NumFrames/SR);
   sesh(j).trans_rate_pass = sesh(j).trans_rate >= trans_rate_thresh;
       
end


%% 3) Get correlations between the TMaps for all cells across each day.  

% Visualize with individual cell and all cell confusion matrices? Or just
% bar graphs for day 1 to day 2, day 2 to day 3, and day 1 to day 3?

disp('Getting inter-session correlations (individual neurons)')
pass_count = zeros(num_sessions, num_sessions, num_neurons);
for j = 1:num_neurons
    n = 0;
    for k = 1:num_sessions
        for ll = k:num_sessions
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
                    if sesh1_thresh_pass && sesh2_thresh_pass
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

if population_corr == 1
    disp('Getting inter-session population correlations')
    for k = 1:num_sessions
        for ll = k:num_sessions
            sesh1_pop = [];
            sesh2_pop = [];
            for j = 1:num_neurons
                sesh1_neuron = batch_session_map(1).map(j,k+1);
                sesh2_neuron = batch_session_map(1).map(j,ll+1);
                % Insert additional check here with a varargin to filter
                % out neurons that don't meet certain criteria? e.g.
                % transient rate and/or information criteria?
                
                if (sesh1_neuron ~= 0) && (sesh2_neuron ~= 0) && ~isnan(sum(sesh(k).TMap{sesh1_neuron}(:))) && ~isnan(sum(sesh(ll).TMap{sesh2_neuron}(:)))% ~isempty(sesh1_neuron) && ~isempty(sesh2_neuron) && ~isnan(sesh1_neuron) && ~isnan(sesh2_neuron)
                    sesh1_pop = [sesh1_pop; sesh(k).TMap{sesh1_neuron}(:)];
                    sesh2_pop = [sesh2_pop; sesh(ll).TMap{sesh2_neuron}(:)];
                end
                
            end
            [r_temp, p_temp] = corrcoef(sesh1_pop,sesh2_pop);
            pop_corr(k,ll) = r_temp(1,2);
            p_pop_corr(k,ll) = p_temp(1,2);
        end
    end
    
    pop_corr_struct.r = pop_corr;
    pop_corr_struct.p = p_pop_corr;
end

%% 4) Within session controls...
if within_session == 1
    disp('Calculating Within session correlations')
    for j = 1:num_sessions
        % Get neurons that have non-NaN placefields in both halves
        ok = cellfun(@(a,b) sum(isnan(a(:))) == 0 & sum(isnan(b(:))) == 0, sesh(j).TMap_half(1).Tmap, sesh(j).TMap_half(2).Tmap);
        ok_ind = find(ok);
        % Get within session correlations
        for k = 1:length(ok_ind)
            temp = corrcoef(sesh(j).TMap_half(1).Tmap(:), sesh(j).TMap_half(2).Tmap(:));
            corr_win(j) = temp(1,2);
        end
    end
end

%% 5) Now do above for shuffled neuron identity if desired...
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
