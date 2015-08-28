function [corr_matrix] = tmap_corr_across_days(working_dir,varargin)
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
%   OUTPUTS:
%
%       corr_matrix: an n x n x num_neurons matrix where n = the total number of
%       sessions, where entry corr_matrix(i,j,k) is the correlation of TMaps
%       for neuron k between the ith and jth sessions.
%

%% Get varargins
rotate_to_std = 0;
for j = 1:length(varargin)
   if strcmpi(varargin{j},'rotate_to_std')
       rotate_to_std = varargin{j+1};
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
       load('PlaceMaps.mat','TMap');
   elseif rotate_to_std == 1
       load('PlaceMaps_rot_to_std.mat','TMap');
   end
   sesh(j).TMap = TMap;
       
end

%% 3) Get correlations between the TMaps for all cells across each day.  

% Visualize with individual cell and all cell confusion matrices? Or just
% bar graphs for day 1 to day 2, day 2 to day 3, and day 1 to day 3?

disp('Getting inter-session correlations')
for j = 1:num_neurons
    n = 0;
    for k = 1:num_sessions
        for ll = k:num_sessions
            sesh1_neuron = batch_session_map(1).map(j,k+1);
            sesh2_neuron = batch_session_map(1).map(j,ll+1);
            % Get the correlations only if both neurons are validly mapped
            if (sesh1_neuron ~= 0) && (sesh2_neuron ~= 0) % ~isempty(sesh1_neuron) && ~isempty(sesh2_neuron) && ~isnan(sesh1_neuron) && ~isnan(sesh2_neuron)
                temp = corrcoef(sesh(k).TMap{sesh1_neuron}(:),...
                    sesh(ll).TMap{sesh2_neuron}(:));
                corr_matrix(k,ll,j) = temp(1,2);
                n = n + 1;
            else
                corr_matrix(k,ll,j) = nan;
            end
        end
        
    end
    corr_numbers(k,ll,j) = n;
end

%% Plot

for j = 1:size(corr_matrix,1);
    for k = 1:size(corr_matrix,2);
        corr_mat_plot(j,k) = nanmean(squeeze(corr_matrix(j,k,:)));
    end
end

figure
imagesc(corr_mat_plot)

%% Return to original directory
cd(orig_dir);
