% ANTIQUATED!!!
% Script to get correlations between all sessions that pass the transitive
% test

%% 0) Get started
num_shuffles = 10;
rotate_to_std = 0;
orig_dir = cd;
working_dir = uigetdir('Pick your working directory:');
%% 1) Load both Reg_NeuronID files (updatemasks = 0 and updatemasks = 1).
disp('Loading Reg_NeuronIDs and batch_session_map')

% load(fullfile(working_dir,'Reg_NeuronIDs_updatemasks0.mat')) % Load Masks - is this even necessary?
load(fullfile(working_dir,'batch_session_map.mat'));

num_neurons = size(batch_session_map(1).map,1);
num_sessions = length(batch_session_map(1).session);


%% 2) Get base directory and directories of all the subsequent registered sessions, ...
% & load up the TMaps for each of these sessions

Animal = batch_session_map(1).session(1).Animal;
sesh = batch_session_map(1).session;

disp('Loading TMaps for each session')
for j = 1:num_sessions
   ChangeDirectory(Animal, sesh(j).Date,...
       sesh(j).Session);
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
corr_matrix = nan(num_sessions, num_sessions, num_neurons);
corr_numbers = nan(num_sessions, num_sessions, num_neurons);
p = ProgressBar(num_neurons);
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
    p.progress;
end
p.stop;

%%
disp('Getting inter-session shuffled correlations')
corr_matrix_shuf = nan(num_sessions, num_sessions, num_neurons, num_shuffles);
corr_numbers_shuf = nan(num_sessions, num_sessions, num_neurons, num_shuffles);

p = ProgressBar(num_shuffles);
for s = 1:num_shuffles
    % Create shuffled map
    shuffle_map = nan(size(batch_session_map(1).map));
    for ll = 1:num_sessions
        shuffle_map(:,ll+1) = batch_session_map(1).map(randperm(num_neurons),...
            ll+1);
    end
    
    for j = 1:num_neurons
        n = 0;
        
        for k = 1:num_sessions
            for ll = k:num_sessions
                sesh1_neuron = batch_session_map(1).map(j,k+1);
                sesh2_neuron = shuffle_map(j,ll+1);
                % Get the correlations only if both neurons are validly mapped
                if (sesh1_neuron ~= 0) && (sesh2_neuron ~= 0) % ~isempty(sesh1_neuron) && ~isempty(sesh2_neuron) && ~isnan(sesh1_neuron) && ~isnan(sesh2_neuron)
                    temp = corrcoef(sesh(k).TMap{sesh1_neuron}(:),...
                        sesh(ll).TMap{sesh2_neuron}(:));
                    corr_matrix_shuf(k,ll,j,s) = temp(1,2);
                    n = n + 1;
                else
                    corr_matrix_shuf(k,ll,j,s) = nan;
                end
            end
            
        end
        corr_numbers_shuf(k,ll,j,s) = n;
    end
    p.progress;
end
p.stop;

%% Plot

corr_mat_plot = nan(num_sessions,num_sessions);
day_plot = corr_mat_plot;
for j = 1:size(corr_matrix,1)
    for k = j:size(corr_matrix,2)
        corr_mat_plot(j,k) = nanmean(squeeze(corr_matrix(j,k,:)));
        day_plot(j,k) = get_time_bw_sessions(batch_session_map.session(j),...
            batch_session_map.session(k));
    end
end

figure
imagesc(corr_mat_plot)

%% Gather corr values by days

%% Return to original directory
cd(orig_dir);
