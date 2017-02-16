function [ nbad , bad_id] = checkDVT( DVT_file )
% nbad = checkDVT( DVT_file )
%   Checks each DVT file for possible dropped frames.

pos_data = importdata(DVT_file);
time = pos_data(:,2); % time in seconds

%Check for correct Cineplex sampling rate. 
dt = [0.033; round(diff(time),3)]; % probably should be >= 0.06 - this catches 0.037 and such which aren't really dropped frames
bad = dt < 0.030 & dt > 0.040; 

nbad = sum(bad);
bad_id = find(bad);

end

