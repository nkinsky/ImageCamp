function [ cumdist] = plot_mobility( t, x, y, h)
% cumdist = plot_mobility( t,x,y )
%   Plots total distance moved as a function of time. Output is cumulative
%   distance moved at each time point
if nargin < 4
    figure;
    h = gca;
end

x_diff = diff(x); 
y_diff = diff(y); 
dist_trav = sqrt(x_diff.^2 + y_diff.^2);
dist_trav = [0 dist_trav];
plot(t, cumsum(dist_trav))
xlabel('Time (s)')
ylabel('Cumulative Distance Traveled (cm)')
end

