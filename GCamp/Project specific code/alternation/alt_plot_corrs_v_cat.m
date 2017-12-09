function [ ha ] = alt_plot_corrs_v_cat( MDbase, MDreg, varargin )
% ha  = alt_plot_corrs_v_cat( MDbase, MDreg,... )
%   Plots correlations between neurons in MDbase and MDreg broken down by
%   category: stem place cells (PCs), stem non-place cells (NPCs),
%   splitters, non-stem PCs, and non-stem NPCs

sesh = complete_MD(MDbase);
sesh(2) = complete_MD(MDreg);
%% Parse Inputs
ip = inputParser;
ip.addRequired('MDbase',@isstruct);
ip.addRequired('MDreg',@isstruct);
ip.addParameter('PFname', 'Placefields.mat', @ischar);
ip.addParameter('smoothing','gauss',@(a) any(strcmpi(a,{'gauss','unsmoothed'})));
ip.addParameter('pval_thresh',0.05,@(a) a > 0 & a <= 1);
ip.addParameter('ntrans_thresh',5 ,@(a) a >= 0);
ip.parse(MDbase,MDreg,varargin{:});

PFname = ip.Results.PFname;
smoothing = ip.Results.smoothing;
pval_thresh = ip.Results.pval_thresh;
ntrans_thresh = ip.Results.ntrans_thresh;

%% Step 1: register sessions
% Get map and cells the go silent or become active
[neuron_map, become_silent, become_active] = neuron_map_simple(MDbase, MDreg);
coactive_bool = ~isnan(neuron_map) & neuron_map ~= 0;

%% Step 2: load tmaps for each & register
[TMap1, TMap2] = register_tmaps(MDbase, MDreg, PFname, smoothing);

%% Step 3: get correlations for all neurons
rhos = cellfun(@(a,b) corr(a(:),b(:),'type','Spearman','rows','complete'),...
    TMap1(coactive_bool),TMap2(coactive_bool));

%% Step 4: Parse cells into splitters (1), stem PCs(2), stem NPCs (3), 
% arm PCs(4) ,and arm NPCs(5), 0 = doesn't pass ntrans threshold

ntrans_pass = cell(1,2);
categories = cell(1,2);
for j = 1:2
   load(fullfile(sesh(j).Location,'sigSplitters.mat'),'neuronID','sigcurve');
   stem_cells = false(length(sigcurve),1);
   categories{j} = zeros(length(sigcurve),1);
   stem_cells(neuronID) = true;
   [pctemp, ntrans_pass] = pf_filter(sesh(j), pval_thresh, ntrans_thresh, ...
       PFname);
   categories{j}(stem_cells & cellfun(@any,sigcurve) & ntrans_pass) = 1;
   categories{j}(stem_cells & pctemp & ~cellfun(@any,sigcurve) & ...
       ntrans_pass) = 2;
   categories{j}(stem_cells & ~pctemp & ~cellfun(@any,sigcurve) & ...
       ntrans_pass) = 3;
   categories{j}(~stem_cells & pctemp & ntrans_pass) = 4;
   categories{j}(~stem_cells & ~pctemp & ntrans_pass) = 5;
end

% Dump these into an array for all the validly mapped cells between each
% session
category_array(:,1) = categories{1}(coactive_bool);
category_array(:,2) = categories{2}(neuron_map(coactive_bool));

%% Step 5: Do breakdown plot!
cat_names = {'Splitters','Stem PCs', 'Stem NPCs', 'Arm PCs', 'Arm NPCs'};
position = [230 360 780 430];
good_cells = category_array(:,1) ~= 0;
scatterBox(rhos(good_cells), category_array(good_cells,1),'xLabels',...
    cat_names, 'yLabel', '\rho (Spearman)','position',position,...
    'transparency', 0.6);

%% Step 6: Now get proportions that stay in each category
for j= 1:5
    stay_by_cat(j) = sum(category_array(:,1) == category_array(:,2) ...
        & category_array(:,2) == j);
    stay_prop(j) = stay_by_cat(j)/sum((category_array(:,1) == j));
end

%% Step 7: Now step through and get proportions that are coactive in each category
for j = 1:5
    coactive_by_cat(j) = sum(coactive_bool & categories{1} == j);
    coactive_prop(j) = coactive_by_cat(j)/sum(categories{1} == j);
end

%%% NRK Note - to avoid creating your normal mega functions, break up
%%% anything above into functions and then create a second function to do
%%% steps 6/7

end

