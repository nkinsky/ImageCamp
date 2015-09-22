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
%   been rotated in any way through the function batch_align_pos, 1 will work 
%   with position data that has been rotated such that local cues align
%   across all sessions. Specify as (...,'rotate_to_std', 1)
%
%   -'cmperbin': cm/bin for calculating occupancy and transient heat maps.
%   1 is default if left blank
%
%   -'calc_half': 0 = default. 1 = calculate TMap and pvalues for 1st
%   and 2nd half of session along with whole session maps


if nargin < 3
    progress_bar = 1;
end

%% Get varargins

rotate_to_std = 0; % default
cmperbin = 1; % default
calc_half = 0; % default
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
    
    % Step 1: Calculate Placefields
    disp(['Calculating Placefields for ' session_struct(j).Date ' session ' ...
        num2str(session_struct(j).Session) ])
    if  isempty(session_struct(j).exclude_frames)
        CalculatePlacefields(roomstr,'progress_bar',progress_bar,...
            'rotate_to_std',rotate_to_std,'cmperbin',cmperbin,'calc_half',calc_half);
    elseif ~isempty(session_struct(j).exclude_frames)
        disp('Excluding frames - see session_struct for exact frames')
        CalculatePlacefields(roomstr,'progress_bar',progress_bar,'exclude_frames',...
            session_struct(j).exclude_frames,'rotate_to_std',rotate_to_std,...
            'cmperbin',cmperbin,'calc_half',calc_half);
    end
        
    % Step 2: Calculate Placefield stats
    disp(['Calculating Placefield Stats for ' session_struct(j).Date ' session ' ...
        num2str(session_struct(j).Session) ])
    PFstats(rotate_to_std);

end

end

