function [ COM, NeuronMean_all ] = get_batch_COM(batch_session_map, base_sesh)
% COMs = get_batch_COM(batch_session_map)
%   Gets the Center-of-Mass (COM) for each neuron mask for each neuron
%   identified and tracked in batch_session_map (output of
%   neuron_reg_batch).  COM are positions in x and y pixels of the COM of
%   each neuron mask.  num_neurons x 2 vector.
%
%   if specified, ref_sesh gives a reference session to which all the
%   subsequent sessions will be registered to.  If left blank, everything
%   will be referenced to the 1st session in batch_session_map.

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
if ~exist('base_sesh','var')
    base_path = ChangeDirectory_NK(base_session,0);
    register_1st_sesh = 0;
elseif exist('base_sesh','var')
    base_path = ChangeDirectory_NK(base_sesh,0);
    register_1st_sesh = 1;
end

%% First, identify which session hosts the first time a neuron is active
sesh_use = nan(num_neurons,1);
for j = 1:num_neurons
   sesh_use(j,1) = find(batch_map(j,2:end) > 0, 1, 'first');
end

%% Next, get the COM of each neuron

p = ProgressBar(num_sessions);
for k = 1:num_sessions
    
    % a) Grab neuron masks to use from each session
    dirstr = ChangeDirectory_NK(session(k),0);
    load(fullfile(dirstr,'ProcOut.mat'),'NeuronImage'); % Load neuron masks from the appropriate directory
    load(fullfile(dirstr,'MeanBlobs.mat'),'BinBlobs'); % Load neuron masks from the appropriate directory
     % b) Register neuron masks from other areas back to the original config
    if k ~= 1 || (k == 1 && register_1st_sesh == 1)
        reg_file = fullfile(base_path,['RegistrationInfo-' session(k).Animal ...
            '-' session(k).Date '-session' num2str(session(k).Session) '.mat']); % Get registration info file name
        load(reg_file) % Load registration info
        reg_masks = cellfun(@(a) imwarp(a,RegistrationInfoX.tform,'OutputView',...
                RegistrationInfoX.base_ref,'InterpolationMethod','nearest'),...
                NeuronImage,'UniformOutput',0); % Register masks to base session
        reg_mean = cellfun(@(a) imwarp(a,RegistrationInfoX.tform,'OutputView',...
            RegistrationInfoX.base_ref,'InterpolationMethod','nearest'),...
            BinBlobs,'UniformOutput',0); % Register mean blobs to base session
        if register_1st_sesh == 1
            NeuronImage_nan = nan(size(reg_mean{1}));
        end
        
    elseif k == 1 && register_1st_sesh == 0
       reg_masks = NeuronImage; % Keep original masks if base session
       reg_mean = BinBlobs; % Keep original blobs if base session
       NeuronImage_nan = nan(size(BinBlobs{1}));
    end
    
    % c) Get COM for each registered mask
    reg_COM = cellfun(@(a) regionprops(a,'Centroid'),reg_masks,'UniformOutput',0);
    
    % d) Assign the COM to the appropriate location in the array
    neurons_to_assign = find(sesh_use == k); % Get base neuron numbers to assign 
    neuron_number_by_sesh = batch_map(neurons_to_assign,k+1); % Get neuron number from each session that match the base indices in neurons_to_assign
    for m = 1:length(neurons_to_assign)
        if ~isempty(reg_COM{neuron_number_by_sesh(m)})
            COM(neurons_to_assign(m),:) = reg_COM{neuron_number_by_sesh(m)}.Centroid;
            NeuronMean_all{neurons_to_assign(m)} = reg_mean{neuron_number_by_sesh(m)};
        else
            COM(neurons_to_assign(m),:) = [nan nan];
            NeuronMean_all{neurons_to_assign(m)} = NeuronImage_nan;
        end
    end
    p.progress;
end
p.stop;

end

