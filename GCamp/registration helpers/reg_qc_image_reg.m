% Check image reg performance versus other methods

clear
close all

[MD, ref] = MakeMouseSessionList('mouseimage');

%% Ziv style - 1) use all neuron masks, 2) iterate through using a random 50% of the masks
min_trans_thresh = 3; % neurons must fire at least this many times to qualify for use in image registration

reg_dist = 2; % 1 = use near session, 2 = use far session

base_sesh = MD(ref.G30.two_env(1)); % Base session
reg_sesh_near = MD(ref.G30.two_env(1)+1); % Reg session that is close in time to base
reg_sesh_far = MD(ref.G30.two_env(end)); % Reg session that is far away in time from base

session = base_sesh;
if reg_dist == 1
    session(2) = reg_sesh_near;
elseif reg_dist == 2
    session(2) = reg_sesh_far;
end

% Load map between sessions and get validly mapped neurons
map_name = fullfile(base_sesh.Location,['neuron_map-' session(2).Animal ...
    '-' session(2).Date '-session' num2str(session(2).Session) '.mat']);
load(map_name);
map_use = zeros(size(neuron_map.neuron_id));
session(1).valid_map = find(cellfun(@(a) ~isempty(a) && ~isnan(a),neuron_map.neuron_id));
session(2).valid_map = cellfun(@(a) a,neuron_map.neuron_id(session(1).valid_map));

num_shuffles = 1000;

%% Load base and reg session neuron ROIs and NumTransients
for k = 1:2
    if ~exist(fullfile(ChangeDirectory_NK(session(1),0),'T2output.mat'),'file') || ...
            ~exist(fullfile(ChangeDirectory_NK(session(2),0),'T2output.mat'),'file')
        load(fullfile(ChangeDirectory_NK(session(k),0),'ProcOut.mat'),'NeuronImage','NumTransients')
    elseif exist(fullfile(ChangeDirectory_NK(session(1),0),'T2output.mat'),'file') && ...
            exist(fullfile(ChangeDirectory_NK(session(2),0),'T2output.mat'),'file')
        load(fullfile(ChangeDirectory_NK(session(k),0),'T2output.mat'),'NeuronImage','NumTransients')
    end
    session(k).NeuronImage = NeuronImage;
    session(k).NumTransients = NumTransients;
    session(k).pass_thresh = find(NumTransients >= min_trans_thresh);
    temp = zeros(size(NeuronImage));
    temp(session(k).valid_map) = true(size(session(k).valid_map));
    session(k).pass_thresh_valid = find(NumTransients >= min_trans_thresh & ...
        temp);
        
end
%%

for j = 1:num_shuffles
    for k = 1:2
        % Select a random 50% of the neurons from each session (or do only
        % for reg session?)
        if reg_dist == 1 
            neurons_use = session(k).pass_thresh(randperm(length(session(k).pass_thresh),...
                round(length(session(k).pass_thresh)/2)));
        elseif reg_dist == 2
            if k == 1
                neurons_use = session(k).valid_map;
            elseif k == 2 
%                 neurons_use = session(k).valid_map(randperm(length(session(k).valid_map),...
%                     round(length(session(k).valid_map)/2)));
                neurons_use = session(k).valid_map(randperm(length(session(k).valid_map),...
                    round(length(session(k).valid_map)*0.5)));
            end
        end
        session(k).mask_use = create_AllICmask(session(k).NeuronImage(neurons_use));
    end
    image_registerX(session(1).Animal,session(1).Date, session(1).Session, ...
        session(2).Date, session(2).Session,0, 'use_neuron_masks', 2,...
        ['_ziv_reg' num2str(j)], 'base_bw', session(1).mask_use,...
        'reg_bw', session(2).mask_use);
end

% Run our registration if not already done
image_registerX(session(1).Animal,session(1).Date, session(1).Session, ...
        session(2).Date, session(2).Session,0)

%% turbo-reg style