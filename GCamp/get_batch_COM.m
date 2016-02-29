function [ COM ] = get_batch_COM(batch_session_map)
% COMs = get_batch_COM(batch_session_map)
%   Gets the Center-of-Mass (COM) for each neuron mask for each neuron
%   identified and tracked in batch_session_map (output of
%   neuron_reg_batch).  COM are positions in x and y pixels of the COM of
%   each neuron mask.  num_neurons x 2 vector.

%% Before anything, fix batch_session_map if it uses the old version
if isfield(batch_session_map.session,'mouse') || ...
        isfield(batch_session_map.session,'date') || ...
        isfield(batch_session_map.session,'session')
    batch_session_map = fix_batch_session_map(batch_session_map);
end

session = batch_session_map.session; % Makes life easiery below
batch_map = batch_session_map.map;

%% Get relevant numbers of neurons and sessions and other info
num_neurons = size(batch_map,1);
num_sessions = size(batch_map,2) - 1;
base_session = session(1);
base_path = ChangeDirectory_NK(base_session);

%% First, identify which session hosts the first time a neuron is active
sesh_use = nan(num_neurons,1);
for j = 1:num_neurons
   sesh_use(j,1) = find(batch_map(j,2:end) > 0, 1, 'first');
end

keyboard
%% Next, get the COM of each neuron
for k = 1:num_sessions
    
    % a) Grab neuron masks to use from each session
    dirstr = ChangeDirectory_NK(session(k));
    load(fullfile(dirstr,'ProcOut.mat'),'NeuronImage'); % Load neuron masks from the appropriate directory
     % b) Register neuron masks from other areas back to the original config
    if k ~= 1
        reg_file = fullfile(base_path,['RegistrationInfo-' session(k).Animal ...
            '-' session(k).Date '-session' num2str(session(k).Session) '.mat']); % Get registration info file name
        load(reg_file) % Load registration info
        reg_masks = cellfun(@(a) imwarp(a,RegistrationInfoX.tform,'OutputView',...
                RegistrationInfoX.base_ref,'InterpolationMethod','nearest'),...
                NeuronImage,'UniformOutput',0); % Register masks to base session
        
    elseif k == 1
       reg_masks = NeuronImage; % Keep original masks if base session
    end
    
    % c) Get COM for each registered mask
    reg_COM = cellfun(@(a) regionprops(a,'Centroid'),reg_masks,'UniformOutput',0);
    
    % d) Assign the COM to the appropriate location in the array
    neurons_to_assign = find(sesh_use == k); % Get base neuron numbers to assign 
    neuron_number_by_sesh = batch_map(neurons_to_assign,k+1); % Get neuron number from each session that match the base indices in neurons_to_assign
    for m = 1:length(neurons_to_assign)
        if ~isempty(reg_COM{neuron_number_by_sesh(m)}.Centroid)
            COM(neurons_to_assign(m),:) = reg_COM{neuron_number_by_sesh(m)}.Centroid;
        else
            COM(neurons_to_assign(m),:) = [nan nan];
        end
    end
    
end

end

