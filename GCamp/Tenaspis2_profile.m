function Tenaspis2_profile(animal_id,sess_date,sess_num,varargin)
% Quick & dirty Tenaspis2
% Requires DFF.h5, manualmask.mat, and SLPDF.h5 be present
%
%% If no inputs are specified, assume the current working directory is ok 
% and mask_reg is in it and proceed

skip_mask_reg = 0;
if nargin < 3
    skip_mask_reg = 1;
end

%% Process varargins
calc_half = 0; % default
tenaspis_only = 0; % default
PF_only = 0; % default
minspeed = 1; % Default
PFsavename = 'PlaceMapsv2.mat';
for j = 1:length(varargin)
    
    if strcmpi(varargin{j},'PF_only')
        PF_only = 1;
    elseif strcmpi(varargin{j},'tenaspis_only')
        tenaspis_only = varargin{j+1};
    elseif strcmpi(varargin{j},'calc_half')
        calc_half = varargin{j+1};
        if calc_half == 0 || calc_half == 1
            PFsavename = 'PlaceMapsv2.mat';
            name_append = '_v2';
        elseif calc_half == 2
            PFsavename = 'PlaceMapsv2_oddeven.mat';
            name_append = '_v2_oddeven';
        end
    elseif strcmpi(varargin{j},'minspeed')   
        minspeed = varargin{j+1};
    end
    
end


%% Register base session neuron mask to current session
if PF_only == 0
% Register mask unless inputs specify that you shouldn't
if skip_mask_reg == 0
    MasterDirectory = 'C:\MasterData';
    
    [init_date,init_sess] = GetInitRegMaskInfo(animal_id);
    init_dir = ChangeDirectory(animal_id,init_date,init_sess);
    % init_tif = fullfile(init_dir,'ICmovie_min_proj.tif');
    
    init_mask_loc = fullfile(MasterDirectory,[animal_id,'_initialmask.mat']);
    
    reg_struct.Animal = animal_id;
    reg_struct.Date = sess_date;
    reg_struct.Session = sess_num;
    
    [~, session_struct] = ChangeDirectory(animal_id,sess_date,sess_num); % Change to session directory
    if ~exist('mask_reg.mat','file')
        mask_multi_image_reg(init_mask_loc,init_date,init_sess,reg_struct);
    end

end

load mask_reg
mask_reg = logical(mask_reg); 

%% Extract Blobs
% profile clear
% profile on

disp('Extracting blobs...'); 
ExtractBlobs('DFF.h5',mask_reg);

% stats_extractblobs = profile('info');
% save stats_extractblobs stats_extractblobs

%% Connect blobs into transients

% profile clear
% profile on

disp('Making transients...');
MakeTransients()
!del InitClu.mat

% stats_maketransients = profile('info');
% save stats_maketransients stats_maketransients


%% Group together individual transients under individual neurons

profile clear
profile on

disp('Making neurons...'); 
MakeNeurons('min_trans_length',10);

% stats_makeneurons = profile('info');
% save stats_makeneurons stats_makeneurons

% profile clear
% profile on

% Pull traces out of each neuron using the High-pass movie
disp('Normalizing traces...'); 
NormalTraces('SLPDF.h5');

% stats_normtraces = profile('info');
% save stats_normtraces stats_normtraces

% profile clear
% profile on

% Expand transients
disp('Expanding transients...'); 
ExpandTransients(0);

% stats_expandtransients = profile('info');
% save stats_expandtransients stats_expandtransients 

% profile clear
% profile on

% Calculate peak of all transients
disp('Calculating pPeak...'); 
Calc_pPeak;

% stats_calcppeak = profile('info');
% save stats_calcppeak stats_calcppeak

%% 
% profile clear
% profile on

disp('Adding Potential Transients ...')
AddPoTransients;

% stats_addpo = profile('info');
% save stats_addpo_calcahead1 stats_addpo

% Determine rising events/on-times for all transients

% profile clear
% profile on

disp('Finalizing...');
DetectGoodSlopes;

% stats_detectslope = profile('info');
% save stats_detectslope stats_detectslope

end

%% Calculate place fields and accompanying statistics

% profile clear
% profile on
if tenaspis_only == 0
    disp('Calculating Placefields ...')
    [~, session_struct] = ChangeDirectory(animal_id, sess_date, sess_num); % Get session structure
    CalculatePlacefields(session_struct.Location,'alt_inputs','T2output.mat','man_savename',...
        PFsavename,'half_window',0,'minspeed',minspeed,'calc_half',calc_half,...
        'exclude_frames',session_struct.exclude_frames);
    PFstats(0,'alt_file_use',PFsavename,name_append);

end

% stats_PF = profile('info');
% save stats_PF stats_PF

end

