function [ ] = mosaic_make_obj(inputfile, ref_file)
%UNTITLED2 Summary of this function goes here
%   inputfile - full path to input file (can any of the .h5 or .mat files
%   associated with the Mosaic object for that file)

if nargin < 2
    ref_exist = false;
elseif nargin == 2
    ref_exist = true;
end

% Get file name and path, make new folder
[upper_path, name, ~] = fileparts(inputfile);
path = fullfile(upper_path, [name '-Objects']);
if ~exist(path,'dir')
    mkdir(path)
else
    error(['Folder ''' path ''' already exists!'])
end

if ~ref_exist
    info = h5info(inputfile,'/Object');
    
    % Index file
    Index{1}.Constructor = 'MovieObject([2 2 2 1],''uint16'')';
    Index{1}.ObjName = 'Object';
    Index{1}.ObjFile = ['Obj_1 - ' name '.mat'];
    Index{1}.H5File = ['Obj_1 - ' name '.h5'];
    Index{1}.ListText = name;
    Index{1}.ObjectClass = 'MovieObject';
    Index{1}.Children = cell(0,1);
    Index{1}.MosaicVersion = '1.1.2';
    Index{1}.MosaicDate = '2015-04-17';
    Index{1}.Types = {'Generic'    'Data'    'Sequence'    'GraySequence'    'Movie'    'GrayMovie'};
    Index{1}.DataSize = info.Dataspace.Size;
    Index{1}.DataClass = 'uint16';
    
    save(fullfile(upper_path,name),'Index');
    
    % Lower tier Index file
    temp = Index;
    clear Index
    Index = temp{1};
    
    % Lower tier Object file
    Object.TimeFrame = [0:info.Dataspace.Size(3)-1]/20;
    Object.Exposure = ones(info.Dataspace.Size(1:2))*0.497;
    Object.TimePixel = zeros(info.Dataspace.Size(1:2));
    Object.DroppedFrames = 0;
    Object.CurrentSpeed = 1;
    Object.CurrentNumberInMovie = 1;
    Object.MaxTime = max(Object.TimeFrame);
    Object.MinTime = min(Object.TimeFrame);
    Object.currentTime = Object.minTime;
    Object.NumberFrameDisplayPerSecond = 15;
    Object.Looping = 0;
    Object.FrameRate = 20.0000;
    Object.Xposition = [136 636];
    Object.Yposition = [85 534];
    Object.XLabel = 'X position (\mum)';
    Object.YLabel = 'Y position (\mum)';
    Object.CLabel = 'Fluorescence (au)';
    Object.Colormap = 'gray';
    Object.CLim = [210.0601 3.0066e+03];
    Object.Scaling = 'image';
    Object.ViewAxis = 0;
    Object.DataSize = info.Dataspace.Size;
    Object.DataClass = 'uint16';
    Object.ListText = ['Obj_1 - ' name];
    Object.History = {[]  []  []};
    Object.Comment = '';
    
    save(fullfile(path,['Obj_1 - ' name]),'Index','Object');
elseif ref_exist
    [ref_path, ref_name, ref_ext] = fileparts(ref_file);
    
    % Load the appropriate .mat file in the lowest level directory
    if strcmpi(ref_ext,'.mat') && exist(fullfile(ref_path,[ref_name '-Object']),'dir')
        curr_dir = cd;
        cd(fullfile(ref_path,[ref_name '-Object']));
        load(ls('*.mat'));
        cd(curr_dir);
    elseif strcmpi(ref_ext,'.h5') || ~exist(fullfile(ref_path,[ref_name '-Object']),'dir') && strcmpi(ref_ext,'.mat')
        load(fullfile(ref_path,[ref_name '.mat']));
    end
    
    Index.ObjFile = ['Obj_1 - ' name '.mat'];
    Index.H5File = ['Obj_1 - ' name '.h5'];
    Index.ListText = name;
    
    save(fullfile(path,['Obj_1 - ' name]),'Index','Object');
    temp = Index;
    clear Index
    Index{1} = temp;
    save(fullfile(upper_path,name),'Index');

end

