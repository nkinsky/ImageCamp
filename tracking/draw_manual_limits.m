function [ x_manual, y_manual, ind_keep ] = draw_manual_limits( x,y, env_label )
%[ x_manual, y_manual ] = draw_manual_limits( x,y )
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


% Plot x and y
figure(1234)
plot(x,y)

% Draw rectangle
ok = 'n';

while strcmpi(ok,'n')
    title('Draw rectangle around points you wish to consider for arena alignment!')
    xlabel(env_label)
    disp('Draw rectangle around points you wish to consider for arena alignment!')
    rect = getrect(1234); %[xmin ymin width height]
    figure(1234)
    hold on
    rectangle('Position',rect,'EdgeColor',[1 0 0],'LineStyle','-.')
    hold off
    ok = input('Is this ok? (y/n): ','s');
end

% Calculate bounds
xmin = rect(1); xmax = rect(1) + rect(3);
ymin = rect(2); ymax = rect(2) + rect(4);

% Get ind_keep
ind_keep = (x > xmin & x < xmax) & (y > ymin & y < ymax);

% Grab x_manual and y_manual
x_manual = x(ind_keep);
y_manual = y(ind_keep);

close(1234)



end

