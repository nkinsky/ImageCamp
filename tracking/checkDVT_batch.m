function [ nbad_array, bad_id ] = checkDVT_batch( MD )
% nbad_array  = checkDVT_batch( MD )
% Checks for bad/dropped frames in the DVT files for each session in MD.
% Assumes that the DVT file lives in a sibling folder to the working folder
% in MD.Location.  Spits out number of bad frames in each session.

curr_dir = cd;

num_sessions = length(MD);

nbad_array = zeros(1,num_sessions);
bad_id = cell(1,num_sessions);

for j = 1:num_sessions
    
    working_dir = ChangeDirectory_NK(MD(j),0); 
    % iterate through until you find the "Working" directory
    [p, f] = fileparts(working_dir);
    while ~strcmpi(f,'Working') && ~isempty(f)
        [p, f] = fileparts(p);
        if isempty(f)
            error(['Can''t find any folder with name "Working" for session ' num2str(j)])
        end
    end
        
    DVT_dir = fullfile(p,'Cineplex');
    cd(DVT_dir);
    DVT_file = ls('*.DVT');
    
    [nbad_array(j), bad_id{j}] = checkDVT(fullfile(DVT_dir,DVT_file));
    
end

cd(curr_dir);

end

