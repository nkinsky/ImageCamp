function [ ] = plotXYonAVI( obj, x, y, t, MoMtime, start_time, t_plot,rot_angle,h )
%plotDVTonAVI(obj, x, y, t, MoMtime, start_time, t_plot, rot_angle, h )
%   plot DVT coordinates onto a given frame from an AVI file
%   obj = video object for AVI file
%   x,y = coordinates from PlaceMaps.mat (scaled to cm and synced to the
%   inscopix camera)
%   t = timestamps from DVT file
%   MoMtime = time that mouse appears on the maze in DVT time
%   start_time = first time step in DVT file
%   t_plot = the time you want to plot
%   rot_angle = angle (90,-90, or 180) to rotate the AVI only BEFORE any flipping

rm_scale = .15; % Assumes recording took place in 201b

FR = 20; % Frame rate of inscopix camera

% Scale XY coordinates to AVI
x = x/rm_scale*.6246;
y = y/rm_scale*.6246;

t_plot_DVT = t_plot(1) + MoMtime; % Get time to plot in DVT time

obj.CurrentTime = t_plot_DVT-start_time;

if exist('h','var')
    axes(h)
else
    axes(gca)
end

if exist('rot_angle','var')
    k = rot_angle/90;
%     [x,y] = rotate_xy(x,y,rot_angle);
else
    k = 0;
end

imagesc(flipud(rot90(readFrame(obj),k))); 
hold on; 

i_plot = zeros(size(t_plot));
for j = 1: length(t_plot)
    i_plot(j) = findclosest(t_plot(j),t);
    
    if j == 1
        plot(x(i_plot(j)),y(i_plot(j)),'b*');
    elseif j == length(t_plot)
        plot(x(i_plot(j)),y(i_plot(j)),'r*');
        
    end

end

plot(x(i_plot),y(i_plot),'b')
hold off


end

