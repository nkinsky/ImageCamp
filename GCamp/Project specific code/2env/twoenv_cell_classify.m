function [ cell_classes, RDIkit, h_plot ] = twoenv_cell_classify(PV1, PV2, ...
    h_plot)
% [ cell_classes, RDIkit , h_plot] = twoenv_cell_classify( PV1, PV2, h_plot )
%   Classifies cells as context 1 specific, context 2 specific, neither, or
%   both, based on Kitamura et al, 2016 (Neuron).  Also spits out the rate
%   discrimination index per Kitamura et al., 2016, adjusted to use (sum
%   PSA)/SR instead of # Ca events - should be ok because the two are
%   highly correlated.  Can plot either by supplying a handle for h_plot or
%   true.

if nargin < 3
    h_plot = nan;
end

if h_plot == true
    figure; h_plot = gca;
end
plot_flag = ishandle(h_plot);

PV1 = squeeze(PV1); PV2 = squeeze(PV2);

%% Step 0 - Specify cutoffs
active_thresh = 0.1; % Very rough cutoff that is equivalent to approximately 10 events in a 10 minute sessions
discr_thresh = 0.6; % To match Kitamura et al, 2016.  Need to justify by doing their analysis (setting at the 0.99 cutoff for same environment RDI).
%% Step 1 - Get inactive cells

% Get aggregate activity across whole environment for each cell
PV1a = squeeze(sum(sum(PV1,1),2)); % Sum up all activity in PV1 for each cell 
PV2a = squeeze(sum(sum(PV2,1),2));

% Identify candidate pool of cells that actually have at least one calcium
% event in either session.
active_pool = (PV1a > 0) | (PV2a > 0);

% Identify active cells (those in active pool above active_thresh)
active1 = PV1a >= active_thresh; 
active2 = PV2a >= active_thresh;
active_either = active1 | active2;

%% Step 2 - Calculate RDIkit for each cell
RDIkit = (PV1a - PV2a)./(PV1a + PV2a);

%% Step 3 - Classify cells: 1 = context 1 cell, 2 = context 2 cell, 3 = both, 
% 4 = neither, % 5 = no events in either session

cell_classes = nan(size(PV1a));
cell_classes(RDIkit > discr_thresh & active_either) = 1;
cell_classes(RDIkit < -discr_thresh & active_either) = 2;
cell_classes(abs(RDIkit) <= discr_thresh & active_either) = 3;
cell_classes(~active_either & active_pool) = 4;
cell_classes(~active_pool) = 5;

%% Step 4: Plot if specified
if plot_flag
    
    % Aggregate cell classifications
    class_breakdown = arrayfun(@(a) sum(a == cell_classes), 1:5);
    
    % plot
    axes(h_plot)
    bar(class_breakdown(1:4)/sum(class_breakdown(1:4)));
    set(gca,'XTickLabel',{'Ctx 1 cell', 'Ctx 2 cell', 'Both', 'Neither'})
    xlabel('Cell type')
    ylabel('Proportion')
end


end

