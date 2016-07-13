function [colors, active_fields_use ] = draw_PF_outline( session_struct, varargin )
% [colors, active_fields ] = draw_PF_outline( session_struct, varargin )
%   Detailed explanation goes here

%% Process varargins and other inputs
PMfile = 'PlaceMapsv2.mat';
PMstatsfile = 'PFstatsv2.mat';
custom_colors = []; % default
% ds_factor = 1; % Factor by which to downsample cells
neurons_use = []; % Custom fields to use for plotting
for j = 1:length(varargin)
    if strcmpi(varargin{j},'ax_handle')
        ax_handle = varargin{j+1};
    end
    if strcmpi(varargin{j},'PMfile')
        PMfile = varargin{j+1};
    end
    if strcmpi(varargin{j},'PMstatsfile')
        PMstatsfile = varargin{j+1};
    end
    if strcmpi(varargin{j},'custom_colors')
       custom_colors = varargin{j+1};
    end
%     if strcmpi(varargin{j},'ds_factor')
%        ds_factor = varargin{j+1};
%     end
    if strcmpi(varargin{j},'neurons_use')
       neurons_use = varargin{j+1};
    end
end

% create new figure if axis handle isn't specified
if ~exist('ax_handle','var')
    figure;
    ax_handle = axes;
end

dir_use = ChangeDirectory_NK(session_struct,0);
load(fullfile(dir_use,PMfile),'TMap_gauss','Pix2Cm','Xedges','Yedges','x','y');
load(fullfile(dir_use,PMstatsfile),'PFnumepochs','PFpixels','MaxPF')

NumNeurons = length(TMap_gauss);
if isempty(neurons_use)
    active_fields_use = find(sum(PFnumepochs,2) ~= 0); % Get neurons with active fields
%     active_fields_use = sort(active_fields(randperm(round(length(active_fields)/ds_factor))));
else
    active_fields_use = neurons_use;
end

% keyboard

% assign each neuron a color
if isempty(custom_colors)
    colors = rand(NumNeurons,3);
elseif ~isempty(custom_colors)
    colors = custom_colors;
    
    % If only one color value is entered, extend it to match the number of
    % neurons
    if size(custom_colors,1) == 1
        colors = repmat(custom_colors, NumNeurons,1);
    end
end

% keyboard

%% 

xAVI = x/Pix2Cm*0.625;
yAVI = y/Pix2Cm*0.625;

% convert Xbin and Ybin to x and y
Xd = Xedges(2)-Xedges(1);
Yd = Yedges(2)-Yedges(1);

for i = 1:length(Xedges)
    Xb2AVI(i) = (Xedges(i)+Xd/2)/Pix2Cm*0.625;
end

xlims = (Xedges([1, end])+ Xd/2)/Pix2Cm*0.625;
ylims = (Yedges([1, end])+ Yd/2)/Pix2Cm*0.625;

for i = 1:length(Yedges)
    Yb2AVI(i) = (Yedges(i)+Yd/2)/Pix2Cm*0.625;
end

%% Plot 
% for each active neuron
axes(ax_handle)
hold on

for j = active_fields_use'
    % get PF outline (if avail)
    WhichField = MaxPF(j);
    temp = zeros(size(TMap_gauss{1}));
    tp = PFpixels{j,WhichField};
    try
        temp(tp) = 1;
    catch
        keyboard;
    end
    % plot PF outline (using correct color)
%     temp = resize(temp, 4*size(temp));
    b = bwboundaries(temp,4,'noholes');
    if (~isempty(b))
        
        
        yt = Yb2AVI(b{1}(:,2));
        xt = Xb2AVI(b{1}(:,1));
        xt= xt+(rand(size(xt))-0.5)/2;
        yt= yt+(rand(size(yt))-0.5)/2;
        plot(xt,yt,'Color',colors(j,:),'LineWidth',2);
        
%         
%         yt = b{1}(:,2);
%         xt = b{1}(:,1);
%         xt= xt+(rand(size(xt))-0.5)/4;
%         yt= yt+(rand(size(yt))-0.5)/4;
%         %colors(j,:)
%         plot(xt,yt,'Color',colors(j,:),'LineWidth',2);
        
        
    end
end

hold off

xlim(xlims)
ylim(ylims)

view([90 90])

end

