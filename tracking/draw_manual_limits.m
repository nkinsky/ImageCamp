function [ x_manual, y_manual, ind_keep, xlims, ylims ] = ...
    draw_manual_limits(x ,y, env_label, ha, prompt )
%[ x_manual, y_manual, ind_keep, xlims, ylims ] = ...
%   draw_manual_limits( x,y, env_label, hfig, prompt )
%   Plots x and y and has you draw a rectangle over them defining which
%   points to keep and which to discard
%
%   INPUTS
%   x,y: input position data
%
%   env_label: something to ID the environment with (e.g 'alternation
%   track')
%
%   OUTPUTS
%   x_manual,y_manual: output data that only includes points from x and y
%   that are within the rectangle you drew.
%
%   ind_keep: index to the points in x and y that correspond to x_manual,
%   y_manual
%
%   xlims,ylims: limits of rectangle you drew.


% Plot x and y
if nargin < 5
    prompt = 'Draw rectangle around points you wish to consider for arena alignment!';
    if nargin < 4
        figure(1234); ha = gca;
    end
end
plot(x,y,'b-')

% Draw rectangle
ok = 'n';

while strcmpi(ok,'n')
    title(prompt)
    xlabel(env_label)
    disp(prompt)
    rect = getrect(ha); %[xmin ymin width height]
    axes(ha)
    hold on
    rectangle('Position',rect,'EdgeColor',[1 0 0],'LineStyle','-.')
    hold off
    ok = input('Is this ok? (y/n): ','s');
end

% Calculate bounds
xmin = rect(1); xmax = rect(1) + rect(3);
ymin = rect(2); ymax = rect(2) + rect(4);
xlims = [xmin, xmax];
ylims = [ymin, ymax];

% Get ind_keep
ind_keep = (x > xmin & x < xmax) & (y > ymin & y < ymax);

% Grab x_manual and y_manual
x_manual = x(ind_keep);
y_manual = y(ind_keep);

close(ha.Parent)



end

