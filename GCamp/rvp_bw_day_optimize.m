% Script to compare one session on a different day with another and see which RVP correlates
% the best with the other session RVP and if there is any systematic bias
% to it!
%% 
clear all
close all

startpath = '';
% for j = 1:2
%     [f p] = uigetfile( '*.mat',['Select Session ' num2str(j) ' rvp file']);
%    session(j).file = [p f];
% end
%% Important Variables
rvp_type = 2; % 1 = use DF_smooth, 2 = use z_smooth

%% File locations + loading them

%%% NORVAL %%%
session_ref_file = 'J:\GCamp Mice\Working\2env\session_ref.mat';
square_sessions_file = 'J:\GCamp Mice\Working\2env\square_sessions.mat';
octagon_sessions_file = 'J:\GCamp Mice\Working\2env\octagon_sessions.mat';
reg_info_file = 'J:\GCamp Mice\Working\2env\RegistrationInfoX.mat';

%%% LAPTOP %%%
% square_sessions_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\square_sessions_laptop.mat';
% octagon_sessions_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\octagon_sessions_laptop.mat';
% session_ref_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\session_ref.mat';
% reg_info_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\RegistrationInfoX_laptop.mat';
load(square_sessions_file); load(octagon_sessions_file);
load(session_ref_file); load(reg_info_file);

%% Load Analysis Sessions and RegistrationInfo
analysis_day(1) = 2; analysis_session(1) = 1;
analysis_day(2) = 2; analysis_session(2) = 2;

for j = 1:2
    temp = []; rvp_use = []; rvp_reg = [];
    day_session_use = day(analysis_day(j)).session(analysis_session(j));
    [ session(j).folder, ~ ] = get_sesh_folders( day_session_use....
        , square_sessions, octagon_sessions );
    session(j).file = [session(j).folder '\reverse_placefields_ChangeMovie.mat'];
    [session(j).tform_struct ] = get_reginfo( session(j).folder, RegistrationInfoX );
    if rvp_type == 1
        temp = load(session(j).file,'AvgFrame_DF_smooth');
        rvp_use = temp.AvgFrame_DF_smooth;
    elseif rvp_type == 2
        temp = load(session(j).file,'AvgFrame_z_smooth');
        rvp_use = temp.AvgFrame_z_smooth;
    end
    session(j).rvp_use = rvp_use; 
    % Register rvps and exclude_pixels to base_file
    for k = 1:length(rvp_use(:))
    rvp_reg{k} = imwarp_nan(rvp_use{k}, session(j).tform_struct.tform, ...
        session(j).tform_struct.base_ref);
    end
    session(j).rvp_reg = rvp_reg;
end

% session(1).file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\reverse_placefields_ChangeMovie.mat';
% session(3).file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\1 - 2env square right 201B\Working\reverse_placefields_ChangeMovie.mat';
% session(2).file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\reverse_placefields_ChangeMovie.mat';
% 
% sesh_use = [1 3];

%% Load RegistrationInfo and other files
% reginfo_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\RegistrationInfoX.mat';
% 
% load(reginfo_file);
% 
% sesh = importdata(session(sesh_use(1)).file);
% sesh(2) = importdata(session(sesh_use(2)).file);



%% 
% Select the registration info to use for your session - for future, find
% this automatically by getting the working directories above and searching
% through for a match in RegistrationInfoX.base_file and .reg_file!!!
% tform = RegistrationInfoX(sesh_use(2)).tform;
% exclude1 = RegistrationInfoX(sesh_use(2)).exclude_pixels;

% image_xpix = size(session(1).AvgFrame_DF{1},2);
% image_ypix = size(sesh(1).AvgFrame_DF{1},1);

% % Select region to exclude (in this case, where we get traveling waves)
% x_exclude = 325:image_xpix; % in pixels
% y_exclude = 300:image_ypix;
% exclude = zeros(size(sesh(1).AvgFrame_DF{1}));
% exclude(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));
% 
% exclude_comb = exclude1(:) | exclude(:);

% General pixels to exclude
% Pixels to exclude from RVP analysis! (e.g. due to traveling waves, motion
% artifacts, etc.)
% AvgFrame_DF_reg = ones(RegistrationInfo(1).base_ref.ImageSize);
num_x_pixels = session(1).tform_struct.base_ref.ImageSize(2);
num_y_pixels = session(1).tform_struct.base_ref.ImageSize(1);
x_exclude = 325:num_x_pixels; % in pixels
y_exclude = 300:num_y_pixels;
exclude_gen = zeros(session(1).tform_struct.base_ref.ImageSize);
exclude_gen(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));

for j = 1:2
    exclude_gen(:) = exclude_gen(:) & session(j).tform_struct.reg_pix_exclude(:) ;
end

best_corr_ind = zeros(size(session(j).rvp_reg));
best_corr_val = zeros(size(session(j).rvp_reg));
 
num_bins1 = length(session(1).rvp_reg(:));
num_bins2 = length(session(2).rvp_reg(:));
 
 for j = 1:num_bins1
     temp2 = [];
     disp(['Running bin ' num2str(j) ' of ' num2str(num_bins1)])
     for k = 1:num_bins2
         % register both sessions here...
         temp = corr_bw_days(session(1).rvp_reg(j), session(2).rvp_reg(k),...
             exclude_gen); % corrcoef(sesh(1).AvgFrame_DF{j},sesh(2).AvgFrame_DF{k});
         temp2 = [temp2 temp];  
     end
          [val, ind] = max(temp2);
          best_corr_ind(j) = ind;
          best_corr_val(j) = val;
          
 end