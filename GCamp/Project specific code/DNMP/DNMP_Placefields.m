function [] = DNMP_Placefields( session_struct, varargin )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

stats_only = 0;
calc_half = 1;
for j = 1:length(varargin)
   if strcmpi(varargin{j},'stats_only') 
       stats_only = varargin{j+1};
   end
   if strcmpi(varargin{j},'calc_half') 
       calc_half = varargin{j+1};
   end
end

cmperbin = 0.25;
NumShuffles = 500; % For starters

% SaveNames
save_names = {'PlaceMapsv2_forced_025cmbins.mat','PlaceMapsv2_free_025cmbins.mat'};% {'PlaceMapsv2_onmaze.mat','PlaceMapsv2_forced.mat','PlaceMapsv2_free.mat',...
%     'PlaceMapsv2_forced_left.mat','PlaceMapsv2_forced_right.mat',...
%     'PlaceMapsv2_free_left.mat','PlaceMapsv2_free_right.mat'};
name_append = {'forced_025cmbins', 'free_025cmbins'}; %{'onmaze','forced','free',...
%     'forced_left','forced_right',...
%     'free_left','free_right'};
exc_frames_type = {'forced_exclude','free_exclude'};% {'on_maze_exclude','forced_exclude','free_exclude',...
%     'forced_l_exclude','forced_r_exclude','free_l_exclude','free_r_exclude'};

if stats_only == 0
    for j = 1:length(session_struct)
        room = session_struct(j).Room;
        ChangeDirectory_NK(session_struct(j));
        exc_frames = load('exclude_frames.mat'); % Load frames to exclude for each type of trials - must run DNMP_parse_trials beforehand to get
        
        for k = 2 %length(save_names)
            % Get on-maze PFs
            disp(['Running CalculatePlaceFields for ' name_append{k} ' session.'])
            CalculatePlacefields(room,'exclude_frames_raw',exc_frames.(exc_frames_type{k}),...
                'alt_inputs','T2output.mat','man_savename',save_names{k},...
                'half_window',0,'minspeed',3,'cmperbin',cmperbin,...
                'NumShuffles',NumShuffles,'calc_half',calc_half);
        end
        
        
        
    end

end


%% Get stats

for k = 1:1 % length(save_names)
    disp(['Running PFstats for ' name_append{k} ' session.'])
    PFstats(0, 'alt_file_use', save_names{k}, name_append{k})
end

end

