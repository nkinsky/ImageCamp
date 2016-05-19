function [ overlap_ratio, overlap_ratio2 ] = reg_calc_samemap_overlap( neuronmap, varargin )
% [overlap_ratio, overlap_ratio2] = reg_calc_samemap_overlap( neuronmap, ...)
%   Calculates the overlap ratio between all the multi-mapping neurons
%   identified in neuronmap. varargins are 'name_append' and 'batch_mode'
%   (if you are running using a batch_session_map as an input.  batch_mode
%   = 1 -> use updatemasks = 0, 2 -> use updatemasks = 1.

%% Process varargins

name_append = ''; % default
batch_mode = 0; % default
for j = 1:length(varargin)
   if strcmpi(varargin{j},'name_append')
       name_append = varargin{j+1};
   end
   if strcmpi(varargin{j},'batch_mode')
       batch_mode = varargin{j+1};
   end
end

%%

% Get image registration file & load it
base_path = fileparts(neuronmap.base_file);
unique_filename = fullfile(base_path,['RegistrationInfo-' neuronmap.mouse '-'...
    neuronmap.reg_date '-session' ...
    num2str(neuronmap.reg_session) name_append '.mat']);
reginfo = importdata(unique_filename);

% deal out session info
session.Animal = reginfo.mouse;
session.Date = reginfo.base_date;
session.Session = reginfo.base_session;
session.dir = ChangeDirectory_NK(session(1),0);

session(2).Animal = reginfo.mouse;
session(2).Date = reginfo.register_date;
session(2).Session = reginfo.register_session;
session(2).dir = ChangeDirectory_NK(session(2),0);

% Load neuron ROIs for each sesson
try
for j = 1:2
    if batch_mode == 0 || j == 2
        if exist(fullfile(session(j).dir,'T2output.mat'),'file')
            load(fullfile(session(j).dir,'T2output.mat'),'NeuronImage')
            session(j).NeuronROI = NeuronImage;
        else
            disp('Using T1 output!!!! Update for final plots!')
            load(fullfile(session(j).dir,'MeanBlobs.mat'),'BinBlobs');
            session(j).NeuronROI = BinBlobs;
        end
    elseif batch_mode == 1 || batch_mode == 2 && j == 1
        if exist(fullfile(session(j).dir,'T2output.mat'),'file')
            load(fullfile(session(j).dir,['Reg_NeuronIDs_updatemasks' num2str(batch_mode - 1) '.mat']))
            session(j).NeuronROI = Reg_NeuronIDs(1).AllMasks;
        else
            disp('Using T1 output!!!! Update for final plots!')
            load(fullfile(session(j).dir,['Reg_NeuronIDs_updatemasks' num2str(batch_mode - 1) '.mat']))
            session(j).NeuronROI = Reg_NeuronIDs(1).AllMasksMean;
        end
    end
end
catch
    keyboard
end

% Get neurons in session 2 that map to multiple session 1 neurons
multi2 = find(sum(neuronmap.same_neuron,1) > 1);

for j = 1:length(multi2)
    multi1 = find(neuronmap.same_neuron(:,multi2(j))); % Get multi-mappers in session 1
    % Register session 2 to session 1
    ROI2 = imwarp(session(2).NeuronROI{multi2(j)},reginfo.tform,'OutputView',...
        reginfo.base_ref,'InterpolationMethod','nearest');
    try
        % Get overlap for each session 1 neuron
        for k = 1:length(multi1);
            ROI1 = session(1).NeuronROI{multi1(k)};
            overlap_ratio{j,k} = sum(ROI2(:) & ROI1(:))/sum(ROI2(:) | ROI1(:));
            overlap_ratio2{j,k} = sum(ROI2(:) & ROI1(:))^2/(sum(ROI2(:))*sum(ROI1(:)));
        end
    catch
        disp('error catching in reg_calc_samemap_overlap')
        keyboard
    end
    
end


end

