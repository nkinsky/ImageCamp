function [ entry_tracking ] = twoenv_track_entry( filename )
% entry_tracking = twoenv_track_entry( filename )
%   Tracks mouse entry into each arena for 2env experiment. Identifies from
%   which direction he is carried into the maze and which direction he is
%   initially facing.

% Select manually if no filename entered
if nargin < 1
    [fname, pathname] = uigetfile('*.avi', 'Select Video File: ');
    filename = fullfile(pathname, fname);
end

% If MD structure is entered for filename use that to get directory and
% file
if nargin > 0 && isstruct(filename)
    dirstr = ChangeDirectory_NK(filename,0);
    fname = ls(fullfile(dirstr,'Cineplex\*.avi'));
    filename = fullfile(dirstr,['Cineplex\' fname]);
end

dir_use = fileparts(filename);
%% Step 1 = load mouse vid file
vidobj = VideoReader(filename);
SR = vidobj.FrameRate;

%% Step 2 = step through until mouse crosses maze entry and mark it with
% right mouse click (button = 3, left mouse = 1);
hfig = figure; set(gcf,'Position', [488 342 560 420]); hax = gca;

disp('Use L/R buttons to cycle through frames.')
disp('Right click on mouse when he first crosses over the arena')
n_out = 1;
stay_in = true;
while stay_in
    time_plot = n_out/SR;
    plot_vidframe(vidobj, time_plot, 'hax', hax, 'flip_vert', true);
    [n_out, stay_in, xAVIenter, yAVIenter, button] = LR_cycle(n_out,[1 5000]);
    if button == 3
       xEnter = 0.6246*xAVIenter; yEnter = 0.6246*yAVIenter;
       disp('Now right click well in front of him in the direction he is facing.')
       disp('Hit spacebar if you can''t tell.')
       [xf, yf, button] = ginput(1); spacebar = 32;
       if button == spacebar
           xf = nan; yf = nan;
       end
       xEnterDir = 0.6246*xf - xEnter; yEnterDir = 0.6246*yf - yEnter;
    end
end
n_enter = n_out;

% keyboard

%% Step 3 = step through until mouse is placed on the maze and mark that
% with another right mouse click
disp('Now use L/R buttons until mouse touches down on the maze, then right click on him')
stay_in = true;
while stay_in
    time_plot = n_out/SR;
    plot_vidframe(vidobj, time_plot, 'hax', hax, 'flip_vert', true);
    [n_out, stay_in, xAVIland, yAVIland, button] = LR_cycle(n_out,[1 5000]);
    if button == 3
       xLand = 0.6246*xAVIland; yLand = 0.6246*yAVIland;
       disp('Now right click well in front of him in the direction he is facing.')
       disp('Hit spacebar if you can''t tell.')
       [xf, yf, button] = ginput(1); spacebar = 32;
       if button == spacebar
           xf = nan; yf = nan;
       end
       xLandDir = 0.6246*xf - xLand; yLandDir = 0.6246*yf - yLand;
    end
end
n_land = n_out;

%% Step 5 - double check to make sure you did everything right by plotting
% an arrow on top of the mouse at each time point
figure(hfig); set(gcf,'Position', [488 342 2*560 420])
h1 = subplot(1,2,1);
plot_vidframe(vidobj, n_enter/SR, 'hax', h1, 'flip_vert', true);
hold on
hq1 = quiver(xAVIenter, yAVIenter, xEnterDir/0.6246, yEnterDir/0.6246,'r-');
hold off

h2 = subplot(1,2,2);
plot_vidframe(vidobj, n_land/SR, 'hax', h2, 'flip_vert', true);
hold on
hq2 = quiver(xAVIland, yAVIland, xLandDir/0.6246, yLandDir/0.6246,'g-');
hold off

%% Step 6 = save this data
entry_vars = mat2cell([xEnter,yEnter,xEnterDir,yEnterDir,xLand,yLand,...
    xLandDir,yLandDir],1,ones(8,1));
entry_tracking = cell2struct(entry_vars, {'xEnter', 'yEnter', 'xEnterDir', ...
    'yEnterDir', 'xLand', 'yLand', 'xLandDir', 'yLandDir'},2);

save(fullfile(dir_use,'entry_tracking.mat'), 'entry_tracking')


end

