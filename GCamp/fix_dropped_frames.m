function [] = fix_dropped_frames(infile,varargin)
% fix_dropped_frames(infile,...)
% Checks if your ICmovie has the correct number of frames, and fixes them
% if Mosaic did not account for them
%
% INPUTS
%   infile: full pathname to the h5 file you want to check/fix
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
       xml_files = {varargin{j+1}};
       num_files = length(xml_files);
   end
   if strcmpi(varargin{j},'txt_files')
       txt_files = varargin{j+1};
       num_files = length(txt_files);
   end
end

%% 0.25) Get Dropped Frame info from the text file

if exist('txt_files','var')
    for j = 1:num_files
        [frames(1,j), ~, dropped_frames{j}] = get_droppedframe_info(txt_files{j});
    end
elseif exist('xml_files','var')
    for j = 1:num_files
        [frames(1,j), ~, dropped_frames{j}] = get_droppedframe_infoXML(xml_files{j});
    end
end

%% 0.5) Check for edge case where the 1st frame is bad - haven't figure this out yet!

for j = 1:num_files
   if ~isempty(dropped_frames{j}) && dropped_frames{j}(1) == 1
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
    for k = 1:frames_total(j)
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


%% 2) Set up the h5 movie - put this in a directory parallel to the original movie

info = h5info(infile,'/Object');
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

size_metadata_use = info.Dataspace.Size;
size_metadata_use(3) = end_frame;

% Set-up new directory and accompanying files for fixed file - this will
% make the new files compatible with Mosaic
[inpath, in_filename, ext] = fileparts(infile); % Get fileparts
% Set up new directory
ff = filesep;
dir_start = max(regexpi(inpath,ff));
cut_off = max(regexpi(inpath,'-Objects'));
new_dir = [inpath(1:cut_off-1) '_fixed-Objects'];
if exist(new_dir,'dir') ~=7
    mkdir(new_dir)
else % Error clause to make sure you don't overwrite anything accidentally
    disp(['New directory: ' new_dir ' already exists.  Proceeding may overwrite anything in it!'])
    disp('Type ''return'' to continue, or quit and check/clear out the directory if you are unsure')
    keyboard
end

% Make new .h5 filename and file
ext_ind = regexpi(in_filename,'.h5');
new_h5filename = [in_filename '_fixed.h5'];
outfile = fullfile(new_dir,new_h5filename);
h5create(outfile,'/Object',size_metadata_use,'ChunkSize',[XDim YDim 1 1],'Datatype','uint16');

% Now, load original .mat reference file in the ICmovie directory
new_matfilename1 = [in_filename '_fixed.mat'];
new_mat1file = fullfile(new_dir, new_matfilename1); % New matlab filename
load(fullfile(inpath,[in_filename '.mat']));  % Load original .mat file with Object and Index variables
% Fix Index file
Index.ObjFile = new_matfilename1;
Index.H5File = new_h5filename;
Index.DataSize = size_metadata_use;
Index_temp = Index; % Send to temp file for later...
% Fix Object file
Object.DataSize = size_metadata_use;
max_time = Object.TimeFrame(end);
orig_numframes = length(Object.TimeFrame);
SR_use = 1/round(Object.FrameRate);
Object.TimeFrame(orig_numframes+1:end_frame) = max_time+SR_use:SR_use:max_time+SR_use*(end_frame-orig_numframes);
Object.DroppedFrames = 0; % Without this they will still appear empty in Mosaic
% Save everything in the appropriate file
save(new_mat1file,'Index','Object');

% Finally, copy over Index file and save .mat reference file that lives in
% directory above
parent_end = max(regexpi(inpath,ff));
new_matfilename2 = fullfile(inpath(1:parent_end-1),[inpath(dir_start+1:cut_off-1) '_fixed.mat']);
clear Index
Index{1} = Index_temp;
save(new_matfilename2,'Index');

% keyboard

%% 3) Scroll through successive dropped frames and add them in
%   - if the # of dropped frames is 1, interpolate, otherwise replace with
%   the previous good frame

n_good_use = 0;
p = ProgressBar(end_frame);
for k = 1:end_frame
    try
        if sum(k == real_frame_ind_all) == 1 % Good (non-dropped) frame
            n_good_use = n_good_use + 1; % update current good frame to use
            Fuse = h5read(infile,'/Object',[1 1 n_good_use 1],[XDim YDim 1 1]); % Grab good frame
            h5write(outfile,'/Object',uint16(Fuse),[1 1 k 1],[XDim YDim 1 1]); % write good frame to the appropriate spot
        elseif sum(k == dropped_frames_all) == 1 % Dropped frame
            Fuse = h5read(infile,'/Object',[1 1 n_good_use 1],[XDim YDim 1 1]); % Grab good frame
            h5write(outfile,'/Object',uint16(Fuse),[1 1 k 1],[XDim YDim 1 1]); % write good frame to the appropriate spot
            % interpolate if it is a single, isolated dropped frame!
            %        if
            %
            %        end
        end
    catch
        disp('Error in the above - check it!')
        keyboard
    end
    p.progress;
end
p.stop; 

% Check to make sure everything worked
if n_good_use ~= sum(frames)
    disp('Did not use all the original frames.  Something might be screwed up!')
end

%%

end