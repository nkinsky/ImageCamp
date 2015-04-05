function [ ] = fig_to_subplot( fig_handle, s_handle, fig_path )
%fig_to_subplot( fig_handle, s_handle, fig_path )
%   Copy a saved figure into a subplot

h11 = openfig(fig_path,'reuse'); % open figure
ax1 = gca; % get handle to axes of figure
% test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots
h_test = figure(fig_handle); %create new figure
s_test = subplot(2,2,s_handle); %create and get handle to the subplot axes
fig1 = get(ax1,'children'); %get handle to all the children in the figure
copyobj(fig1,s_handle); %copy children to new parent axes i.e. the subplot axes

% keyboard

end

