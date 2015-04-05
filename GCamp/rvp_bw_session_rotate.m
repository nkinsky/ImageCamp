function [corr_rot] = rvp_bw_session_rotate(file1, file2, rot)
% [corr_rot] = rvp_bw_session_rotate(file1, file2, rot)
% Function to compare RVP correlations when rotated in increments of 90.

version = 3; % If using version 3 of reverse-placefield

if nargin <= 2
    if nargin == 0
        for j = 1:2
            [f p] = uigetfile( '*.mat',['Select Session ' num2str(j) ' rvp file']);
            session(j).file = [p f];
        end
    end
    rot = input('Please input degrees to rotate second session RVP (90/180/270): ');
elseif nargin == 3
    session(1).file = file1;
    session(2).file = file2;
end

rot = rot/90;

sesh = importdata(session(1).file);
sesh(2) = importdata(session(2).file);

 
if exist('version','var') && version == 3
    sesh(2).AvgFrame_DF = flipud(sesh(2).AvgFrame_DF);
    sesh(1).AvgFrame_DF = flipud(sesh(1).AvgFrame_DF);
end
sesh(2).AvgFrame_DF = rot90(sesh(2).AvgFrame_DF,rot);

corr_rot = zeros(size(sesh(1).AvgFrame_DF));
 
num_binsx = size(sesh(1).AvgFrame_DF,2);
num_binsy = size(sesh(1).AvgFrame_DF,1);
 
for j = 1:num_binsy
    for k = 1:num_binsx
        temp = corrcoef(sesh(1).AvgFrame_DF{j,k},sesh(2).AvgFrame_DF{j,k});
        corr_rot(j,k) = temp(1,2);
    end
    
end
 
end