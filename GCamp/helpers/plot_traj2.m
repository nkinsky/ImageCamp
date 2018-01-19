function [ h ] = plot_traj2( session, varargin )
% h = FCplot( sessions, varargin )
%   Plots trajectory for a given session from Pos.mat. Spits out handle
%   axes in h. Plots in cm coordinates by default

%% Parse Inputs
ip = inputParser;
ip.addRequired('session',@isstruct);
ip.addParameter('plot_vid', false, @(a) islogical(a) || a == 1 || a == 0);
ip.addParameter('xy_append', 'pos_interp', @ischar);
ip.addParameter('h_in', nan, @(a) ishandle(a) || isnan(a));
ip.addParameter('pos_file', 'Pos.mat', @ischar);
ip.addParameter('dir_append', '', @ischar); % folder to append to base directory in case files live there
ip.addParameter('title_line2','', @ischar); % Line to include under mouse name/date/session
ip.addParameter('omit_session',false,@islogical); % Omit session from title

ip.parse(session,varargin{:});
plot_vid = ip.Results.plot_vid;
xy_append = ip.Results.xy_append;
h_in = ip.Results.h_in;
pos_file = ip.Results.pos_file;
dir_append = ip.Results.dir_append;
title_line2 = ip.Results.title_line2;
omit_session = ip.Results.omit_session;

%% Setup plot axes and base directory
if ~ishandle(h_in)
    figure; h_in = gca;
end
h = h_in;

dirstr = ChangeDirectory(session.Animal,session.Date,session.Session,0);
dirstr = fullfile(dirstr,dir_append);

%% Plot stuff
axes(h_in)
if ~plot_vid % Plot trajectory
    temp = load(fullfile(dirstr,pos_file), ['x' xy_append], ['y' xy_append]);
    x_use = temp.(['x' xy_append]);
    y_use = temp.(['y' xy_append]);
    
    plot(x_use,y_use);
    axis tight
    axis off
    
elseif plot_vid % Plot 1st video frame
    vidfile = ls(fullfile(dirstr,'*.avi'));
    if size(vidfile,1) ~= 1
        error('More than one AVI file in directory specified')
    end
    vidobj = VideoReader(fullfile(dirstr,vidfile));
    frame_plot = readFrame(vidobj);
    imagesc(frame_plot)
    axis tight
    axis off
end
if ~omit_session
    title({[mouse_name_title(session.Animal) ' - ' mouse_name_title(session.Date) ...
        ' session ' num2str(session.Session)], title_line2})
elseif omit_session
    title({[mouse_name_title(session.Animal) ' - ' mouse_name_title(session.Date)],...
        title_line2})
end

end

