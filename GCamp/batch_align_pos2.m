function [ output_args ] = batch_align_pos2(base_sesh, reg_sesh, varargin )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


warning('off','MATLAB:load:variableNotFound')
%% 1) Load data for each session - xAVI, yAVI, xpos_interp, ypos_interp
% 1.5) if exist('maze') as variable in Pos.mat, oldshool = true; if
% oldschool, sfavi = 1/0.6246;
sessions = complete_MD(cat(1,base_sesh,reg_sesh));
num_sessions = length(sessions);
for j = 1:num_sessions
   load(fullfile(sessions(j).Location,'Pos.mat'),'xpos_interp','ypos_interp',...
       'xAVI','yAVI','maze');
   load(fullfile(seseions(j).Location,'FinalOutput.mat'),'PSAbool','NeuronTraces');
   LPtrace = NeuronTraces.LPtrace;
   DFDTtrace = NeuronTraces.DFDTtrace;
   RawTrace = NeuronTraces.RawTrace;
   sessions(j).xpos_interp = xpos_interp;
   sessions(j).ypos_interp = ypos_interp;
   sessions(j).oldschool = exist('maze','var');
   sessions(j).xAVI = xAVI;
   sessions(j).yAVI = yAVI;
   if exist('maze','var')
       sessions(j).sfavi = 1/0.6246;
   else
       sessions(j).sfavi = 1;
   end
   
   % draw limits of arena
   h = plot_traj2(sessions(j), 'plot_vid', true, 'xy_append', 'AVI');
   hold on
   [~, ~, ~, sessions(j).xlims, sessions(j).ylims] = ...
       draw_manual_limits(xAVI, yAVI, '', h, 'Drag rectangle to arena limits');
   
   % Calculate drawn arena size
   sessions(j).xrange = range(sessions(j).xlims);
   sessions(j).yrange = range(sessions(j).ylims);
   
   % get scale factor for x and y from session j to session 1
   sessions(j).sfx = sessions(1).xrange/sessions(j).xrange;
   sessions(j).sfy = sessions(1).yrange/sessions(j).yrange;
   
   % Get offset of bottom left from session j to session 1
   sessions(j).xoffset = sessions(j).xlims(1) - sessions(1).xlims(1);
   sessions(j).yoffset = sessions(j).ylims(1) - sessions(1).ylims(1);
   
   % AlignImaging to tracking get x and y and speed in cm and cm/s
   [x,y,speed,PSAbool,FToffset,FToffsetRear,aviTime,time_interp,nframesinserted] = ...
       AlignImagingToTracking(sessions(j).Pix2Cm, PSAbool, 0, 'suppress_output', ...
       suppress_output);
   
   [~,~,~,LPtrace] = AlignImagingToTracking(sesssions(j).Pix2Cm, ...
       NeuronTraces.LPtrace,0, 'suppress_output', true);
   [~,~,~,DFDTtrace] = AlignImagingToTracking(sesssions(j).Pix2Cm,...
       NeuronTraces.DFDTtrace, 0, 'suppress_output', true);
   [~,~,~,RawTrace] = AlignImagingToTracking(sesssions(j).Pix2Cm,...
       NeuronTraces.RawTrace, 0, 'suppress_output', true);
   sessions(j).LPtrace = LPtrace;
   sessions(j).DFDTtrace = DFDTtrace;
   sessions(j).RawTrace = RawTrace;
   
   % Dump everything into the structure
   sessions(j).PSAbool = PSAbool;
   sessions(j).NeuronTraces = NeuronTraces;
   sessions(j).speed = speed;
   sessions(j).FToffset = FToffset;
   sessions(j).FToffsetRear = FToffsetRear;
   sessions(j).x = x;
   sessions(j).y = y;
   sessions(j).aviFrame = aviTime;
   sessions(j).time_interp = time_interp;
   sessions(j).nframesinserted = nframesinserted;
    
   % Adjust data to 0,0 at bottom left of arena - use x and y from
   % alignimaging here...
   x0 = xpos_interp - sessions(j).xpos_interp;
   y0 = ypos_interp - sessions(j).ypos_interp;
   
   % Scale data just a bit so it all matches up
   sessions(j).xalign = x0*sessions(j).sfx;
   sessions(j).yalign = y0*sessions(j).sfy;
   
   % Make overall limits that of first arena in CM
   sessions(j).xlimsCM = sessions(1).xlims*sessions(j).Pix2CM;
   sessions(j).ylimsCM = sessions(1).ylims*sessions(j).Pix2CM;
   
   
   
   
end
warning('on','MATLAB:load:variableNotFound')
%%
keyboard
%%
rect_lim = [sessions(1).xlimsCM(1). sessions(1).ylimsCM(1),...
    range(sessions(1).xlimsCM), range(sessions(1).ylimsCM)];
figure(52);
for j = 1:num_sessions
    subplot(4,4,1)
    plot(sessions(j).xalign,session(j).yalign)
    hold on
    
    subplot(4,4,j+1)
    plot(sessions(j).xalign,session(j).yalign)
    hold on
    rectangle(rect_lim)
    
end
subplot(4,4,1)
rectangle(rect_lim)


% 3) plot all on top of one another and draw limits

% 4) spit out all overlaid with limits plus each individual session

%% 5) save stuff
xmin = sessions(1).xlimsCM(1); xmax = sessions(1).xlimsCM(2);
ymin = sessions(1).ylimsCM(1); ymax = sessions(1).ylimsCM(2);
sessions_included = cat(1,base_sesh,reg_sesh);

for j = 1:num_sessions
    PSAbool = sessions(j).PSAbool;
%     NeuronTraces = sessions(j).NeuronTraces;
    x_adj_cm = sessions(j).xalign;
    y_adj_cm = sessions(j).yalign;
    speed = sessions(j).speed;
    FToffset = sessions(j).FToffset;
    LPtrace = sesh(j).LPtrace(:,ik);
    DFDTtrace = sessions(j).DFDTtrace(:,ik);
    RawTrace = sessions(j).RawTrace(:,ik);
    FToffset = sessions(j).FToffset;
    FToffsetRear = sessions(j).FToffsetRear;
    aviFrame = sessions(j).aviFrame(ik);
    time_interp = sessions(j).time_interp(ik);
    nframesinserted = sessions(j).nframesinserted;
    Pix2CM = sessions(j).Pix2CM;
    
%     save(fullfile(sessions(j).Location,'Pos_align.mat'), 'PSAbool',...
%         'NeuronTraces','x_adj_cm','y_adj_cm',...
%         'speed','xmin','xmax','ymin','ymax','FToffset');
    
    save(fullfile(sessions(j).Location,'Pos_align.mat'),...
        'x_adj_cm','y_adj_cm','xmin','xmax','ymin','ymax','speed',...
        'PSAbool','LPtrace','DFDTtrace','RawTrace','FToffset',...
        'nframesinserted','time_interp','FToffsetRear','aviFrame',...
        'base_sesh','sessions_included', 'Pix2CM');
end

end

