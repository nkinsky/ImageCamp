function [ ] = scroll_PF(MD,varargin)
% scroll_PF(MD, varargin) 
%
% Allows one to scroll through all the place fields in a session with stats
% on nHits and nTrans and pval displayed

%% Parse Inputs
ip = inputParser;
ip.addRequired('MD',@isstruct);
ip.addParameter('name_append','',@ischar); % Primary PF row to display
ip.addParameter('name_append2','',@ischar); % Second PF row to display (optional)

ip.parse(MD,varargin{:});
name_append = ip.Results.name_append;
name_append2 = ip.Results.name_append2;

%% Setup variables and subplots

[dirstr, ~] = ChangeDirectory(MD.Animal,MD.Date,MD.Session,0);
load(fullfile(dirstr,['Placefields' name_append]),'TMap_gauss','pval','PSAbool','x','y');
load(fullfile(dirstr,['PlacefieldStats' name_append]),'PFnHits');
NumTransients = get_num_trans(PSAbool);

figure
h1(1) = subplot(1,3,1);
h1(2) = subplot(1,3,2);
h1(3) = subplot(1,3,3);
plot2 = false;
if ~isempty(name_append2)
    plot2 = true;
    h1(1) = subplot(2,3,1);
    h1(2) = subplot(2,3,2);
    h1(3) = subplot(2,3,3);
    h2(1) = subplot(2,3,4);
    h2(2) = subplot(2,3,5);
    h2(3) = subplot(2,3,6);
    temp = load(fullfile(dirstr,['Placefields' name_append2]),'TMap_gauss','pval','PSAbool','x','y');
    temp2 = load(fullfile(dirstr,['PlacefieldStats' name_append2]),'PFnHits');
    NumTransients2 = get_num_trans(temp.PSAbool);
end
%%
n_out = 1;
stay_in = true;
n_range = [1 length(TMap_gauss)];
while stay_in
    subplot(h1(1))
    plot_traj(x,y,PSAbool(n_out,:));
    title([mouse_name_title(MD.Animal) ' - ' mouse_name_title(MD.Date) ' - session ' num2str(MD.Session)])
    
    subplot(h1(2))
    plot_PF(TMap_gauss{n_out});
    title(['Neuron # ' num2str(n_out)])
    
    subplot(h1(3))
    plot_stats(pval(n_out), max(PFnHits(n_out,:)), NumTransients(n_out), false)
    
    if plot2
        subplot(h2(1))
        plot_traj(temp.x,temp.y,temp.PSAbool(n_out,:));
        
        subplot(h2(2))
        plot_PF(temp.TMap_gauss{n_out});
        
        subplot(h2(3))
        plot_stats(temp.pval(n_out), max(temp2.PFnHits(n_out,:)), NumTransients2(n_out), plot2)
    end
    [n_out, stay_in] = LR_cycle(n_out, n_range);
end

clear t1 t2 t3 t4 t5 t6
end

%% Plot trajectory
function [] = plot_traj(x,y,PSAuse)
plot(y,x,'-',y(PSAuse),x(PSAuse),'r*');
set(gca,'YDir','reverse');
axis tight
axis off
end

%% Plot heatmap
function [] = plot_PF(TMap_use)
imagesc_nan(TMap_use);
axis off

end

%% Plot stats
function [] = plot_stats( pval_use, PFnHits_use, ntrans_use, plot2)
persistent t1 t2 t3 t4 t5 t6
if isempty(t1) && ~plot2
    t1 = text(0.1,0.9,'');
    t2 = text(0.1,0.7,'');
    t3 = text(0.1,0.5,'');
elseif isempty(t4) && plot2
    t4 = text(0.1,0.9,'');
    t5 = text(0.1,0.7,'');
    t6 = text(0.1,0.5,'');
end
if ~plot2
    t1.String = ['p = ' num2str(pval_use)];
    t2.String = ['PFnHits = ' num2str(PFnHits_use)];
    t3.String = ['ntrans = ' num2str(ntrans_use)];
elseif plot2
    t4.String = ['p = ' num2str(pval_use)];
    t5.String = ['PFnHits = ' num2str(PFnHits_use)];
    t6.String = ['ntrans = ' num2str(ntrans_use)];
end
axis off
end
%% Legacy function for T2 and prior
% % scroll_PF(TMap,...)
% %  Scrolls through PFs using L/R buttons.  Input TMap cell, optional
% %  name-argument pairs are:
% %   'OccMap': makes all non-occupied regions white
% %   'h': handle to figure handle you wish to use, default = gcf
% %   'cmap': colormap to use, default = 'jet', e.g. cmap = colormap('jet')
% %   'perform_smooth': 1 = perform smoothing of OccMap, 0 = do not
% %   smooth OccMap (may need to do if you have large bin sizes).  Default =
% %   1.
% %
% % Currently obsolete for T4/Placefields function TMaps.
% 
% %% Parse varargins
% OccMap = ones(size(TMap{1})); % default
% h_use = gcf; % default
% cmap = colormap('jet'); % default
% perform_smooth = 1; % default
% for j = 1:length(varargin)
%     if strcmpi(varargin{j},'OccMap')
%         OccMap = varargin{j+1};
%     end
%     if strcmpi(varargin{j},'h')
%         h_use = varargin{j+1};
%     end
%     if strcmpi(varargin{j},'cmap')
%        cmap = varargin{j+1};
%     end
%     if strcmpi('perform_smooth',varargin{j})
%         perform_smooth = varargin{j+1};
%     end
% end
% 
% %% Scroll through
% NumNeurons = length(TMap);
% figure(h_use); % Grab figure
% n_out = 1;
% stay_in = true;
% while stay_in
%     [~, temp] = make_nan_TMap(OccMap,TMap{n_out},'perform_smooth',...
%         perform_smooth);
%     imagesc_nan(temp, cmap, [1 1 1]);
%     title(['Heat Map for neuron ' num2str(n_out)])
%     
%     [n_out, stay_in] = LR_cycle(n_out,[1 NumNeurons]);
% end
% 
% %% Take 2
% 
% Num_Neurons = size(batch_map,1);
% n = 1;
% stay_in = true;
% while stay_in
%     for j = 1:num_sessions
%         neuron_use = batch_map(n, j+1);
%         subplot(4,2,j)
%         if ~isnan(j+1)
%             imagesc_nan(sesh(j).TMap{neuron_use});
%             title(['Neuron ' num2str(neuron_use) ' Session ' num2str(j)]
%         else
%             % Need to plot something here if neuron reg is sketchy!!!
%         end
%     end
%     [n, stay_in] = LR_cycle(n,[1 NumNeurons]);
% end
% 
% end
% 
