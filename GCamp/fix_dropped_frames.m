function [] = fix_dropped_frames()
% Checks if your ICmovie has the correct number of frames, and fixes them
% if Mosaic did not account for them

% pseudocode
% inputs = path to ICmovie, path to xlm/txt file OR number of frames and
% dropped frames from each file
% 1) Get number of frames and number of dropped frames for the file, and
% calculate the total number of frames there should be.  Make this
% applicable to files where you have concatenated imaging videos.  Also
% grab the numbers of the dropped frames, and adjust these numbers for
% subsequenet sessions (e.g. if the 2nd session has dropped frames = 20 &
% 105, and the 1st session has 1000 total frames, adjust the dropped frames
% to 1020 and 1105)
%   - will require writing subfunction(s) that grab these values out of the
%   text file of xml file - this might be hard for xml files
%
% 2) Scroll through successive dropped frames and add them in
%   - if the # of dropped frames is 1, interpolate, otherwise replace with
%   the previous good frame
%   - say you have 80 frames and 20 bad frames ([5 10 15 20 ...]).  First,
%   figure out what the real frames are for the original video (e.g. for
%   the above case, it would be [1 2 3 4 6 7 8 9 11 12 ...].  When the for
%   statement gets to a bad frame, run the replacement algorithm, add it
%   into the new .h5 file, and continue on.





end