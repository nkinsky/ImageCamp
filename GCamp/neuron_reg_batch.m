function [ batch_session_map ] = neuron_reg_batch(base_struct, reg_struct, varargin)
% batch_session_map = neuron_reg_batch(base_struct, reg_struct, varargin)
%   Registers the neurons in reg_struct to base_struct and also to each
%   other.  It runs through this two ways: 1) by always registering each
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
%       sessions you wish to analyze.  
%
%       varargins
%       'name_append': a string that is appended onto batch_session_map. 
%
%       'use_neuron_masks': 1 = use neuron masks to register between
%       sessions. 0 (default) = use minimum projection
%
%       'use_alternate_reg': see neuron_register
%
%       'add_jitter': see neuron_register
%
% OUTPUTS:
%
%       batch_session_map:
%           .map: rows are neuron number, columns contain the neuron from
%           each session that maps to that neuron.  1st column is the overall
%           index, 2nd row is the 1st registered session, ...
%   
%           .session: record of each session
%
%           trans_test_ratios: proportion of neuron mappings surviving the
%           transitive test. Most Strict (1) = toss all neurons that don't 
%           match for ALL subsequent sessions.  Strict (2) = toss only the 
%           neuron mappings from a given session that don't match (e.g. if
%           session 1, 3, and 5 are the same between the two registrations, 
%           keep those mappings and toss session 2 and 4 mappings)
%
%
%% Parse Inputs
p = inputParser;

p.addRequired('base_struct', @isstruct);
p.addRequired('reg_struct', @isstruct);
p.addParameter('use_neuron_masks', false, @(a) islogical(a) ...
    || a == 1 || a == 0);  %default = false
p.addParameter('name_append', '', @ischar); % default = ''
p.addParameter('alt_reg', [], @(x) isempty(x) || validateattributes(x,{'numeric'},...
    {'size',[3,3]})); % default = no alternative tform
p.addParameter('add_jitter', [], @(x) isempty(x) || validateattributes(x,{'numeric'},...
    {'size',[3,3]})); % default = no jitter added

p.parse(base_struct, reg_struct, varargin{:});

use_neuron_masks = p.Results.use_neuron_masks;
name_append = p.Results.name_append;
alt_reg_tform = p.Results.alt_reg;
jitter_mat = p.Results.add_jitter;

%% Step 1: Run multi_image_reg twice, once with update_masks = 0 and once with update_masks = 1
base_struct.Location = ChangeDirectory(base_struct.Animal, base_struct.Date,...
    base_struct.Session, 0);

reg_filename{1} = fullfile(base_struct.Location,['Reg_NeuronIDs_updatemasks0' name_append '.mat']);
reg_filename{2} = fullfile(base_struct.Location,['Reg_NeuronIDs_updatemasks1' name_append '.mat']);

disp('Checking for pre-existing registration files')
for j = 1:2
    if (exist(reg_filename{j},'file') == 2)
        load(reg_filename{j})
        intact = RegNeuron_intact(Reg_NeuronIDs, base_struct, reg_struct);
    else 
        intact = 0;
    end
    
    if intact == 1
        disp([ 'Reg_NeuronIDs with update_masks = ' num2str(j-1) ...
            ' & use_neuron_masks = ' num2str(use_neuron_masks) ...
            ' found in the working directory, skipping neuron registration.'])
    elseif intact == 0
        disp(['Running neuron registration with update masks = ' num2str(j-1) ...
            ' & use_neuron_masks = ' num2str(use_neuron_masks)])
        multi_neuron_reg(base_struct, reg_struct, 'update_masks', j-1,'use_neuron_masks',...
            use_neuron_masks, 'alt_reg', alt_reg_tform, ...
            'add_jitter', jitter_mat,'name_append',name_append);
    end
end

%% Step 2: Load files

disp('Loading neuron registration mapping files')
for j = 1:2
    load(reg_filename{j})
    Reg_NeuronID_trans(j).Reg_NeuronIDs = Reg_NeuronIDs;
    all_session_map(j).map = Reg_NeuronIDs(1).all_session_map;
end

% keyboard
%% Step 3: Transitive test -  go through each neuron...find 
% it in the 2nd all_neuron_map and look for matches to the neurons from the
% 1st all_neuron_map. 

