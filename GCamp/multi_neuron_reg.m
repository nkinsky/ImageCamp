function [Reg_NeuronIDs] = multi_neuron_reg(base_struct, reg_struct, varargin)
% Reg_NeuronIDs = multi_neuron_reg(base_struct, reg_struct, varargin)
%
%   Registers a base file to multiple recording sessions and saves these
%   registrations in a .mat file claled Reg_NeuronIDs.mat in your base file
%   directory. 
%
%   INPUTS:
%       base_struct: data structure (length 1) with .Animal (string), .Date (string,
%       DD_MM_YYYY), and .Session (integer) pointing to the base session.
%
%       reg_struct: same as base_struct, but with as many entries as
%       sessions you wish to analyze.  
%
%       OPTIONAL (enter as ...,'check_neuron_mapping,[0 0 1])
%       'check_neuron_mapping': Logical vector where each element corresponds
%       to whether or not you want to check how well each neuron maps.
%       Default is zero for all sessions.
%
%       'update_masks': 0 or 1.  1 = the neuron and average mask will be
%       updated to the most recent session registered for each iteration
%       registration.  Default = 0 (Base session masks used for all future
%       registrations, with the exception of new neurons that are added in
%       a given session)
%       
%       see neuron_reg_batch and multi_image_reg for other varargins
%
%
%   OUTPUTS: 
%       Reg_NeuronIDs: 1xN struct (where N is the number of registered
%       sessions) containing the following fields...
%
%           mouse: string containing the name of the mouse. Usually in the
%           format 'GXX' where X is a digit. 
%
%           base_path: path to your base file. 
%
%           reg_path: path to the file to which you registered to for that
%           N. 
%
%           AllMasks: this only occurs in Reg_NeuronIDs(1) and included the
%           masks for ALL cells that accumulate with each session!
%
%           neuron_id: 1x(n+new) cell where n is the number of neurons in the
%           first session and new is the number of new neurons in the 2nd session
%           Each value is the neuron number in the 2nd
%           session that maps to the neurons in the 1st session.  An empty
%           cell means that no neuron from the 2nd session maps to that
%           neuron from the 1st session.  A value of NaN means that more
%           than one neuron from the second session is within min_thresh of
%           the 1st session neuron.
%
%           same_neuron: n x m logical, where the a value of 1 indicates
%           that more than one neuron from the second session maps to a
%           cell in the first session.  Each row corresponds to a 1st
%           session neuron, each column to a 2nd session neuron.
%
%           is_new_cell: indices of all cells in the 2nd session that do
%           not appear in the first.  This does NOT include 2nd session
%           cells that have multiple cells in the 1st session mapping to
%           them.
%           
%           num_bad_cells: struct containing the following fields:
%               nonmapped: Neurons that weren't mapped onto the second
%               session.
%               crappy: Neurons that map onto a neuron that another neuron
%               is mapping to. 
%
%% Parse inputs
num_sessions = length(reg_struct);

p = inputParser;
p.addRequired('base_struct', @isstruct);
p.addRequired('reg_struct', @isstruct);
p.addParameter('check_neuron_mapping', zeros(1,num_sessions), @(a) islogical(a) ...
    || a == 1 || a == 0);  %default = zeros
p.addParameter('update_masks', 0, @(a) a == 1 || a == 0);  %default = 0
p.addParameter('use_neuron_masks', false, @(a) islogical(a) ...
    || a == 1 || a == 0);  %default = false
p.addParameter('name_append', '', @ischar); % default = ''
p.addParameter('alt_reg', [], @(x) isempty(x) || validateattributes(x,{'numeric'},...
    {'size',[3,3]})); % default = no alternative tform
p.addParameter('add_jitter', [], @(x) isempty(x) || validateattributes(x,{'numeric'},...
    {'size',[3,3]})); % default = no jitter added

p.parse(base_struct, reg_struct, varargin{:});

check_neuron_mapping = p.Results.check_neuron_mapping;
update_masks = p.Results.update_masks;
use_neuron_masks = p.Results.use_neuron_masks;
name_append = p.Results.name_append;
alt_reg_tform = p.Results.alt_reg;
jitter_mat = p.Results.add_jitter;

base_path = ChangeDirectory(base_struct.Animal, base_struct.Date, ...
        base_struct.Session,0);

if length(check_neuron_mapping) == 1 && length(check_neuron_mapping) < num_sessions
    check_neuron_mapping = ones(1,num_sessions)*check_neuron_mapping;
end
%% Do the registrations.

%Preallocate.
reg_filename = cell(1,num_sessions);
reg_path = cell(1,num_sessions);
unique_filename = cell(1,num_sessions);

mouse = base_struct.Animal;
base_date = base_struct.Date;
base_session = base_struct.Session;

%Select all the files first.
for this_session = 1:num_sessions

    reg_path{this_session} = ChangeDirectory(reg_struct(this_session).Animal,...
        reg_struct(this_session).Date, reg_struct(this_session).Session,0);
    
    % Construct a cell containing the filenames for each image
    % registration
    unique_filename{this_session} = fullfile(base_path,['RegistrationInfo-' ...
        reg_struct(this_session).Animal '-' reg_struct(this_session).Date ...
        '-session' num2str(reg_struct(this_session).Session) name_append '.mat']);
    
    % Check to make sure you are looking at the same mouse for each
    % session
    if ~strcmpi(mouse,reg_struct(this_session).Animal)
        error('You are not analyzing the same mouse in the base and registered files!')
    end
end

%% Do the registrations.

% Load neuron ROIs
load(fullfile(base_path,'FinalOutput.mat'),'NeuronImage','NeuronAvg');
ROIavg = MakeAvgROI(NeuronImage,NeuronAvg);
base_masks = NeuronImage;
base_masks_mean = ROIavg;

for this_session = 1:num_sessions
    %Display.
    disp(['Registering ', mouse ' ' reg_struct(this_session).Date, ' session ' ...
        num2str(reg_struct(this_session).Session) ' to ', mouse ' ' base_date, ...
        ' session ' num2str(base_session) '...']);
    
    %Perform neuron registration.
    update_masks_vec = ones(1,num_sessions)*update_masks+1;
    update_masks_vec(1) = 0; % set first session to zero
    neuron_map = neuron_register(mouse, base_struct.Date,...
        base_struct.Session, reg_struct(this_session).Date, ...
        reg_struct(this_session).Session, check_neuron_mapping(this_session),...
        'multi_reg',update_masks_vec(this_session),'use_neuron_masks', use_neuron_masks, ...
        'alt_reg',alt_reg_tform,'add_jitter', ...
        jitter_mat,'name_append',name_append);
    % First, get all neurons in registered session that have multiple
    % neurons from the base session map to it
    [~, temp] = find(neuron_map.same_neuron);
    same_ind = unique(temp); % Vector containing all the neurons in the second session that have multiple neurons in the first session mapping to them...
    % Create boolean to ID session 2 neurons with multiple neurons
    % in 1 mapping to them
    multiple_maps = zeros(size(neuron_map.same_neuron,2),1); % Pre-allocate
    multiple_maps(same_ind,1) = ones(length(same_ind),1);
    
    % Pre-allocate
    is_registered = zeros(size(neuron_map.same_neuron,2),1);
    
    for j = 1:size(neuron_map.same_neuron,2)
        % Get all neurons in session 2 that map to session 1, not including
        % any NaNs
        is_registered(j,1) = sum(cellfun(@(a) ~isempty(a) && a == j,neuron_map.neuron_id)) ~= 0;
        
    end
    
    is_new_cell = find(~is_registered & ~multiple_maps); % New cell numbers in session 2
    
    % Load registered session Neuron masks so that you can get masks
    % for new file
    disp('Loading session data and incorporating new neurons into all_neuron_map')
    load(fullfile(reg_path{this_session},'FinalOutput.mat'),'NeuronImage','NeuronAvg');
    ROIavg = MakeAvgROI(NeuronImage,NeuronAvg);
    reg_masks = NeuronImage;
    reg_masks_mean = ROIavg;
    if this_session ~= 1
        AllMasks = Reg_NeuronIDs(1).AllMasks;
        AllMasksMean = Reg_NeuronIDs(1).AllMasksMean;
    elseif this_session == 1
        AllMasks = base_masks;
        AllMasksMean = base_masks_mean;
    end
    
    % Update each neurons's mask to the most recent session
    if update_masks == 1
        id_temp = neuron_map.neuron_id;
        n = size(AllMasks,2);
        load(unique_filename{this_session})
        for kk = 1:n
            try
                if ~isempty(id_temp{kk,1}) && ~isnan(id_temp{kk,1})
                    % Register mask and mean mask for each neuron to base
                    % session
                    temp = imwarp(reg_masks{id_temp{kk,1}},RegistrationInfoX.tform,'OutputView',...
                        RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
                    temp2 = imwarp(reg_masks_mean{id_temp{kk,1}},RegistrationInfoX.tform,'OutputView',...
                        RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
                    AllMasks{1,kk} = temp; % Update cells masks to include newest session masks
                    AllMasksMean{1,kk} = temp2;
                end
            catch
                disp('error above')
                keyboard
            end
        end
    end
    
    % Add in new neurons to neuron_map. There is probably a more
    % elegant way to do this in one line of code, but I don't know it.
    id_temp = neuron_map.neuron_id;
    n = size(AllMasks,2) + 1;
    load(unique_filename{this_session})
    for kk = 1:length(is_new_cell)
        % Add in new neurons to bottom of id_temp
        id_temp{n,1} = is_new_cell(kk);
        % Register mask and mean mask for each neuron to base session
        temp = imwarp(reg_masks{is_new_cell(kk)},RegistrationInfoX.tform,'OutputView',...
            RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
        temp2 = imwarp(reg_masks_mean{is_new_cell(kk)},RegistrationInfoX.tform,'OutputView',...
            RegistrationInfoX.base_ref,'InterpolationMethod','nearest');
        AllMasks{1,n} = temp; % Update cells masks to include new cell
        AllMasksMean{1,n} = temp2;
        n = n + 1;
    end
    neuron_map.neuron_id = id_temp;
    
    %Build the struct.
    Reg_NeuronIDs(this_session).mouse = mouse;
    Reg_NeuronIDs(this_session).base_date = base_date;
    Reg_NeuronIDs(this_session).base_session = base_session;
    Reg_NeuronIDs(this_session).base_path = base_path;
    Reg_NeuronIDs(this_session).base_cms = neuron_map.base_cms;
    Reg_NeuronIDs(this_session).reg_date = reg_struct(this_session).Date;
    Reg_NeuronIDs(this_session).reg_session = reg_struct(this_session).Session;
    Reg_NeuronIDs(this_session).reg_path = reg_path{this_session};
    Reg_NeuronIDs(this_session).reg_cms = neuron_map.reg_cms;
    Reg_NeuronIDs(1).AllMasks = AllMasks; % This ALWAYS stays only in the 1st index for future registrations
    Reg_NeuronIDs(1).AllMasksMean = AllMasksMean;
    Reg_NeuronIDs(this_session).neuron_id = neuron_map.neuron_id;
    Reg_NeuronIDs(this_session).new_neurons = is_new_cell;
    Reg_NeuronIDs(this_session).multiple_maps = multiple_maps;
    Reg_NeuronIDs(this_session).same_neuron = neuron_map.same_neuron;
    Reg_NeuronIDs(this_session).num_bad_cells = neuron_map.num_bad_cells;
    Reg_NeuronIDs(this_session).update_masks = update_masks;
    Reg_NeuronIDs(this_session).use_neuron_masks = use_neuron_masks;
    
    %Save.
    reg_filename = fullfile(base_path,['Reg_NeuronIDs_updatemasks' num2str(update_masks) name_append '.mat']);
    save (reg_filename, 'Reg_NeuronIDs','-v7.3');
end

%% Bulid cell_map from Reg_NeuronIDs and save it
all_session_map = build_multisesh_mapping(Reg_NeuronIDs);
Reg_NeuronIDs(1).all_session_map = all_session_map;

%Save.
save (reg_filename, 'Reg_NeuronIDs','-v7.3');
   
end
