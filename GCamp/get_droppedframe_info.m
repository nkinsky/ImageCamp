function [ frames, dropped_count, dropped_ind] = get_droppedframe_info(varargin)
%[ frames, dropped_count, dropped_frames_id] = get_badframe_info( ref_files )
%  Pulls info about frames, dropped frames, and the indices of the dropped
%  frames from an nVista/Inscopix .txt recording file
%
% INPUTS: .txt recording file from nVista/Mosaic - full pathname(s) listed as an argument,
% e.g. get_badframe_info(file1,file2,...)
%
% OUTPUTS:
%   frames: total number of frames that were recorded
%
%   dropped_count: total number of dropped frames.  NOTE: the total number
%   of frames that should have been recorded is = frames + dropped_count.
%   That is, if you recorded for 6 seconds at 20 fps, you might see 100
%   frames + 20 droped frames.
%
%   dropped_ind: the frames numbers of the dropped frames


%% Step 1: Import text files

if isempty(varargin)
    file = file_select_batch('*.txt');
else
    for j = 1:length(varargin)
        file(j).path = varargin{j};
    end
end
num_files = length(file);

for j = 1:num_files
    fid = fopen(file(j).path);
    sesh(j).data = textscan(fid,'%s %s','Delimiter',':');
    
    % Get rows for each data point
    frame_row = cellfun(@(a) strcmp(a,'FRAMES'),sesh(j).data{1});
    dropped_count_row = cellfun(@(a) strcmp(a,'DROPPED COUNT'),sesh(j).data{1});
    dropped_ind_row = cellfun(@(a) strcmp(a,'DROPPED'),sesh(j).data{1});
    
    % Get frame information
    frames = str2num(sesh(j).data{2}{frame_row});
    dropped_count = str2num(sesh(j).data{2}{dropped_count_row});
    
    % Get dropped frames numbers
    temp = sesh(j).data{2}{dropped_ind_row};
    dropped_ind = str2num(temp);
end


end