% First, send all_neuron_map to an array rather than a cell so that you can
% do comparisons easier
for m = 1:2
    for j = 1:size(all_session_map(m).map,1)
        for k = 1:size(all_session_map(m).map,2)
            if ~isempty(all_session_map(m).map{j,k}) % && ~isnan(all_session_map(m).map{j,k})
                test(m).map(j,k) = all_session_map(m).map{j,k};
            else
                test(m).map(j,k) = 0;
            end
        end
    end
end

max_neuron_num = max(test(1).map,[],1);
num_sessions = length(max_neuron_num);

% Next, march through each neuron and do the transitive test. 1 = very stringent,
% 2 = stringent.
trans_test1 = zeros(size(test(1).map,1));
trans_test2 = ones(size(test(1).map));
row_end = 0;
for i = 2:num_sessions
    % Step through all the valid rows/neurons in session i, comparing the
    % mapping with updatemasks = 1 to updatemasks = 2.  Then, step through
    % only the newly added neurons for the next session, and so forth.
    % Could probably just pull this info from Reg_NeuronIDs...
    row_start = row_end + 1; % Row/neuron number to start with
    row_end = find(test(1).map(:,i) > 0 | isnan(test(1).map(:,i)), ...
        1,'last'); % Row/neuron number to end with (last row with a non-zero or nan entry)
    
    row_end_save(i) = row_end; % For debugging/internal information only
    row_start_save(i) = row_start;
    
    for j = row_start:row_end
        % find matching neuron row in test(2)
        row_ind_use = test(2).map(:,i) == test(1).map(j,i);
        if ~isempty(row_ind_use) &&  sum(row_ind_use) == 1 % put ones every session where the two neuron mappings match
            % effectively identifying each neuron that maps the same
            trans_test2(j,:) = test(1).map(j,:) == test(2).map(row_ind_use,:)...
                | (isnan(test(1).map(j,:)) & isnan(test(2).map(row_ind_use,:))); % Put ones wherever both reg types map the same
            % see if all session mappings for that neuron pass the transitive test
            trans_test1(j) = sum(trans_test2(j,:)) == length(trans_test2(j,:));
        else % Send everything to zeros if it doesn't match anywhere! - edge case
            trans_test2(j,:) = zeros(size(test(1).map(j,:)));
        end
        
    end
    
end

ok_orig2 = test(1).map > 0 & ~isnan(test(1).map); % Get all valid neuron mappings to other neurons
ok_after2 = trans_test2.*ok_orig2; % Get all valid mappings post-test, excluding neurons that were empty or nan to begin with

trans1_ratio_pass = sum(trans_test1(:))/length(trans_test1);
trans2_ratio_pass = sum(ok_after2(:))/sum(ok_orig2(:));

%% Step 4: Parse out/keep only the mappings that pass the transitive test 
% and spit those out / save them

% multiple each element of the map by either a 1 or a 0 if it passes or if
% it doesn't
batch_session_map(1).map = trans_test2.*test(1).map; 
% batch_session_map(1).map(isnan(test(1).map)) = 0; % Send all nans to zeros also
batch_session_map(1).map(:,1) = [1:size(batch_session_map(1).map,1)]';

% Send all session info to stay with the map
[batch_session_map(1).session(1).Animal] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(1).mouse;
[batch_session_map(1).session(1).Date] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(1).base_date;
[batch_session_map(1).session(1).Session] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(1).base_session;

[batch_session_map(1).session(2:length(Reg_NeuronID_trans(1).Reg_NeuronIDs)+1).Animal] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(:).mouse;
[batch_session_map(1).session(2:length(Reg_NeuronID_trans(1).Reg_NeuronIDs)+1).Date] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(:).reg_date;
[batch_session_map(1).session(2:length(Reg_NeuronID_trans(1).Reg_NeuronIDs)+1).Session] = ...
    Reg_NeuronID_trans(1).Reg_NeuronIDs(:).reg_session;

batch_session_map(1).AllMasksMean = 'Located in RegNeuronIDs_updatemasks0.mat';
batch_session_map(1).trans_test1_ratio = trans1_ratio_pass;
batch_session_map(1).trans_test2_ratio = trans2_ratio_pass;

base_dir = ChangeDirectory(base_struct(1).Animal, base_struct(1).Date, base_struct(1).Session);

save_name = ['batch_session_map' name_append '.mat'];

save(fullfile(base_dir,save_name),'batch_session_map')

%% Step 5: Plot out quality control plots

reg_qc_plot_batch(base_struct, reg_struct, 'batch_mode', 1, 'name_append', name_append);

end