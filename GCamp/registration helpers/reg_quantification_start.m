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


%% Step -1: Identify neurons that are active across all sessions and plot them out
% both as subplots AND cycle through to look for any that might not be the
% same across sessions after registration (can do this for each type of
% registration also...)

base_session = MD(81); % Session where batch_session_map for the sessions you want to look at resides

% Load base_session_map, iterate through sessions and create
% allBinBlobs_mask
ChangeDirectory_NK(base_session); 
load('batch_session_map')
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

% Plot out all active neuron mean masks for every session that all are
% active
disp('Constructing and plotting BinBlobs for all neurons active every session')
figure(101)
figure(1011)
for j = 1:num_sessions
   ChangeDirectory_NK(batch_session_map.session(j)); % 
   load('MeanBlobs.mat','BinBlobs')
      BinBlobs_temp{j} = BinBlobs(active_all_map(:,j));
   allseshactive_BinBlobsMask{j} = create_AllICmask(BinBlobs_temp{j});
   AllBinBlobs{j} = create_AllICmask(BinBlobs);
   session(j).allactive_BinBlobs = BinBlobs(active_all_map(:,j));
   figure(101)
   subplot_auto(num_sessions,j)
   imagesc(allseshactive_BinBlobsMask{j}); 
   title(['Session ' num2str(j)])
   figure(1011)
   subplot_auto(num_sessions,j)
   imagesc(allseshactive_BinBlobsMask{j} + AllBinBlobs{j}); 
   title(['Session ' num2str(j)])
    
end

clear BinBlobs
%% Register each session back to base
disp('Registering each BinBlobs mask to the base session via image_registerX')
ChangeDirectory_NK(base_session)
for j = 1:num_sessions
    
    if j > 1
        % Get appropriate filename for reginfo (make this a function for later
        % comparisons
        reginfo_filename = ['RegistrationInfo-' batch_session_map.session(j).Animal ...
            '-' batch_session_map.session(j).Date '-session' ...
            num2str(batch_session_map.session(j).Session) '.mat'];
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
disp('Now you can cycle through each session')
figure(102)
while ~ischar(j)
   imagesc(allactive_BinMask_reg{j});
   title(['Session ' num2str(j)])
   j = LR_cycle(j,[1 num_sessions],'get_out');
end


%% Step through neuron by neuron and get overlap and cm delta for each method

% Get cms for each neuron
for j = 1:num_sessions
   for k = 1: all_active_num
      stats_temp = regionprops(BinBlobs_reg{j}{k},'Centroid','PixelIdxList');
      neuron_cm{j}{k} = stats_temp.Centroid;
   end
   
end

% Calculating difference in centers-of-mass for these neurons
cm_dist = nan(num_sessions-1, num_sessions, all_active_num);
for k = 1:num_sessions-1
    for ll = k+1:num_sessions
        for j = 1:all_active_num
            cm_dist(k,ll,j) = pdist([neuron_cm{k}{j}; neuron_cm{ll}{j}]);
        end
    end
end

%% Plot out difference between 11/19/2014 sesh1 and 11/22/2014 sesh1 for each method
% Key 1 = Nat method, 2 = Turboreg using ICmin, 3 = turboreg using neurons
% Hard-code file locations for now
turbofile_regbyneurons = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working\Neuron Registration QC\landmarks_after_byneurons.txt';
turbofile_regbyICmin = 'J:\GCamp Mice\Working\G30\2env\11_19_2014\1 - 2env square left 201B\Working\Neuron Registration QC\landmarks_after_byICmin.txt';

% Get transforms from turbo-reg files
[ ~, ~, tform_compare{3} ] = import_treg_lmarks(...
    turbofile_regbyneurons);
[~, ~, tform_compare{2} ] = import_treg_lmarks(...
    turbofile_regbyICmin);

tform_compare{1} = tform_use(3).tform; % transform using Nat method

for j = 1:3
    for k = 1:all_active_num
        BinBlobs_compare_reg{j}{k} = imwarp(BinBlobs_temp{3}{k},tform_compare{j},...
            'OutputView',tform_use(2).base_ref,'InterpolationMethod','nearest');
    end
end

%% Step 0: Identify ~10 neurons that are in both sessions for sure AND create
% a) a binary matrix of all the cells (using create_AllICmask)
% b) a matrix with each neuron alone

%% Step 1: Import BinBlobs masks of reliable cells for reg and base files

%% Step 2: Transform BinBlobs masks 3 ways and plot side-by-side, subtracting
% the base session from each

%% Step 3: Step through neuron by neuron and get overlap and cm delta for each method

%% Step 4: Iterate through multiple sessions this way to quantify