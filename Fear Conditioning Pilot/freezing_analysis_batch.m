% Freezing analysis script
% To-do:
% 1) Make freezing analysis a function that spits out filter type,
% threshold, percentage time freezing, and average speed.  
% 2) Get appropriate measure for pixels-to-cm conversion
% 3) Get add-to-session-db script to add in arena extents
% 4) Add in arena extents to code, exclude any points outside of that
% 5) Initial comparisons - plots of baseline freezing versus coyote
% exposure freezing vs. 1 hour freezing (include a look at neutral contexts
% also.  Also, the same for controls versus FC group.
% 6) Get heat maps working in freezing_f!
% 7) Plot freezing in each condition (group/context vs. time)
% 8) Plot as individual animals and as groups!

clear all
close all

%%% FREEZING THRESHOLD
threshold = 0.05; % cm/s

% Calculate arena sizes in pixels from calibration files
% FC_size_cm = 25.4; % Actual measurement
% FC_arena_sizes_pix = 2*[56.1 54.1 51.9 54.8 54.7 54.1...
%     (mean([354.6 351.9]) - mean([243.8 242.4]))/2 (mean([316.3 319.1]) - mean([209.5 210.9]))/2 ...
%     56.1 54.1 56.1 52.7]; % these are all actual pixel measurements from calibration files
% avg_FC_pix = mean(FC_arena_sizes_pix);
% FC_pix_to_cm = FC_size_cm/avg_FC_pix;
% 
% neutral_size_cm = 25.4; % Actual measurement
% neutral_arena_sizes_pix = 2*[48.5 52.7];
% avg_neutral_pix = mean(neutral_arena_sizes_pix);
% neutral_pix_to_cm = neutral_size_cm/avg_neutral_pix;

FC_size_cm = 25.4;
avg_FC_pix = mean([275 300]);
FC_pix_to_cm = FC_size_cm/avg_FC_pix;

neutral_pix_to_cm = FC_pix_to_cm;

%% Load database file

[db_filename, db_folder] = uigetfile('*.mat',...
    'Select Existing Database File');

group = db_filename(1:end-7);
group_db = importdata([db_folder db_filename]);
analyzed_data.animal = group_db; % Duplicate file for storing analyzed freezing levels

% Parameters for what to run

pix_to_cm = FC_pix_to_cm;
plot_flag = 0;
frame_rate = 30; % frames per second

%% Loop through appropriate files, aggregate data
num_animals = size(group_db,2);
num_sessions = arrayfun(@(a) (size(a.session,2)),group_db);

for j = 1:num_animals
    for k = 1:num_sessions(j)
        freeze_ratio_k = [];
        avg_speed_k = [];
        filepath = group_db(j).session(k).DVTfilename;
        [freeze_ratio_k, avg_speed_k ] = freezing_f( filepath, frame_rate, ...
            threshold, pix_to_cm, plot_flag);
        disp(['Animal #' num2str(j) ' session #' num2str(k) ' processed']);
        
        analyzed_data.animal(j).session(k).threshold = threshold;
        analyzed_data.animal(j).session(k).frame_rate = frame_rate;
        analyzed_data.animal(j).session(k).freeze_ratio_k = freeze_ratio_k;
        analyzed_data.animal(j).session(k).avg_speed_k = avg_speed_k;
    end
end

%% Get group statistics
% Put all the necessary info into a nicely indexable array or cell
session_list = {};
context_list = {};
freezing_list = [];
speed_list = [];
for j = 1:num_animals
    clear temp_s temp_c temp_f temp_sp
    
    temp_s = arrayfun(@(a) a.session_name,analyzed_data.animal(j).session,...
        'UniformOutput',0);
    session_list = {session_list{:} temp_s{:}};
    
    temp_c = arrayfun(@(a) a.context,analyzed_data.animal(j).session,...
        'UniformOutput',0);
    context_list = {context_list{:} temp_c{:}};
    
    temp_f = arrayfun(@(a) a.freeze_ratio_k,analyzed_data.animal(j).session);
    freezing_list = [freezing_list temp_f];
    
    temp_sp = arrayfun(@(a) a.avg_speed_k,analyzed_data.animal(j).session);
    speed_list = [speed_list temp_sp];
    
    
end

% Get unique sessions/contexts
session_unique = unique(session_list); num_sessions = size(session_unique,2);
context_unique = unique(context_list); num_contexts = size(context_unique,2);

% Calculate statistics
for j = 1:num_sessions
    session_index = strcmp(session_list,session_unique{j}); % index for appropriate session
    for k = 1:num_contexts
        context_index = strcmp(context_list,context_unique{k}); % index for appropriate context
        con_ses_index = session_index & context_index; % index for appropriate context & session
        group_ses_index = num_contexts*(j-1) + k;
        analyzed_data.group_session(group_ses_index).name = session_unique{j};
        analyzed_data.group_session(group_ses_index).context_name = context_unique{k};
        analyzed_data.group_session(group_ses_index).threshold = threshold;
        analyzed_data.group_session(group_ses_index).freeze_ratio_mean = ...
            mean(freezing_list(con_ses_index));
        analyzed_data.group_session(group_ses_index).freeze_ratio_std = ...
            std(freezing_list(con_ses_index));
        analyzed_data.group_session(group_ses_index).freeze_ratio_all = ...
            freezing_list(con_ses_index);
        analyzed_data.group_session(group_ses_index).speed_mean = ...
            mean(speed_list(con_ses_index));
        analyzed_data.group_session(group_ses_index).speed_std = ...
            std(speed_list(con_ses_index));
        analyzed_data.group_session(group_ses_index).speed_all = ...
            speed_list(con_ses_index);
    
    end
end
%% Save Data to .mat file

disp(['DATABASE ANALYZED: ' db_filename])
disp(['Freezing threshold: ' num2str(threshold) ' cm/s'])
save_folder = uigetdir(db_folder,'Select Folder in which to save analyzed data:');
save_filename = input('Enter base filename for data: ','s');
if isempty(regexp(save_filename,'.mat'))
    save_filename = [save_filename '.mat'];
else
end

save([save_folder '\' save_filename], 'analyzed_data')

