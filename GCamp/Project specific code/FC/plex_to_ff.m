function [  ] = plex_to_ff( basedir )
% plex_to_ff( basedir )
%  Converts an AVI and DVT file in basedir to a dropped AVI and csv file
%  with timestamps that can be used with Will's FreezeFrame editor.
%  Must manually move files into a FreezeFrame directory in the same folder
%  later.

% currdir = pwd;
if nargin == 0
    basedir = uigetdir(pwd,'Select Directory');
end

avi_filename = ls(fullfile(basedir,'*.AVI'));
dvt_filename = ls(fullfile(basedir,'*.DVT'));
cropVideo(avi_filename);
dvt2index(dvt_filename, avi_filename);

end

