function [deltacurve_corr, PFcorr, deltacurve_corr_shuf, PFcorr_shuf, ...
    sigsplit_ind] = split_tuning_corr(session1, session2, varargin)
% [deltacurve_corr, PFcorr, deltacurve_corr_shuf, PFcorr_shuf, ...
%     sigsplit_ind] = split_tuning_corr(session1, session2, varargin)
%   Gets correlations between splitter tuning curves (specifically, the
%   difference between their L and R tuning curves), as well as the
%   correlations between ALL placefields between the same neurons in
%   session1 and session2.
%
%   INPUTS: session1/session2: session structure for each session
%
%   OUTPUTS: 
%       deltacurve_corr: correlation between deltacurve (see sigtuning) for
%       each neuron with center stem activity. Nans for cells not active
%       period or not active on the stem for one session
%
%       PFcorr: correlation between smoothed (1cm bin) place field maps.
%       Nan for cells not active on one session.
%
%       sigsplit_ind: indices of neurons exhibiting significant
%       splitting in session1.
%
%       deltacurve_corr_shuf and PFcorr_shuf: same as real data variables
%       above but for shuffling cell identity on the stem / shuffling cell
%       identify if active both sessions, respectively. ncells x
%       num_shuffles arrays but ONLY for valid cells

ip = inputParser;
ip.addRequired('session1',@isstruct);
ip.addRequired('session2',@isstruct);
ip.addParameter('binthresh', 3, @(a) round(a) == a && a > 0);
ip.addParameter('num_shuffles', 0, @(a) round(a) == a && a >= 0);
ip.addParameter('PFfile', 'Placefields_cm1.mat', @ischar); % placefields file
ip.parse(session1, session2, varargin{:});
binthresh = ip.Results.binthresh;
num_shuffles = ip.Results.num_shuffles;
PFfile = ip.Results.PFfile;
session1 = add_workdir(session1);
session2 = add_workdir(session2);

sesh_use = session1;
sesh_use(2) = session2;

neuron_map = neuron_map_simple(session1, session2);
valid_bool = neuron_map ~= 0 & ~isnan(neuron_map); % Get boolean of validly mapped neurons
%% Navigate to folder, load data, and register between sessions 
for k = 1:2
    path = sesh_use(k).Location; 
    cd(path); 
    
%     load('splittersByTrialType.mat','cellRespsByTrialType'); 
    load('sigSplitters.mat', 'deltacurve', 'sigcurve');  
    load(PFfile,'TMap_gauss')
    
    sesh_use(k).sigSplitters = find(cellfun(@(a) sum(a) >= binthresh, ...
        sigcurve));
    sesh_use(k).num_neurons = length(deltacurve);
    
    if k == 1
        sesh_use(k).deltacurve = deltacurve;
        sesh_use(k).TMap_gauss = TMap_gauss;
    elseif k == 2
        [sesh_use(k).deltacurve, sesh_use(k).TMap_gauss] = ...
            reg_splitter_vars( deltacurve, TMap_gauss, neuron_map);
    end
    
    sesh_use(k).stem_active_bool = ~cellfun(@isempty, sesh_use(k).deltacurve);
end
sigsplit_ind = sesh_use(1).sigSplitters;
sigsplit_bool = false(sesh_use(1).num_neurons);
sigsplit_bool(sigsplit_ind) = true;


%% Get correlation values
TMap1 = sesh_use(1).TMap_gauss(valid_bool);
TMap2 = sesh_use(2).TMap_gauss(valid_bool);

active_stem_both = sesh_use(1).stem_active_bool & sesh_use(2).stem_active_bool;
dcurve1 = sesh_use(1).deltacurve(active_stem_both);
dcurve2 = sesh_use(2).deltacurve(active_stem_both);
% Check to make sure curves are the same size - might be off a tiny bit due
% to how LinearizeTrajectory works...
%%
if sum(active_stem_both) > 0
    if length(dcurve1{1}) ~= length(dcurve2{1})
        dcurve2 = cellfun(@(a) resize(a,size(dcurve1{1})), dcurve2,...
            'UniformOutput', false);
    end
    deltacurve_corr = nan(size(sesh_use(1).deltacurve));
    deltacurve_corr(active_stem_both) = cellfun(@(a,b) corr(a',b','type','Spearman'),...
        dcurve1, dcurve2);
else
    deltacurve_corr = [];
end
%%
PFcorr = nan(length(neuron_map),1);
PFcorr(valid_bool) = cellfun(@(a,b) corr(a(:), b(:), 'type', 'Spearman',...
    'rows','complete'), TMap1, TMap2);

%% Shuffle if specified
PFcorr_shuf = nan(sum(valid_bool),num_shuffles);
nactive_both = sum(valid_bool);
deltacurve_corr_shuf = nan(sum(active_stem_both), num_shuffles);

% MATLAB tells me to do this to reduce overhead but it actually runs even
% slower when I do it per the following code:
% temp = arrayfun(@randperm, nactive_both*ones(1,num_shuffles),'UniformOutput',false);
% TMap2_rand = TMap2(cat(1,temp{:})');

nactive_stem_both = sum(active_stem_both);
p = ProgressBar(num_shuffles);
disp('Calculating shuffled correlations...')
parfor j = 1:num_shuffles
    deltacurve_corr_shuf(:,j) = cellfun(@(a,b) corr(a',b','type','Spearman'),...
        dcurve1, dcurve2(randperm(nactive_stem_both)));
    PFcorr_shuf(:,j) = cellfun(@(a,b) corr(a(:), b(:), 'type', 'Spearman',...
    'rows','complete'), TMap1, TMap2(randperm(nactive_both)));

% %     "Reduced overhead" code
% %      PFcorr_shuf(:,j) = cellfun(@(a,b) corr(a(:), b(:), 'type', 'Spearman',...
% %         'rows','complete'), TMap1, TMap2_rand(:,j)');
    p.progress;
end

p.stop;

end

%% Sub-function to map all the relevant variables in session2 to session1
function [deltacurve_reg, TMap_reg] = reg_splitter_vars(deltacurve, TMap, ...
    neuron_map)

% Pre-allocate everything
nneurons1 = length(neuron_map);
deltacurve_reg = cell(nneurons1,1);
TMap_reg = cell(1,nneurons1);

% Get map between
valid_bool = neuron_map ~= 0 & ~isnan(neuron_map);
valid_map = neuron_map(valid_bool);

% Map neuron variables between sessions
deltacurve_reg(valid_bool) = deltacurve(valid_map);
% dcurve_empty = cellfun(@isempty,deltacurve_reg);
% deltacurve_zero = zeros(size(deltacurve_reg{find(~dcurve_empty,1,'first')}));
% [deltacurve_reg{~valid_bool | dcurve_empty}] = deal(deltacurve_zero);

TMap_reg(valid_bool) = TMap(valid_map);
TMap_zero = TMap{1};
TMap_zero(~isnan(TMap_zero)) = 0;
[TMap_reg{~valid_bool}] = deal(TMap_zero);


end

