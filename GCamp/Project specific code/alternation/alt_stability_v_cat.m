function [ ha ] = alt_stability_v_cat( MDbase, MDreg, varargin )
% ha = alt_stability_v_cat( MDbase, MDreg, varargin )
%   Plots two cell stability metrics: coactivity probability, and probability of
%   staying in the same category vs category for alternation task (stem 
%   place cells (PCs), stem non-place cells (NPCs), splitters, non-stem PCs, 
%   and non-stem NPCs

sesh = complete_MD(MDbase);
sesh(2) = complete_MD(MDreg);
%% Parse Inputs
ip = inputParser;
ip.addRequired('MDbase',@isstruct);
ip.addRequired('MDreg',@isstruct);
ip.addParameter('PFname', 'Placefields.mat', @ischar);
ip.addParameter('pval_thresh',0.05,@(a) a > 0 & a <= 1);
ip.addParameter('ntrans_thresh',5 ,@(a) a >= 0);
ip.addParameter('coactive_only', false, @islogical);
ip.addParameter('ha', [], @ishandle);
ip.parse(MDbase,MDreg,varargin{:});

PFname = ip.Results.PFname;
pval_thresh = ip.Results.pval_thresh;
ntrans_thresh = ip.Results.ntrans_thresh;
coactive_only = ip.Results.coactive_only;
ha = ip.Results.ha;

%% Step 1: register sessions
% Get map and cells the go silent or become active
neuron_map = neuron_map_simple(MDbase, MDreg,'suppress_output', true);

%% Step 2: Parse cells into splitters (1), stem PCs(2), stem NPCs (3), 
% arm PCs(4) ,and arm NPCs(5), 0 = doesn't pass ntrans threshold

categories = arrayfun(@(a) alt_parse_cell_category(a, pval_thresh, ...
    ntrans_thresh, PFname), sesh, 'UniformOutput', false);

%% Step 3: Get category stability metrics

[ stay_prop, coactive_prop] = get_cat_stability(categories, neuron_map, 0:5);
%% Step 5: Plot it
if isempty(ha)
    figure; ha = gca; set(gcf,'Position',[270 230 960 550])
end
stay_prop = circshift(stay_prop,-1); % Shift so discarded cells are at the right
coactive_prop = circshift(coactive_prop,-1);
xlabels = {'Splitters', 'Stem PCs', 'Stem NPCs', 'Arm PCs', 'Arm NPCs', ...
    [ 'ntrans < ' num2str(ntrans_thresh)]};
if ~coactive_only
     [ha, h1, h2] = plotyy(ha, 1:6, stay_prop, 1:6, coactive_prop);
     h1.Marker = 'o'; h2.Marker = 'o';
else
    
end

ha(1).YLabel.String = 'Probabilty Same Category';
ha(2).YLabel.String = 'Probability Coactive';

title([mouse_name_title(MDbase.Animal) ': ' num2str(get_time_bw_sessions(...
    MDbase, MDreg)) ' day lag'])
xlabel([mouse_name_title(MDbase.Date) 's' num2str(MDbase.Session) ' to ' ...
    mouse_name_title(MDreg.Date) 's' num2str(MDreg.Session)])

for j = 1:2
    xlim(ha(j), [0.5 6.5])
    ha(j).XTick = 1:6; ha(j).XTickLabels = xlabels;
    make_plot_pretty(ha(j));
end



end

