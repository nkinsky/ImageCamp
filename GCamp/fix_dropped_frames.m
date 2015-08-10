function [] = fix_dropped_frames(infile,varargin)
% fix_dropped_frames(infile,...)
% Checks if your ICmovie has the correct number of frames, and fixes them
% if Mosaic did not account for them
%
% INPUTS
%   infile: full pathname to the file you want to check/fix
%   
%   YOU MUST ENTER ONE OF THE FOLLOWING:
%   'frames': enter as fix_dropped_frames(...'frames', 1 x n array,...)  where each entry is the
%   number of frames from the xml or txt file, and ...
%   'dropped_frames': enter as fix_dropped_frames(...'dropped_frames', 1 x
%   n cell,...) where each cell entry is an array containing the dropped
%   frame numbers from the file in question.
%   'xml_files','txt_files': enter as fix_dropped_frames(infile,'xml_files', 1 x n
%   cell) where the cell array contains the full pathname to the xml or txt
%   files for that recording session in the same order they were originally
%   put in. NOT YET IMPLEMENTED - for future if I get around to it.
%
%   OUTPUTS
%   This function will save a file in the same directory as the infile with
%   '_fixed' appended to the filename.

% pseudocode
% inputs = path to ICmovie, path to xlm/txt file OR number of frames and
% dropped frames from each file

%% 0) Process varargins
for j = 1:length(varargin)
   if strcmpi(varargin{j},'frames')
       frames = varargin{j+1};
       num_files = length(frames);
   end
   if strcmpi(varargin{j},'dropped_frames')
       dropped_frames = varargin{j+1};
   end
   if strcmpi(varargin{j},'xml_files')
       xml_files = varargin{j+1};
       num_files = length(xml_files);
   end
   if strcmpi(varargin{j},'txt_files')
       txt_files = varargin{j+1};
       num_files = length(txt_files);
   end
end

%% 0.5) Check for edge case where the 1st frame is bad - haven't figure this out yet!

for j = 1:num_files
   if dropped_frames{j}(1) == 1
       error('1st frame is bad - haven''t implemented this edge case fix yet.  Sorry!  At least I acknowledged it')
   end
end

%% 1) Get number of frames and number of dropped frames for the file, and
% calculate the total number of frames there should be.  Make this
% applicable to files where you have concatenated imaging videos.  Also
% grab the numbers of the dropped frames, and adjust these numbers for
% subsequenet sessions (e.g. if the 2nd session has dropped frames = 20 &
% 105, and the 1st session has 1000 total frames, adjust the dropped frames
% to 1020 and 1105)
%   - will require writing subfunction(s) that grab these values out of the
%   text file of xml file - this might be hard for xml files

end_frame = 0;
frames_total = zeros(size(frames));
real_frame_ind_all = [];
dropped_frames_all = [];
for j = 1:num_files
    frames_total(j) = frames(j) + length(dropped_frames{j}); % Get total number of frames for each file
    
    
    % Count through all the frames and assign them to either the good frame
    % list or the bad frame list - say you have 80 frames and 20 bad frames ([5 10 15 20 ...]).  First,
    %   figure out what the real frames are for the original video (e.g. for
    %   the above case, it would be [1 2 3 4 6 7 8 9 11 12 ...].  When the for
    %   statement gets to a bad frame, run the replacement algorithm, add it
    %   into the new .h5 file, and continue on.
    n = 1; % Set start frame
    n_good = 1;
    for k = 1:frames(j)
        if sum(n == dropped_frames{j}) == 0
            real_frame_ind{j}(n_good) = n;  % %Tells you where each frame in the existing movie should go in the fixed movie
            n_good = n_good + 1; % update frame number in existing h5 file
        end
        n = n + 1; % update current frame
    end
    
    % Above has been check for 1 session, check below and above for more
    % than 1 session!
    real_frame_ind_all = [real_frame_ind_all (end_frame + real_frame_ind{j})];
    dropped_frames_all = [dropped_frames_all (end_frame + dropped_frames{j})];
    
    end_frame = end_frame + frames_total(j); % Update the true number frames there should be after each session is concatenated
end


%% 2) Set up the h5 movie

info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

ext_ind = regexpi(infile,'.h5');
outfile = [infile(1:ext_ind-1) '_fixed.h5'];
h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','uint16');

%% 3) Scroll through successive dropped frames and add them in
%   - if the # of dropped frames is 1, interpolate, otherwise replace with
%   the previous good frame

n_good_use = 1;
for k = 1:end_frame
   if sum(k == real_frame_ind_all) == 1 % Good (non-dropped) frame
       Fuse = h5read(infile,'/Object',[1 1 n_good_use 1],[XDim YDim 1 1]); % Grab good frame
       h5write(outfile,'/Object',uint16(Fuse),[1 1 k 1],[XDim YDim 1 1]); % write good frame to the appropriate spot
       n_good_use = n_good_use + 1; % update current good frame to use
   elseif sum(k == dropped_frames_all) == 1 % Dropped frame
       Fuse = h5read(infile,'/Object',[1 1 n_good_use 1],[XDim YDim 1 1]); % Grab good frame
       h5write(outfile,'/Object',uint16(Fuse),[1 1 k 1],[XDim YDim 1 1]); % write good frame to the appropriate spot
       
       % interpolate if it is a single, isolated dropped frame!
%        if 
%            
%        end
   end
end

% Check to make sure everything worked
if n_good_use ~= sum(frames)
    disp('Did not use all the original frames.  Something is screwed up!')
end


end