% Script to compare one session on a different day with another and see which RVP correlates
% the best with the other session RVP and if there is any systematic bias
% to it!

clear all
close all

startpath = '';
% for j = 1:2
%     [f p] = uigetfile( '*.mat',['Select Session ' num2str(j) ' rvp file']);
%    session(j).file = [p f];
% end

session(1).file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\reverse_placefields_ChangeMovie.mat';
session(3).file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\1 - 2env square right 201B\Working\reverse_placefields_ChangeMovie.mat';
session(2).file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\reverse_placefields_ChangeMovie.mat';

sesh_use = [1 3];

%% Load RegistrationInfo and other files
reginfo_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\RegistrationInfoX.mat';

load(reginfo_file);

sesh = importdata(session(sesh_use(1)).file);
sesh(2) = importdata(session(sesh_use(2)).file);

%% 
% Select the registration info to use for your session - for future, find
% this automatically by getting the working directories above and searching
% through for a match in RegistrationInfoX.base_file and .reg_file!!!
tform = RegistrationInfoX(sesh_use(2)).tform;
exclude1 = RegistrationInfoX(sesh_use(2)).exclude_pixels;

image_xpix = size(sesh(1).AvgFrame_DF{1},2);
image_ypix = size(sesh(1).AvgFrame_DF{1},1);

% Select region to exclude (in this case, where we get traveling waves)
x_exclude = 325:image_xpix; % in pixels
y_exclude = 300:image_ypix;
exclude = zeros(size(sesh(1).AvgFrame_DF{1}));
exclude(y_exclude,x_exclude) = ones(length(y_exclude),length(x_exclude));

exclude_comb = exclude1(:) | exclude(:);

best_corr_ind = zeros(size(sesh(1).AvgFrame_DF));
best_corr_val = zeros(size(sesh(1).AvgFrame_DF));
 
num_bins = length(sesh(1).AvgFrame_DF(:));
 
 for j = 1:num_bins
     temp2 = [];
     for k = 1:num_bins
         temp = corr_bw_days(sesh(1).AvgFrame_DF(j), sesh(2).AvgFrame_DF(k),...
             tform, exclude_comb); % corrcoef(sesh(1).AvgFrame_DF{j},sesh(2).AvgFrame_DF{k});
         temp2 = [temp2 temp];  
     end
          [val, ind] = max(temp2);
          best_corr_ind(j) = ind;
          best_corr_val(j) = val;
          
 end