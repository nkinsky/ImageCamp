function [cell_classes, RDIkit, corr_vec, h_plot ] = twoenv_corrvRDI( Mouse_var, sesh1ind, ...
    sesh2ind, comp_type, h_plot )
%  [ cell_classes, RDIkit, corr_vec ] = twoenv_corrvRDI( Mouse_var, sesh1ind,...
%       sesh2ind, comp_type )
%   Plot RDI (metric of event rate differences *rate-remapping* versus
%   place field correlation between sessions. if 'circ2square' is
%   specified, sesh1ind mush correspond to square.  Outputs are cell
%   classifications and RDI per twoenv_cell_classify and correlations
%   matched up

if nargin < 5
    h_plot = nan;
end

if h_plot == true
    figure; 
    set(gcf,'Position', [2260 270 850 635]); 
    h_plot = gca;
end
plot_flag = ishandle(h_plot);

%% Get full session info
[~, sesh{1}] = ChangeDirectory_NK(Mouse_var.sesh.(comp_type)(sesh1ind),0);
[~, sesh{2}] = ChangeDirectory_NK(Mouse_var.sesh.(comp_type)(sesh2ind),0);
base_dir = ChangeDirectory_NK(Mouse_var.sesh.(comp_type)(1),0);

%% Load batch_session_map
if strcmpi(comp_type,'circ2square')
    load(fullfile(base_dir,'batch_session_map_trans.mat'));
elseif strcmpi(comp_type,'circle') || strcmpi(comp_type,'square')
    load(fullfile(base_dir,'batch_session_map.mat'))
end

%% Get RDI
square_sesh = [1 2 7 8 9 12 13 14];
circle_sesh = [3 4 5 6 10 11 15 16];
if strcmpi(comp_type,'circ2square')
[cell_classes, RDIkit] = twoenv_cell_classify(Mouse_var.PV.(comp_type)(...
    square_sesh(sesh1ind),:,:,:),...
    Mouse_var.PV.(comp_type)(circle_sesh(sesh2ind),:,:,:));
elseif strcmpi(comp_type,'circle') || strcmpi(comp_type,'square')
    [cell_classes, RDIkit] = twoenv_cell_classify(Mouse_var.PV.(comp_type)(sesh1ind,:,:,:),...
    Mouse_var.PV.(comp_type)(sesh2ind,:,:,:));
end

%% Get correlations
corr_mat = twoenv_squeeze(Mouse_var.corr_mat.(comp_type));
corr_use = corr_mat{sesh1ind, sesh2ind};
num_neurons = length(corr_use);

%% Send correlations to population level indices
if strcmpi(comp_type,'circ2square')
    map_use = get_neuronmap_from_batchmap(batch_session_map,0,...
        square_sesh(sesh1ind));
    
    % Bugfix here to correct for circle sessions coming first in
    % circ2square comparisons...
    if max(map_use) > num_neurons
        map_use = get_neuronmap_from_batchmap(batch_session_map,0,...
        circle_sesh(sesh2ind));
    end
elseif strcmpi(comp_type,'circle') || strcmpi(comp_type,'square')
    map_use = get_neuronmap_from_batchmap(batch_session_map,0,sesh1ind);
end
valid_cells = ~isnan(map_use) & (map_use ~= 0);
corr_vec = nan(size(RDIkit));
corr_vec(valid_cells) = corr_use(map_use(valid_cells)); %wtf??? error here when I run it with Mouse(3),4,4,true parameters

%% Plot it
if plot_flag
    colors_use = [1 0 0 ; 0 1 0; 0 0 1; 0.5 0.5 0.5];
    if strcmpi(comp_type,'circ2square')
        sesh_str = {'sq', 'cir'};
    elseif strcmpi(comp_type,'square') 
        [sesh_str{1:2}] = deal('sq');
    elseif strcmpi(comp_type,'circle')
        [sesh_str{1:2}] = deal('cir');
    end
        
    axes(h_plot);
    for j = 1:4
        cells_plot = cell_classes == j;
        h = plot(RDIkit(cells_plot) , corr_vec(cells_plot), 'o');
        try; h.MarkerEdgeColor = colors_use(j,:); end %#ok<TRYNC,NOSEM>
        hold on
    end
    ylabel('Correlation'); xlabel('RDIkit')
    title([sesh{1}.Animal([1 9:10]) ': ' sesh_str{1} ' ' ...
        num2str(sesh1ind) ' vs ' sesh_str{2} ' ' ...
        num2str(sesh2ind)])
    legend({'Session 1 Cell', 'Session 2 Cell', 'Both', 'Neither'},...
        'Location','southeast')
    xlim([-1 1]); ylim([-1 1]); 
    hold off
end

end

