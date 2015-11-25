function [ translation, rotation, tform_struct ] = import_treg_lmarks( filename )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Import registration data from TurboReg output
fid = fopen(filename);
c = textscan(fid,'%s%s');

% Get base(target) and reg(source) image sizes, for reference
base_size = [str2double(c{1}{6}) str2double(c{2}{6})];
reg_size = [str2double(c{1}{4}) str2double(c{2}{4})];

% Get landmarks
base_landmarks = [str2double(c{1}{13}) str2double(c{2}{13}); ...
                  str2double(c{1}{14}) str2double(c{2}{14}); ...
                  str2double(c{1}{15}) str2double(c{2}{15})];
              
reg_landmarks = [str2double(c{1}{9}) str2double(c{2}{9}); ...
                 str2double(c{1}{10}) str2double(c{2}{10}); ...
                 str2double(c{1}{11}) str2double(c{2}{11})];
             
% Calculate transformation
translation = reg_landmarks(1,:) - base_landmarks(1,:);

base_delta = base_landmarks(3,:) - base_landmarks(2,:);
base_angle = atan2d(base_delta(1), base_delta(2));

reg_delta = reg_landmarks(3,:) - reg_landmarks(2,:);
reg_angle = atan2d(reg_delta(1), reg_delta(2));
    
rotation = reg_angle - base_angle;

% keyboard

tform_struct = affine2d(); % Initialize default tform matrix
% Make tform
tform_struct.T(3,1) = translation(1);
tform_struct.T(3,2) = translation(2);
tform_struct.T(1:2,1:2) = [cosd(rotation) -sind(rotation); sind(rotation) cosd(rotation)];

end

