% Alternation workflow

%% -1) run combine_tracking on any sessions with 2 sessions

%% 0) Make a copy of Pos_comb.mat for any relevant sessions and rename it as
% Pos.mat.  Run the below in each directory of interest

load('Pos_comb.mat')
save('Pos.mat','n_image_frames','x_use','y_use','t_use','MoMtime','start_time',...
    'xpos_interp','ypos_interp','time_interp','exclude_time_interp')

%% 0.5) First plot everything and figure out what needs manual limits
base_sesh = G30_alt(1); % base session
% todo_sesh = MD([203 204 206 212 213]);
todo_sesh = run_pos_align; % sessions to do
% todo_sesh = MD(213);
figure; 
for j = 1:length(todo_sesh)
    clear exclude_time_interp
    subplot_auto(length(todo_sesh),j);
    ChangeDirectory_NK(todo_sesh(j));
    try
        load('Pos_comb.mat','xpos_interp','ypos_interp','time_interp',...
            'MoMtime','exclude_time_interp');
    catch
        load('Pos.mat','xpos_interp','ypos_interp','time_interp','MoMtime',...
            'exclude_time_interp');
    end
    
    exclude_frames = false(size(time_interp)) ; exc_time_min = nan; exc_time_max = nan;
    % Comment out below to check before doing pos_align!
    if exist('exclude_time_interp','var')
        % Below would work but there was a bug in Sam's PreProcess and now
        % the time in between in too small. Use for G48 10/1 sesh2.
%                exclude_frames = (time_interp >= min(exclude_time_interp)) & ...
%                    (time_interp <= max(exclude_time_interp));
        
        exc_time_min = min(exclude_time_interp);
        load(fullfile(todo_sesh(j).Location,'part2','Pos.mat'),...
            'MouseOnMazeFrame','start_time');
        exc_time_max = exc_time_min + MouseOnMazeFrame/30+start_time;
        exclude_frames((time_interp >= exc_time_min) & ...
            (time_interp <= exc_time_max)) = true;
        plot(xpos_interp(time_interp > MoMtime & ~exclude_frames), ...
            ypos_interp(time_interp > MoMtime & ~exclude_frames));
    else
        
    end
    
    plot(xpos_interp(time_interp > (MoMtime+2) & ~exclude_frames), ...
        ypos_interp(time_interp > (MoMtime+2) & ~exclude_frames),'b-');
    
%     plot(xpos_interp(time_interp > MoMtime), ...
%         ypos_interp(time_interp > MoMtime));
    if j == 1
        title(mouse_name_title(todo_sesh(j).Animal))
    else
        title([mouse_name_title(todo_sesh(j).Date) ' - s' num2str(todo_sesh(j).Session)])
    end
end

%% 1) Run batch_align_pos with 'base_adjust' name-pair set to false and
% manual_limits set to true.

man_limits_bool = false(1,length(todo_sesh));
% Adjust below as needed to only draw manual limits as required (based on
% plot from above)
man_limits_bool([]) = true;
man_limits_bool = cat(2, false, man_limits_bool);

batch_align_pos(base_sesh,todo_sesh,'base_adjust',false,...
    'manual_limits', man_limits_bool)

%% 2) Run Placefields_batch on all new sessions - make sure to use
% exclude_time_interp!!! Note this only works for sets of 2 sessions - if
% there are more than 2 sessions combined you will need to revisit this!

exc_times = []; suc_bool = false(1,length(todo_sesh));
for j = 10:length(todo_sesh)
    try
        sesh_use = todo_sesh(j);
        
        % Get timestamps to exclude in the middle of the session (times when I
        % took the mouse out of the arena for a break)
        clear exclude_time_interp time_interp MouseOnMazeFrame start_time
        load(fullfile(sesh_use.Location,'Pos_align.mat'),'time_interp')
        load(fullfile(sesh_use.Location,'Pos.mat'),'exclude_time_interp')
        exclude_frames = []; exc_time_min = nan; exc_time_max = nan;
        if exist('exclude_time_interp','var')
            % Below would work but there was a bug in Sam's PreProcess and now
            % the time in between in too small.
            %        exclude_frames = find((time_interp >= min(exclude_time_interp)) & ...
            %            (time_interp <= max(exclude_time_interp)));
            
            exc_time_min = min(exclude_time_interp);
            load(fullfile(sesh_use.Location,'part2','Pos.mat'),...
                'MouseOnMazeFrame','start_time');
            exc_time_max = exc_time_min + MouseOnMazeFrame/30+start_time;
            exclude_frames = find((time_interp >= exc_time_min) & ...
                (time_interp <= exc_time_max));
            
        end
        exc_times = [exc_times; exc_time_min exc_time_max];
        
        Placefields(sesh_use,'minspeed',1,'cmperbin',1,'name_append',...
            '_cm1','exclude_frames',exclude_frames)
        suc_bool(j) = true;
    catch
        disp(['error running session ' num2str(j)])
    end
end


%% 2.5) Run PF stats too - not sure if I truly need this yet, but might as 
% well run it now anyway

for j = 1:length(todo_sesh)
    sesh_use = todo_sesh(j);
    PlacefieldStats(sesh_use,'name_append','_cm1');
end

%% 3) Run sigtuning_batch on all new sessions
sesh_use = [];
perf = sigtuning_batch(sesh_use, 'Placefields_cm1.mat');

%% 4) Run plotSigSplitters in batch mode (code located in
% alternation_scratchpad) for all new sessions

%% 5) Run the heavy lifters: 
% plot_split_v_perf_batch - plot performance versus splitter proportion

% alt_split_v_recur_batch - looks at whether or no splittiness metrics
% influences reactivation or recurrence of being a splitter

% track_splitters - basic splitter ontogeny plots