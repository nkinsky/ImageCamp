function [ ] = scroll_PF(TMap,varargin )
% scroll_PF(TMap,...)
%  Scrolls through PFs using L/R buttons.  Input TMap cell, optional
%  name-argument pairs are:
%   'OccMap': makes all non-occupied regions white
%   'h': handle to figure handle you wish to use, default = gcf
%   'cmap': colormap to use, default = 'jet', e.g. cmap = colormap('jet')
%   'perform_smooth': 1 = perform smoothing of OccMap, 0 = do not
%   smooth OccMap (may need to do if you have large bin sizes).  Default =
%   1.

%% Parse varargins
OccMap = ones(size(TMap{1})); % default
h_use = gcf; % default
cmap = colormap('jet'); % default
perform_smooth = 1; % default
for j = 1:length(varargin)
    if strcmpi(varargin{j},'OccMap')
        OccMap = varargin{j+1};
    end
    if strcmpi(varargin{j},'h')
        h_use = varargin{j+1};
    end
    if strcmpi(varargin{j},'cmap')
       cmap = varargin{j+1};
    end
    if strcmpi('perform_smooth',varargin{j})
        perform_smooth = varargin{j+1};
    end
end

%% Scroll through
NumNeurons = length(TMap);
figure(h_use); % Grab figure
n_out = 1;
stay_in = true;
while stay_in
    [~, temp] = make_nan_TMap(OccMap,TMap{n_out},'perform_smooth',...
        perform_smooth);
    imagesc_nan(temp, cmap, [1 1 1]);
    title(['Heat Map for neuron ' num2str(n_out)])
    
    [n_out, stay_in] = LR_cycle(n_out,[1 NumNeurons]);
end

end

