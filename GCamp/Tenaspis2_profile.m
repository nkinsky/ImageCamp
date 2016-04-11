function Tenaspis2_profile(animal_id,sess_date,sess_num)
% Quick & dirty Tenaspis2
% Requires DFF.h5, manualmask.mat, and SLPDF.h5 be present

%% Register base session neuron mask to current session
MasterDirectory = 'C:\MasterData';

[init_date,init_sess] = GetInitRegMaskInfo(animal_id);
init_dir = ChangeDirectory(animal_id,init_date,init_sess);
% init_tif = fullfile(init_dir,'ICmovie_min_proj.tif');

init_mask_loc = fullfile(MasterDirectory,[animal_id,'_initialmask.mat']);

reg_struct.Animal = animal_id;
reg_struct.Date = sess_date;
reg_struct.Session = sess_num;

sess_dir = ChangeDirectory(animal_id,sess_date,sess_num); % Change to session directory
if ~exist('mask_reg.mat','file')
    mask_multi_image_reg(init_mask_loc,init_date,init_sess,reg_struct);
end

load mask_reg
mask_reg = logical(mask_reg); 

%% Extract Blobs
profile clear
profile on

disp('Extracting blobs...'); 
ExtractBlobs('DFF.h5',mask_reg);

stats_extractblobs = profile('info');
save stats_extractblobs stats_extractblobs


%% Connect blobs into transients

profile clear
profile on

disp('Making transients...');
MakeTransients('DFF.h5',0); % Dave - the inputs to this are currently unused
!del InitClu.mat

stats_maketransients = profile('info');
save stats_maketransients stats_maketransients


%% Group together individual transients under individual neurons

profile clear
profile on

disp('Making neurons...'); 
MakeNeurons('min_trans_length',10);

stats_makeneurons = profile('info');
save stats_makeneurons stats_makeneurons

profile clear
profile on

% Pull traces out of each neuron using the High-pass movie
disp('Normalizing traces...'); 
NormalTraces('SLPDF.h5');

stats_normtraces = profile('info');
save stats_normtraces stats_normtraces

profile clear
profile on

% Expand transients
disp('Expanding transients...'); 
ExpandTransients(0);

stats_expandtransients = profile('info');
save stats_expandtransients stats_expandtransients 

profile clear
profile on

% Calculate peak of all transients
disp('Calculating pPeak...'); 
Calc_pPeak;

stats_calcppeak = profile('info');
save stats_calcppeak stats_calcppeak


%%

profile clear
profile on

disp('Adding Potential Transients ...')
AddPoTransients;

stats_addpo = profile('info');
save stats_addpo_calcahead_take2 stats_addpo

%%

% Determine rising events/on-times for all transients

profile clear
profile on

disp('Finalizing...');
DetectGoodSlopes;

stats_detectslope = profile('info');
save stats_detectslope stats_detectslope

%% Calculate place fields and accompanying statistics
CalculatePlacefields('201b','alt_inputs','T2output.mat','man_savename',...
    'PlaceMapsv2.mat','half_window',0,'minspeed',3);
PFstats;

end

