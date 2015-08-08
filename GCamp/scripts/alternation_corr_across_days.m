% Script to get correlations between all sessions that pass the transitive
% test

working_dir = uigetdir('Pick your working directory:');
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
   load('PlaceMaps.mat','TMap');
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
