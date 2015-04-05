% Occupancy Normalized Fluroescence...


clear all
close all

tic
%% Load Position Data
posdata = importdata('C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_17\G1704252014002.DVT');
time = posdata(:,2);
time = time - min(time);

fps_track = 30; % sampling rate for tracking

Xsmooth = NP_QuickFilt(posdata(:,3),0.000001,1,fps_track);
Ysmooth = NP_QuickFilt(posdata(:,4),0.000001,1,fps_track);

%% Get Fluorescence Data Files
fps_image = 20;

matched_files = match_file_string_f('trace'); % Get files with "trace" in their name
num_files = size(matched_files,2);

%% Downsample Tracking Data
x_ds = resample(Xsmooth,fps_image,fps_track);

%% Figure out number of subplots and/or figures for plotting
plots_per_fig_x = 4;
plots_per_fig_y = 4;
plots_per_fig = plots_per_fig_x*plots_per_fig_y;
num_figs = ceil(num_files/plots_per_fig);
remainder = num_files - (num_figs -1)*plots_per_fig;
count = 1;
for k = 1:num_figs
   figure(k)
   if k < num_figs
       for m = 1:plots_per_fig
           h(count) = subplot(plots_per_fig_y,plots_per_fig_x,m);
           count = count + 1;
       end
   elseif k == num_figs
       for m = 1:remainder
          h(count) = subplot(plots_per_fig_y,plots_per_fig_x,m);
          count = count + 1;
       end
   end

end
    
for j = 1:num_files
    
    tic
    
    load(matched_files{j});
    
    f = Object.Data;
    time_image = Object.XVector;
       
    %% Do Linear Interpolation
    
    % Get appropriate time points to interpolate for each timestamp
    time_index = arrayfun(@(a) [find(a >= time,1,'last') find(a < time,1,'first')],...
        time_image,'UniformOutput',0);
    time_image_cell = arrayfun(@(a) a,time_image,'UniformOutput',0);
    
    xpos_interp = cellfun(@(a,b) lin_interp(time(a), Xsmooth(a),...
        b),time_index,time_image_cell);
    
    ypos_interp = cellfun(@(a,b) lin_interp(time(a), Ysmooth(a),...
        b),time_index,time_image_cell);
    
    %% Put the total number of spikes into the appropriate time bin
    % vector form is: [xpos ypos time spike_binary] - [14.86 2.45 3342.8 1]
    % Equation: xi = xmin + (pix_x - 1)*step_x;
    
    npix_x = 20;
    npix_y = 20;
    
    xmin = min(xpos_interp); xmax = max(xpos_interp);
    ymin = min(ypos_interp); ymax = max(ypos_interp);
    
    % Make sure this is an appropriate size - check versus literature
    step_x = (xmax - xmin)/npix_x;
    step_y = (ymax - ymin)/npix_y;
    
    
    % Get appropriate index for every time point, regardless if a spike occurred or not
    pix_x = round((xpos_interp - xmin)/step_x) + 1;
    pix_y = npix_y - round((ypos_interp - ymin)/step_y); %round((Ysmooth - ymin)/step_y) + 1;
    
    % Assign the correct location to each pixel
    middle = [ mean([xmin xmax]) mean([ymin ymax]) ]; % Get middle first
    
    x_by_pix = xmin + [0:npix_x-1]*step_x;
    y_by_pix = ymin + [npix_y-1:-1:0]*step_y;
    
    x_matrix = repmat(x_by_pix,npix_y,1);
    y_matrix = repmat(y_by_pix',1,npix_x);
    
    % Get limits of field of view for plotting
    rmax = max((ymax-ymin)/2,(xmax-xmin)/2);
    [FOV_i FOV_j] = find(sqrt((x_matrix-middle(1)).^2 + (y_matrix-middle(2)).^2) > rmax);
    S_nan = sparse(FOV_i, FOV_j,NaN*ones(size(FOV_i)),npix_y,npix_x); % Add this to any matrix to insert NaN outside of the arena!
    
    %% Get number of spikes and total time spent in each time bin
    for m = 1:npix_x
        for n = 1:npix_y % n = npix_y:-1:1 % Need to go in reverse order here to get it to work properly
            
            % Get time spent in each pixel
            time_matrix(n,m) = sum((pix_x == m) & (pix_y == n));
            
            % Get number of spikes in each pixel
            sum_f = sum(f((pix_x == m) & (pix_y == n)));
            f_matrix(n,m) = sum_f;
            
        end
    end
    
    
    occ_norm_FR= f_matrix./time_matrix;
    
    FR_vec = []; % Make into a vector
    for k = 1:npix_x
        FR_vec = [FR_vec occ_norm_FR(k,:)];
    end
    FR_vec = FR_vec(FR_vec ~= 0 & ~isnan(FR_vec)); % remove zero and NaN values
    
    
    %% Plot Heat maps
    by_pix = 0;
    
    % Attempt to remove bug from MATLAB that prevents printing out the
    % all but the last figure for some reason...
    if j == 1
        figure(1)
    elseif round((j-1)/plots_per_fig) == (j-1)/plots_per_fig
        figure(round((j-1)/plots_per_fig) + 1)
    end
    
    if by_pix == 1
        surface(occ_norm_FR)
    else
        %     surface(x_by_pix,y_by_pix,occ_norm_FR{j})
        subplot(h(j))
        surface(x_matrix,y_matrix,occ_norm_FR)
        xlim([xmin xmax]); ylim([ymin ymax]);
        colorbar
        xlabel('Location'); ylabel('Location')
    end
    

%     if round(j/plots_per_fig) == j/plots_per_fig
%         drawnow
%     end
    
   disp(['File '  matched_files{j}(max(regexp(matched_files{j},'\')) + 1:end) ...
       ' processed in ' num2str(toc,'%0.2f') ' seconds'])
end

