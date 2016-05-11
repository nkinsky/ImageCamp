% Compare registrations 3 ways:
% 1) Using ICmin with Nat's functions
% 2) Using ICmin with Turboreg
% 3) Using neuron masks with Turboreg
%
% Quantify by identifying ~10 of the same neurons that are DEFINITELY the
% same across both sessions and calculating the %overlap and delta_cm for
% each (make SURE that they are the same by using Solidity and/or Major
% Axis direction and hopefully using those that are isolated from other
% neurons)

% Next step: make compatible with neuron maps formed by jittering the
% registered session intentionally

% If you want to run with jitter, specify here

% Other steps:
% 1) All the above quantifies how well our method works for image
% registration - run a comparison of some sort across all our sessions and
% compare to using neuron ROIs to register.  Maybe make it able to do
% either? YES - then if you have a mouse with no good landmarks this will
% work well.  DON'T do if you get good agreement between two methods for
% G27 (who has very few good landmarks)
%   plot differences between our method and others somehow?
%
% 2) For neuron registration:
%   - quantify average overlap and centroid distance across many sessions,
%   plot as a bar graph and scatter plot?
%   - using real data, plot how much you can intenionally shift the image
%   registration and what happens to a) centroid distance, b) overlap, and
%   c) place field correlations for a stable/non-remapping session.  At
%   what point do the values go to zero?
%
% 3) Plot what happens to centroid diffs for a systematic shift? e.g. if I
% move the image 3 pixels to the right, do I see that the average centroid
% vector also points 3 pixels to the right?
%
% 4) quantify average numbers for how many neurons pass the transitive test
% based on number of sessions...

close all
%% Specifications for running with transform intentionally jittered
run_with_jitter = 1;
batch_map_file = 'batch_session_map';
name_append = '';
if run_with_jitter == 1
    batch_map_file = 'batch_session_map_wjitter';
    name_append = '_wjitter';
end

%% Step -1: Identify neurons that are active across all sessions and plot them out
% both as subplots AND cycle through to look for any that might not be the
% same across sessions after registration (can do this for each type of
% registration also...)

base_session = MD(ref.G30.two_env(1)); % Session where batch_session_map for the sessions you want to look at resides

% Load base_session_map, iterate through sessions and create
% allBinBlobs_mask
ChangeDirectory_NK(base_session); 
load(batch_map_file)
num_sessions = length(batch_session_map.session);
% Fix dumb mistake in constructing batch_session_map.session
[batch_session_map.session.Animal] = deal(batch_session_map.session.mouse);
[batch_session_map.session.Date] = deal(batch_session_map.session.date);
[batch_session_map.session.Session] = deal(batch_session_map.session.session);

% Get neurons that are active all sessions
active_all_sessions = find(sum(batch_session_map.map(:,2:end) > 0,2)...
    == size(batch_session_map.map(:,2:end),2));
active_all_map = batch_session_map.map(active_all_sessions,2:end); % Each column is the neuron number for that session
all_active_num = size(active_all_map,1);
num_neurons_total = size(batch_session_map.map,1);

% Plot out all active neuron mean masks for every session that all are
% active

disp('Constructing and plotting BinBlobs for all neurons active every session')
figure(101)
figure(1011)
BinBlobs_temp = cell(1,num_sessions);
AllBinBlobs = cell(1,num_sessions);
allseshactive_BinBlobsMask = cell(1,num_sessions);
for j = 1:num_sessions
   ChangeDirectory_NK(batch_session_map.session(j)); % 
   load('MeanBlobs.mat','BinBlobs')
      BinBlobs_temp{j} = BinBlobs(active_all_map(:,j));
   allseshactive_BinBlobsMask{j} = create_AllICmask(BinBlobs_temp{j});
   AllBinBlobs{j} = create_AllICmask(BinBlobs);
   session(j).allactive_BinBlobs = BinBlobs(active_all_map(:,j));
   figure(101)
   h1(j) = subplot_auto(num_sessions,j);
   imagesc(allseshactive_BinBlobsMask{j}); 
   title(['Session ' num2str(j)])
   figure(1011)
   h2(j) = subplot_auto(num_sessions,j);
   imagesc(allseshactive_BinBlobsMask{j} + AllBinBlobs{j}); 
   title(['Session ' num2str(j)])
    
