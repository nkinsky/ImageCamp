function [ ] = dvt2index( dvt_filename, avi_filename )
% dvt2index( dvt_filename )
%  Converts a DVT file to just time indices in csv format for use with
%  Will's FreezeFrame mouse tracker softward in python.  Saves as
%  Index.csv.

if nargin == 0
    dvt_filename = ls('*.DVT');
    avi_filename = ls('*.AVI');
end

if size(dvt_filename,1) > 1 || size(avi_filename,1) > 1
    error('You must only have one DVT and one AVI file in the directory')
end

temp = importdata(dvt_filename);
obj = VideoReader(avi_filename);
nframes = obj.NumberOfFrames;

timestamps = temp(:,2);
if length(timestamps) < (nframes +1)
    nadd = nframes - length(timestamps) + 1;
    timestamps = [timestamps; repmat(timestamps(end),nadd,1)];
end

[~, filebase] = fileparts(dvt_filename);
csv_name = [filebase '_Index.csv'];

csvwrite(csv_name,timestamps);

end

