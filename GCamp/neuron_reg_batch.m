function [ batch_session_map ] = neuron_reg_batch(base_struct, reg_struct)
% neuron_reg_batch(base_struct, reg_struct)
%   Registers the neurons in reg_struct to base_struct and also too each
%   other.  It runs through this two way: 1) by always registering each
%   neuron to the base session, or for new neurons found after the first
%   registration, to the oldest session, and 2) by always updating each
%   neuron mask to the most recently registered neuron.  After this, it
%   compares the two methods and only keeps those that are the same between
%   the two sessions.
%
% INPUTS:
%       base_struct: data structure (length 1) with .Animal (string), .Date (string,
%       DD_MM_YYYY), and .Session (integer) pointing to the base session.
%
%       reg_struct: same as base_struct, but with as many entries as
%       sessions you wish to analyze.  NOTE that if base_struct OR
%       reg_struct are left blank, you will be prompted to enter in the
%       locations of the ICmovie_min_proj.tif files you wish to register
%       manually!
%
% OUTPUTS:
%       

%% Step 1: Run multi_image_reg twice, once with update_masks = 0 and once with update_masks = 1

reg_filename{1} = fullfile(base_struct.Location,'Reg_NeuronIDs_updatemasks0.mat');
reg_filename{2} = fullfile(base_struct.Location,'Reg_NeuronIDs_updatemasks1.mat');

disp('Checking for pre-existing registration files')
for j = 1:2
    if (exist(reg_filename{j},'file') == 2)
        load(reg_filename{j})
        intact = RegNeuron_intact(Reg_NeuronIDs, base_struct, reg_struct);
    else 
        intact = 0;
    end
    
    if intact == 1
        disp([ 'Reg_NeuronIDs with update_masks = ' num2str(j-1) ' found in the working directory, skipping neuron registration.'])
    elseif intact == 0
        disp(['Running registration with update masks = ' num2str(j-1)])
        multi_image_reg(base_struct, reg_struct, 'update_masks', j-1);
    end
end

% if (exist(reg_filename{2},'file') == 2)
%     disp('Reg_NeuronIDs with update_masks = 1 found in the working directory, skipping neuron registration.')
% else
%     disp('Running registration with update masks = 1')
%     multi_image_reg(base_struct, reg_struct, 'update_masks', 1);
% end

%% Step 2: Load files

disp('Loading registration mapping files')
for j = 1:2
    load(reg_filename{j})
    Reg_NeuronID_trans(j).Reg_NeuronIDs = Reg_NeuronIDs;
    all_session_map(j).map = Reg_NeuronIDs(1).all_session_map;
end

keyboard
%% Step 3: Transitive test -  go through each neuron...find 
% it in the 2nd all_neuron_map and look for matches to the neurons from the
% 1st all_neuron_map. Most Strict (1) = toss all neurons that don't match for ALL
% subsequent sessions.  Strict (2) = toss only the neuron mappings from a
% given session that don't match (e.g. if session 1, 3, and 5 are the same
% between the two registrations, keep those mappings and toss session 2 and
% 4 mappings)

% First, send all_neuron_map to an array rather than a cell so that you can
% do comparisons easier
for m = 1:2
    for j = 1:size(all_session_map(m).map,1)
        for k = 1:size(all_session_map(m).map,2)
            if ~isempty(all_session_map(m).map{j,k}) && ~isnan(all_session_map(m).map{j,k})
                test(m).map(j,k) = all_session_map(m).map{j,k};
            else
                test(m).map(j,k) = 0;
            end
        end
    end
end

max_neuron_num = max(test(1).map,[],1);

% march through each neuron and do the transitive test. 1 = very stringent,
% 2 = stringent.
trans_test1 = zeros(size(test(1).map,1));
trans_test2 = ones(size(test(1).map));
row_end = 0;
for i = 2:length(max_neuron_num)
    row_start = row_end + 1; % Row/neuron number to start with
    row_end = find(test(1).map(:,i),1,'last'); % Row/neuron number to end with
    
    for j = row_start:row_end
        % find matching neuron row in test(2)
        row_ind_use = test(2).map(:,i) == test(1).map(j,i);
        if ~isempty(row_ind_use) &&  sum(row_ind_use) == 1 % put ones every session where the two neuron mappings match
            % effectively identifying each neuron that maps the same
            trans_test2(j,:) = test(1).map(j,:) == test(2).map(row_ind_use,:);
            % see if all session mappings for that neuron pass the transitive test
            trans_test1(j) = sum(trans_test2(j,:)) == length(trans_test2(j,:));
        else % Send everything to zeros if it doesn't match anywhere!
            trans_test2(j,:) = zeros(size(test(1).map(j,:)));
        end
        
    end
    
end

ok_orig2 = test(1).map > 0; % Get all valid neuron mappings to other neurons
ok_after2 = trans_test2.*ok_orig2; % Get all valid mappings post-test, excluding neurons that were empty or nan to begin with

trans1_ratio_pass = sum(trans_test1(:))/length(trans_test1);
trans2_ratio_pass = sum(ok_after2(:))/sum(ok_orig2(:));

%% Step 4: Parse out/keep only the mappings that pass the transitive test 
% and spit those out / save them

batch_session_map(1).map = trans_test2.*test(1).map;
batch_session_map(1).map(:,1) = [1:size(batch_session_map(1).map,1)]';
% Send all session info to stay with the map
[batch_session_map(1).session(1).mouse] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(1).mouse;
[batch_session_map(1).session(1).date] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(1).base_date;
[batch_session_map(1).session(1).session] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(1).base_session;

[batch_session_map(1).session(2:length(Reg_NeuronID_trans(1).Reg_NeuronIDs)+1).mouse] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(:).mouse;
[batch_session_map(1).session(2:length(Reg_NeuronID_trans(1).Reg_NeuronIDs)+1).date] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(:).reg_date;
[batch_session_map(1).session(2:length(Reg_NeuronID_trans(1).Reg_NeuronIDs)+1).session] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(:).reg_session;

batch_session_map(1).AllMasksMean = 'Located in RegNeuronIDs_updatemasks0.mat';

base_dir = ChangeDirectory(base_struct(1).Animal, base_struct(1).Date, base_struct(1).Session);
save(fullfile(base_dir,'batch_session_map.mat'),'batch_session_map')

end