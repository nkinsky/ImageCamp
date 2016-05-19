function [ ] = PF_plot_compare( session1, session2, neuron_map, varargin)
% PF_plot_compare( session1, session2, neuron_map,...)
%   Scroll through PF plots and compare between sessions.  
%
%   INPUTS
%
%   session1, session2: session data structures from MakeMouseSessionList
%
%   neuron_map: session 2 to session 1.
%
%   varargins:
%       'PFfilenames': a cell specifying alternate filenames (PlaceMaps.mat
%       default).
%
%       'pval_filter': of the form ...'pval_filter', filter_spec, thresh,...
%           - filterspec: 0 = no filter, 1 = use only cell that pass the
%           thresh in session 1, 2 = same as 1 but for session 2 cells, 3 =
%           use only cells that pass pval thresh for BOTH sessions, 4 = use
%           only cells that pval thresh for EITHER session

PF_filenames = {'PlaceMaps.mat','PlaceMaps.mat'}; % default
pval_thresh = [1 1];  % default
for j = 1:length(varargin)
    if strcmpi('PF_filenames',varargin{j})
        PF_filenames = varargin{j+1};
    end
    if strcmpi('pval_filter',varargin{j})
        filter_spec = varargin{j+1};
        pval_thresh = varargin{j+2};
    end

end

% Deal out session variables to single structure to make life easier below
session = session1;
session(2) = session2;


% Load session maps
for j = 1:2
    load(fullfile(ChangeDirectory(session(j).Animal,session(j).Date, ...
        session(j).Session,0),PF_filenames{j}),'TMap_gauss','pval');
    session(j).TMap = TMap_gauss;
    session(j).pval = pval;
end

%% Apply filter
% valid_map1 = find(neuron_map ~= 0 & ~isnan(neuron_map)); % Get validly mapped neurons
% valid_map2 = neuron_map(valid_map1);
% sesh1_filter = zeros(size(neuron_map));
% sesh2_filter = zeros(size(neuron_map));
% sesh1_filter(valid_map1) = (1 - session(1).pval(valid_map1)) < pval_filter(1);
% sesh2_filter(valid_map1) = (1 - session(2).pval(valid_map2)) < pval_filter(2);
% neurons_use = find(sesh1_filter & sesh2_filter);

neurons_use = pval_filter_bw_sesh( session(1).pval, session(2).pval, neuron_map, ...
    'filter_spec', filter_spec, 'thresh', 0.05);

%%
figure
n_out = 1;
stay_in = true;
while stay_in
    neuron1_plot = neurons_use(n_out);
    subplot(1,2,1)
    imagesc(session(1).TMap{neuron1_plot})
    title(['Session 1 Neuron ' num2str(neuron1_plot)])
    
    subplot(1,2,2)
    imagesc(session(2).TMap{neuron_map(neuron1_plot)})
    title(['Session 2 Neuron ' num2str(neuron_map(neuron1_plot))])
    
    [n_out, stay_in] = LR_cycle(n_out,[1 length(neuron_map)]);
    
end

end

