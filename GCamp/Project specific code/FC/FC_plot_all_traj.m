function [  ] = FC_plot_all_traj( Mouse, bar_flag, speed_thresh )
%FC_plot_all_traj( Mouse,... )
%   Plots all trajectories for easy comparison for the specified Mouse.
%   Optional bar_flag set to true plots a bar graph of freezing for each
%   session pair.  bar_flag can also be followed by an optional speed
%   threshold to use for calculating freezing.

if nargin == 1
    bar_flag = false;
end

% Sessions to plot
sesh_plot = {'Control Baseline' ''     'Control 4 hrs' 'Control 1 day' 'Control 8 day';...
             'Shock Baseline' 'Shock'  'Shock 4 hrs'   'Shock 1 day'   'Shock 8 day'};
num_rows = size(sesh_plot,1);
num_cols = size(sesh_plot,2);
if bar_flag
    num_rows_plot = num_rows + 1;
end
     
%Fetch Master Directory from upper level function(s). 
global MasterDirectory;
if isempty(MasterDirectory)
    MasterDirectory = 'C:\MasterData';
    disp('No ''MasterDirectory'' global variable detected.  Using default of ''C:\MasterData'' ')
else
    load(fullfile(MasterDirectory,'MasterDirectory.mat'));
end

animals = {MD.Animal};
envs = {MD.Env};

figure
set(gcf,'Name',Mouse')
sesh_org = cell(size(sesh_plot));
for j = 1:num_rows
    for k = 1:num_cols
        if isempty(sesh_plot{j,k})
            continue
        else
            %Find MD entry that matches the input animal AND env
            i = find(strcmp(animals,Mouse) & strcmp(envs,sesh_plot{j,k}));
            sesh_org{j,k} = MD(i); % Stick into same format as sesh_plot
            
            % Change Directory, load appropriate position data, and plot
            % trajectory
            clear dirstr
            try
                dirstr = ChangeDirectory(MD(i).Animal,MD(i).Date,MD(i).Session,0);
                load(fullfile(dirstr,'Pos.mat'),'xpos_interp','ypos_interp');
                x_use = xpos_interp; y_use = ypos_interp;
                plot_flag = true;
            catch
                try
                load(fullfile(dirstr,'Pos_temp.mat'),'Xpix','Ypix')
                x_use = Xpix; y_use = Ypix;
                disp(['Could not locate Pos.mat for ' MD(i).Env ' session. Using Pos_temp.mat'])
                plot_flag = true;
                catch
                    disp(['Could not locate anything for ' MD(i).Env ' session. Skipping'])
                    plot_flag = false;
                end
            end
            
            if plot_flag
                h = subplot(num_rows_plot, num_cols,num_cols*(j-1)+k);
                plot_traj(x_use,y_use,h);
                title(MD(i).Env)
            end
            
        end
    end
end

%% Bar graph of freezing in each environment at bottom
if bar_flag == true
    for k = [1 3 4 5]
        h = subplot(num_rows_plot, num_cols,num_cols*(num_rows_plot-1)+k);
        FC_plot_freezing( sesh_org{1,k}, sesh_org{2,k}, speed_thresh, h)
        %%% pick up here
    end
    
end

end