end
linkaxes(h1); linkaxes(h2);

clear BinBlobs

%% Register each session back to base
disp('Registering each BinBlobs mask to the base session via image_registerX')
ChangeDirectory_NK(base_session);

allactive_BinMask_reg = cell(1,num_sessions);
BinBlobs_reg = cell(1,num_sessions);
for j = 1:num_sessions
    
    if j > 1
        % Get appropriate filename for reginfo (make this a function for later
        % comparisons
        reginfo_filename = ['RegistrationInfo-' batch_session_map.session(j).Animal ...
            '-' batch_session_map.session(j).Date '-session' ...
            num2str(batch_session_map.session(j).Session) name_append '.mat'];
        temp = importdata(reginfo_filename);
        tform_use(j).tform = temp.tform;
        tform_use(j).base_ref = temp.base_ref;
        % Register each mask to the base session
        allactive_BinMask_reg{j} = imwarp(allseshactive_BinBlobsMask{j},tform_use(j).tform,...
            'OutputView',tform_use(j).base_ref,'InterpolationMethod','nearest');
        for k = 1:all_active_num
            BinBlobs_reg{j}{k} = imwarp(BinBlobs_temp{j}{k},tform_use(j).tform,...
                'OutputView',tform_use(j).base_ref,'InterpolationMethod','nearest');
        end
    elseif j == 1
        allactive_BinMask_reg{1} = allseshactive_BinBlobsMask{1};
        BinBlobs_reg{1} = BinBlobs_temp{1};
    end
    
end

% clear BinBlobs_temp
%% Cycle through each session to see if neurons appear/disappear/change shape, etc.
% (basically look for anything that could indicate a bad registration)
run_this1 = 0;

if run_this1 == 1
disp('Now you can cycle through each session')
figure(102)
stay_in = true;
while stay_in
   imagesc(allactive_BinMask_reg{j});
   title(['Session ' num2str(j)])
   [j, stay_in] = LR_cycle(j,[1 num_sessions]);
end

end


%% Step through neuron by neuron and get overlap and cm delta for each method

num_shuffles = 100;

if run_with_jitter == 0
    [ neuron_cm, cm_dist, neuron_axisratio, ratio_diff, neuron_orientation, ...
    orientation_diff ] = dist_bw_reg_sessions( BinBlobs_reg );
elseif run_with_jitter == 1
    [ neuron_cm_jitter, cm_dist_jitter, neuron_axisratio_jitter, ratio_diff_jitter, neuron_orientation_jitter, ...
    orientation_diff_jitter ] = dist_bw_reg_sessions( BinBlobs_reg );
end

% Note that this just shuffles neuron identify from session to session -
% not a very good shuffling comparison... we would expect huge differences
% if this happened.
cm_dist_shuffle = [];
ratio_diff_shuffle = [];
orientation_diff_shuffle = [];
disp('Shuffling Neurons for distance, axis ratio, and orientation comparisons')
for j = 1:num_shuffles
    if round(j/10) == (j/10)
        disp(['Performing Shuffle ' num2str(j) ' of ' num2str(num_shuffles)])
    end
    [ ~, cm_dist_temp, ~, ratio_diff_temp, ~, ...
        orientation_diff_temp ] = dist_bw_reg_sessions( BinBlobs_reg,1 );
    cm_dist_shuffle = cat(3,cm_dist_shuffle,cm_dist_temp);
    ratio_diff_shuffle = cat(3,ratio_diff_shuffle,ratio_diff_temp);
    orientation_diff_shuffle = cat(3,orientation_diff_shuffle,orientation_diff_temp);
end

% Need to get stats on the above and differences between null hypothesis
% (random mappings of neurons).

% ALSO - need to get stats against null distribution that neuron is mapped
% to 2nd closest neuron (e.g. that image registration is off) and see what
% happens!!!

%% Place-field checks

PF_thresh = 0.9;

% Fix batch_session_map if old
batch_session_map = fix_batch_session_map(batch_session_map);

% Load up all the necessary variables
curr_dir = cd;
TMap_use = cell(1,num_sessions);
map_use = cell(1,num_sessions);
PFcentroid_use = cell(1,num_sessions);
for j = 1:num_sessions
    ChangeDirectory_NK(batch_session_map.session(j))
    load('PlaceMaps.mat','TMap_gauss');
    map_use{1,j} = batch_session_map.map(:,j+1);
    TMap_use{j} = TMap_gauss;
    PFcentroid_use{1,j} = get_PF_centroid(TMap_use{j},PF_thresh);
end
cd(curr_dir);

% Get distance to closest place-field in different session
% min_dist_temp = cell(1,num_sessions);
% for j = 1:num_sessions
%     min_dist_temp{1,j} = get_PF_centroid_diff(PFcentroid_use{1},...
%         PFcentroid_use{j},map_use{1,j},1);
%     
% end

disp('Getting distances between PF centroids for all sessions')
min_dist_temp = cell(num_sessions,num_sessions);
for j = 1:num_sessions-1
    for k = j + 1: num_sessions
        map_use = get_neuronmap_from_batchmap(batch_session_map.map,j,k);
        min_dist_temp{j,k} = get_PF_centroid_diff(PFcentroid_use{j}, ...
            PFcentroid_use{k}, map_use,1);
    end
end


if run_with_jitter == 0
    min_dist = min_dist_temp;
elseif run_with_jitter == 1
    min_dist_jitter = min_dist_temp;
end



%% Now calculate shuffled distributions

disp('Shuffling neurons for Place-field Comparisons')
min_dist_shuffle = [];
for j = 1:num_shuffles
    
    if round(j/10) == (j/10)
        disp(['Performing Shuffle ' num2str(j) ' of ' num2str(num_shuffles)])
    end
    
    for k = 1:num_sessions
        map_use_shuffle = batch_session_map.map(:,k+1);
        ind_use = find(map_use_shuffle ~=0); 
        map_use_shuffle(ind_use) = map_use_shuffle(ind_use(randperm(length(ind_use))));
        min_dist_temp2(:,k) = get_PF_centroid_diff(PFcentroid_use{1},...
            PFcentroid_use{k},map_use_shuffle,1);
    end
    min_dist_shuffle = [min_dist_shuffle; min_dist_temp2(:)];
end

%% Plot metrics after running with and without jitter

reg_plot_metrics

%% Plot out difference between 11/19/2014 sesh1 and 11/22/2014 sesh1 for each method
% Key 1 = base file, 2 = Nat method, 3 = Turboreg using ICmin, 4 = turboreg using neurons
% Hard-code file locations for now
tform_check = 0; % set to 1 if you want to scroll through neurons

turbofile_regbyneurons = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working\Neuron Registration QC\landmarks_after_byneurons.txt';
turbofile_regbyICmin = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working\Neuron Registration QC\landmarks_after_byICmin.txt';

% Get transforms from turbo-reg files
[ ~, ~, tform_compare{4} ] = import_treg_lmarks(...
    turbofile_regbyneurons);
[~, ~, tform_compare{3} ] = import_treg_lmarks(...
    turbofile_regbyICmin);

tform_compare{2} = tform_use(3).tform; % transform using Nat method

BinBlobs_compare_reg = cell(1,4);
BinBlobs_compare_reg{1} = BinBlobs_reg{1};
for j = 2:4
    for k = 1:all_active_num
        BinBlobs_compare_reg{j}{k} = imwarp(BinBlobs_temp{3}{k},tform_compare{j},...
            'OutputView',tform_use(2).base_ref,'InterpolationMethod','nearest');
    end
end

[ compare_neuron_centroid, compare_centroid_dist ] = dist_bw_reg_sessions( BinBlobs_compare_reg );

%% Optional - scroll through and compare registrations from above
if tform_check == 1
    temp_plot = zeros(size(BinBlobs_compare_reg{1}{1}));
    figure(10)
    for neuron_plot = 1:all_active_num
        temp_plot = temp_plot + BinBlobs_compare_reg{1}{neuron_plot} + 2*BinBlobs_compare_reg{4}{neuron_plot};
        imagesc(temp_plot);
        hold on;
        colorbar;
        waitforbuttonpress;
    end
end

%% Follow-up 
% 1) Compare all three methods using only neurons that we are SURE are the
% same across all sessions and are well isolated from others...
% 2) It would be a bear, but registering by neurons and then seeing if the
% mapping is the same would be the best comparison

%% Step 4: Iterate through multiple sessions this way to quantify