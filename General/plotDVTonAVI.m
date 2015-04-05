function [ ] = plotDVTonAVI( obj, x, y, t, t_plot, rot_angle, h )
%plotDVTonAVI( obj, x, y, t, t_plot )
%   plot DVT coordinates onto a given frame from an AVI file.  if
%   length(t_plot) is greater than 1, then all the points indicated in the
%   DVT file are plotted on top of the first frame from the AVI file, with 
%   the start a blue star and the end a red star.
%   obj = video object for AVI file
%   x,y = coordinates from DVT file
%   t = timestamps from DVT file
%   t_plot = the time you want to plot
%   rot_angle = the angle to rotate the AVI BEFORE flipping
%   h = handle to axes you want to plot to, if omitted plots to current
%   axes

% Scale DVT coordinates to AVI
x = 0.6246*x;
y = 0.6246*y;

start_time = t(1); % Get start time of DVT file (time = 0 in AVI)

obj.CurrentTime = t_plot(1)-start_time;

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

