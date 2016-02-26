function [] = PFA_batch(session_struct,roomstr,progress_bar,varargin)
% PFA_batch(session_struct, roomstr, progress_bar, varargin)
% 
% Batch place-field analysis wrapper function.  
%
% INPUTS
% session_struct - taken from MakeMouseSessionList, enter in the structure
% for the sessions you want to analyze
%
% roomstr is the name of the room e.g. '201a'
%
% progress bar = 1 will display a progress bar in lieu of
% spam to your screen for progress (default) , 0 will spam your screen
%
% varargins:
%   -'rotate_to_std': 0 is default and will work with data that has not
%       been rotated in any way through the function batch_align_pos, 1 will work 
%       with position data that has been rotated such that local cues align
%       across all sessions. Specify as (...,'rotate_to_std', 1)
%
%   -'cmperbin': cm/bin for calculating occupancy and transient heat maps.
%       1 is default if left blank
%
%   -'calc_half': 0 = default. 1 = calculate TMap and pvalues for 1st
%       and 2nd half of session along with whole session maps
%
%   -'use_mut_info': use mutual information along with entropy to calculate
%   pvals...
%
%   -'minspeed': threshold for calculating placemaps.  Any values below
%        are not used. 1 cm/s = default.  
%
%   -'pos_align_file': use to load a Pos_align file that is not either
%       Pos_align.mat or Pos_align_std_corr.mat. must follow
%       'pos_align_file' with two arguments: 1) the name of the file to
%       load, and 2) a name to append to the Placefields file that will be
%       saved as output


if nargin < 3
    progress_bar = 1;
end

%% Get varargins

rotate_to_std = 0; % default
cmperbin = 1; % default
calc_half = 0; % default
use_mut_info = 0; % default
minspeed = 1; % default
pos_align_file = ''; % default
name_append2 = ''; % default
for j = 1:length(varargin)
   if strcmpi(varargin{j},'rotate_to_std')
       rotate_to_std = varargin{j+1};
   end
   if strcmpi(varargin{j},'cmperbin')
       cmperbin = varargin{j+1};
   end
   if strcmpi(varargin{j},'calc_half')
       calc_half = varargin{j+1};
   end
   if strcmpi(varargin{j},'use_mut_info')
       use_mut_info = varargin{j+1};
   end
   if strcmpi(varargin{j},'minspeed')
       minspeed = varargin{j+1};
   end
   if strcmpi(varargin{j},'pos_align_file')
        pos_align_file = varargin{j+1};
        name_append2 = varargin{j+2};
   end
end

%% First, check to make sure all the appropriate files exist
for j = 1:length(session_struct)
    ChangeDirectory_NK(session_struct(j));
    proc_exist(j) = exist('ProcOut.mat','file') == 2;
    pos_exist(j) = exist('Pos.mat','file') == 2;
end

if sum(proc_exist & pos_exist) == length(proc_exist) % proceed if all is ok
    disp('All required files are in the working directories - proceeding!')
else
    proc_missing = find(proc_exist == 0);
    pos_missing = find(pos_exist == 0);
    for k = 1:length(proc_missing)
        disp(['ProcOut.mat missing for ' session_struct(proc_missing(k)).Date])
    end
    
    for k = 1:length(pos_missing)
       disp(['Pos.mat missing for ' session_struct(pos_missing(k)).Date ...
           ' session #' num2str(session_struct(pos_missing(k)).Session)]) 
    end
    return
end


%% Run it for all sessions
for j = 1:length(session_struct)
    ChangeDirectory_NK(session_struct(j));
    % Exclude the appropriate frames if doing an alternation session
    if strcmpi('correct left trials only',session_struct(j).Notes)
        load Alternation.mat
        session_struct(j).exclude_frames = find(~(Alt.choice == 1 & Alt.alt == 1));
    elseif strcmpi('correct right trials only',session_struct(j).Notes)
        load Alternation.mat
        session_struct(j).exclude_frames = find(~(Alt.choice == 2 & Alt.alt == 1));
    end
    
    % Step 1: Calculate Placefields
    disp(['Calculating Placefields for ' session_struct(j).Date ' session ' ...
        num2str(session_struct(j).Session) ])
    if  isempty(session_struct(j).exclude_frames)
        PF_filename = CalculatePlacefields(roomstr,'progress_bar',progress_bar,...
            'rotate_to_std',rotate_to_std,'cmperbin',cmperbin,'calc_half',calc_half,...
            'use_mut_info', use_mut_info,'minspeed',minspeed,'pos_align_file',...
            pos_align_file, name_append2);
    elseif ~isempty(session_struct(j).exclude_frames)
        disp('Excluding frames - see session_struct for exact frames')
        PF_filename = CalculatePlacefields(roomstr,'progress_bar',progress_bar,'exclude_frames',...
            session_struct(j).exclude_frames,'rotate_to_std',rotate_to_std,...
            'cmperbin',cmperbin,'calc_half',calc_half,'use_mut_info',use_mut_info,...
            'minspeed',minspeed, 'pos_align_file',pos_align_file, name_append2);
    end
        
    % Step 2: Calculate Placefield stats
    disp(['Calculating Placefield Stats for ' session_struct(j).Date ' session ' ...
        num2str(session_struct(j).Session) ])
    PFstats(rotate_to_std,'alt_file_use',PF_filename,name_append2);

end

end

