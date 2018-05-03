function [ h ] = twoenv_qc_entry( sesh, cycle )
% h = twoenv_qc_entry( sesh, cycle )
%   Makes sure everything is plotting legit angles from the entry and
%   landing data processed by Evan. Leaving cycle blank or setting to true
%   lets you cycle through all PFs with L/R buttons.

if nargin < 2
    cycle = true;
end

%% Get file info and load appropriate files
dir = ChangeDirectory_NK(sesh,0);
cdir = fullfile(fileparts(dir),'Cineplex');
if ~exist(cdir,'dir')
    cdir = fullfile(fileparts(fileparts(dir)),'Cineplex'); 
end
avifile = ls(fullfile(cdir,'*.avi'));
avi_full = fullfile(cdir,avifile(1,:));
vidobj = VideoReader(avi_full);
frame = readFrame(vidobj);

load(fullfile(dir,'Pos.mat'),'xpos_interp','ypos_interp')
load(fullfile(dir,'entry_tracking.mat'))
[~, rot_plot] = get_rot_from_db(sesh);
load(fullfile(dir,['Placefields_rot' num2str(rot_plot) '.mat']),...
    'PSAbool','x','y','TMap_gauss');
% Flip x and y to be compatible with everything else
TMap_gauss = cellfun(@transpose, TMap_gauss, 'UniformOutput', false);  %#ok<*NODEF>

thetas = twoenv_get_entry_angles(sesh);
%% Plot trajectory on top of arena with entry/landing points/directions
h = figure; set(gcf,'Position', [2000 420 1320 420]);
subplot(1,3,1)
imagesc(flipud(frame)); set(gca,'YDir','normal')
hold on
plot(xpos_interp*0.6246, ypos_interp*0.6246);
he = quiver(entry_tracking.xEnter/0.6426,entry_tracking.yEnter/0.6246,...
    entry_tracking.xEnterDir,entry_tracking.yEnterDir,'g');
if isnan(entry_tracking.xEnterDir)
    plot(entry_tracking.xEnter/0.6426,entry_tracking.yEnter/0.6246,'g*');
end
hland = quiver(entry_tracking.xLand/0.6426,entry_tracking.yLand/0.6246,...
    entry_tracking.xLandDir,entry_tracking.yLandDir,'r');
if isnan(entry_tracking.xLandDir)
    plot(entry_tracking.xLand/0.6426,entry_tracking.yLand/0.6246,'r*');
end
hland.LineWidth = 2; hland.MaxHeadSize = 1;
he.LineWidth = 2; he.MaxHeadSize = 1;
xlabel(['Entry angle = ' num2str(thetas(1),'%0.0f') ' dir = ' ...
    num2str(thetas(2),'%0.0f')]);
title(['Land direction = ' num2str(thetas(3), '%0.0f')])

% Zoom in only on the arena
[fy,yy] = ecdf(ypos_interp);
[fx,xx] = ecdf(xpos_interp);
xlim_use = arrayfun(@(a) xx(findclosest(fx,a)),[0.05 0.95])*0.6246 + [-75 75];
ylim_use = arrayfun(@(a) yy(findclosest(fy,a)),[0.05 0.95])*0.6246 + [-75 75];
set(gca,'XLim',xlim_use,'YLim',ylim_use)

%% Plot trajectory with neuron activity and TMap

n_out = 1; stay_in = true;
htraj = subplot(1,3,2);
hmap = subplot(1,3,3);
if cycle
    while stay_in
        
        plot_traj_and_TMap(x,y,PSAbool,TMap_gauss,n_out,htraj,hmap);
        [n_out, stay_in] = LR_cycle(n_out, [1, length(TMap_gauss)]);
        
    end
elseif ~cycle
    
    plot_traj_and_TMap(x,y,PSAbool,TMap_gauss,n_out,htraj,hmap);
    
end

end

 