function [ nbad , bad_id] = checkDVT( DVT_file )
% nbad = checkDVT( DVT_file )
%   Checks each DVT file for possible dropped frames.

pos_data = importdata(DVT_file);
time = pos_data(:,2); % time in seconds

%Check for correct Cineplex sampling rate. 
dt = [0.03; round(diff(time),2)]; 
bad = dt~=0.03; 

nbad = sum(bad);
bad_id = find(bad);

end

