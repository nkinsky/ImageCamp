function [ hrect, pos ] = draw_center_bounds( xBin, yBin, Alt, ha)
% hrect = draw_center_bounds( xBin, yBin, Alt, ha)
%   Draws a rectangle around the center section in the alternation maze
%   onto axes ha.

if nargin < 4
    ha = gca;
end

pos = get_center_bounds( xBin, yBin, Alt );

axes(ha);
hold on
hrect = rectangle('Position', pos , 'EdgeColor', 'r', 'LineStyle', '--',...
    'LineWidth', 2, 'Curvature', 0.2);
hold off

end

