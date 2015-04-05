function [ pix_x pix_y x_matrix y_matrix ] = pixel_time_spike_bin( posx, posy, npix_x, npix_y, frame_rate, plot_flag )
%pixel_time_spike_bin Take raw position, time, and spike data and bin it
%spatially.
%   posx and posy are positions at each time stamp
%   npix_x and npix_y are the desired number of pixels in each direction
%   frame rate is in frames/sec
%   plot_flag = 1 plots out an occupancy heat map (not finished yet)
%             = 0 supresses plotting

% Put the total number of spikes into the appropriate time bin
% vector form is: [xpos ypos time spike_binary] - [14.86 2.45 3342.8 1]
% Equation: xi = xmin + (pix_x - 1)*step_x;

xmin = min(posx); xmax = max(posx);
ymin = min(posy); ymax = max(posy);

% Make sure this is an appropriate size - check versus literature
step_x = (xmax - xmin)/npix_x;
step_y = (ymax - ymin)/npix_y;


% Get appropriate index for every time point, regardless if a spike occurred or not
pix_x = round((posx - xmin)/step_x) + 1;
pix_y = npix_y - round((posy - ymin)/step_y); %round((PositionData.Y - ymin)/step_y) + 1;

% Assign the correct location to each pixel
middle = [ mean([xmin xmax]) mean([ymin ymax]) ]; % Get middle first

x_by_pix = xmin + [0:npix_x-1]*step_x;
y_by_pix = ymin + [npix_y-1:-1:0]*step_y;

x_matrix = repmat(x_by_pix,npix_y,1);
y_matrix = repmat(y_by_pix',1,npix_x);

% Get limits of field of view for plotting
% Note that this is for a circle only and would need to be adjusted to be
% more general...
rmax = max((ymax-ymin)/2,(xmax-xmin)/2);
[FOV_i FOV_j] = find(sqrt((x_matrix-middle(1)).^2 + (y_matrix-middle(2)).^2) > rmax); 
S_nan = sparse(FOV_i, FOV_j,NaN*ones(size(FOV_i)),npix_y,npix_x); % Add this to any matrix to insert NaN outside of the arena!

for m = 1:npix_x
	for n = 1:npix_y % n = npix_y:-1:1 % Need to go in reverse order here to get it to work properly

		% Get time spent in each pixel
		time_matrix(n,m) = sum((pix_x == m) & (pix_y == n))/frame_rate;
	end
end

%% Plot Heat map
if plot_flag == 1
    figure
    surface(x_matrix,y_matrix,time_matrix+full(S_nan))
    xlim([xmin xmax]); ylim([ymin ymax]);
    colorbar
    xlabel('Location'); ylabel('Location')
    title('Occupancy Heat Map');
end

end

