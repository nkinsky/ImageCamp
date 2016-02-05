% Continuous-Delayed Alternation Pilot Skeleton Code
%
% This is skeleton code outlining all the steps required to perform
% analyses of pilot data for the blocks of continuous alternation
% interspersed with blocks of delayed alternation

% Definitions
% In-field Firing Rate (IFFR): number of laps where a neuron fires within
% it's place field divided by number of laps through the place field
% Transient Rate (TR): Number of transients divided by number of seconds
% recording (Hz)
% Population Vector = PV
% 
% Anticipated Findings
% 1) Global remapping as a result of rule switch from continuous to delayed
% condition.
% 2) Splitting in continuous condition, maybe in delayed condition also
%
% GLOBAL REMAPPING METRICS
% -quantify percentage of cells that exhibit rate remapping, global remapping,
% or stay stable between conditions
% a) Firing binary in each condition (1 = fires in each condition, 0 =
% doestn't)
% b) Spatial correlation of Transient Map
% c) Firing rate (FR) (proportion of laps on which cell fires) - run
% chi-squared stat to determine if significantly different between
% conditions
%
% CLASSIFICATION CRITERIA
% I) Rate remappers: Firing binary = 1, Spatial correlation positive and
% high, IFFR significantly different b/w conditions
% II) Global remappers: Firing binary = 1, Spatial correlation negative or 
% close to zero, IFFR difference doesn't matter, OR firing binary = 0
% III) Stable neurons: Firing binary = 1, Spatial correlation positive and
% high, IFFR not significatly different b/w conditions
%
% POPULATION ANALYSIS
% a) rate correlations during condition without regard to space -
% expectation is for 0 or negative correlation between conditions
% b) population splitting - correlation in center stem between L/R trials,
% for both conditions versus lumping all together?
% c) spatial correlation - bin arena, get correlations between like bins
% across conditions (compare to same bins across blocks within the same
% condition)

close all

session = MD(163); % Continuous block(s)
session(2) = MD(164); % Delay block(s)
session(3) = MD(163); % Control - Continuous baseline session for comparison
session(4) = MD(162); % Combined session for pulling out IFFRs in step 4.

%% Step 1: Identify Blocks for each condition type and correct trials for each type (Sam?)
% Copy ProcOut.mat to new folder for each type, add into
% MakeMouseSessionList, and add in exclude_frames field for each to only
% include frames for that condition.

%% Step 2: Align position data between each condition type using batch_align_pos (Nat/Sam)
% This is necessary to make sure that each run of placemaps uses the same
% occupancy grids.  Nat could also adjust the code in CalculatePlaceMaps to
% do this all within the function via clever indexing (if we have the time
% this is the way to go since I can foresee needing this type of
% functionality again in the future)

%% Step 3: Run PFA on each condition type (Nat/Sam)
% Should also only include correct trials for this analysis... (do this by using the varargins
% 'exclude_frames' and 'name_append' while running PFA. Use 'cmperbin'
% varargin set to 2.5 to make everything run faster.

%% Step 4: Pull out IFFR for each condition - Sam?
% Use ProOut variables, including only correct trials, to create IFFR binary
% for each neuron.  Compare to binary between like blocks to make sure ca
% imaging variability isn't causing difference.

% Run sam's function to get in-field "firing" rates for every neuron for
% each block type
[PFhits, PFiffr]=IFFR_Sam(session(4));
PFpasses = round(PFhits*100./PFiffr);
% Need to have already run tenaspis, aligned tracking data and made place
% fields

% Do the same but for the control session
disp('SELECT 1ST CONTINUOUS BLOCK AS ''CONTINUOUS'' BLOCK AND 2ND CONTINUOUS BLOCK AS ''DELAY BLOCK'' IN FOLLOWING');
[PFhits_control, PFiffr_control]=IFFR_Sam(session(3));
PFpasses_control = round(PFhits_control*100./PFiffr_control);

% Calculate ratio between IFFR for each block
PFiffr_ratio = PFiffr(:,:,1)./PFiffr(:,:,2);
PFiffr_ratio_control = PFiffr_control(:,:,1)./PFiffr_control(:,:,2);

%% Step 5: Get TMap correlations b/w conditions (Nat)
% probably the easiest step - Spearman? - use output from Step 3.

disp('Getting TMap correlations and distances')

%%% VARIABLES %%%
corr_type = 'Spearman'; % type of correlation - recommend Spearman
pval_filter = 0.1; % Keep only neurons whose TMap has a p-value below this
num_transient_min = 5; % Keep only neurons firing this number of transients

% Load each trial block
for j = 1:2
    ChangeDirectory_NK(session(j));
    load('PlaceMaps.mat','TMap_gauss','TMap_half','pval');
    load('ProcOut.mat','NumTransients');
    session(j).NumTransients = NumTransients;
    session(j).TMap_gauss = TMap_gauss;
    session(j).TMap_half = TMap_half;
    session(j).PF_centroid_half(1).TMap_gauss = get_PF_centroid(session(j).TMap_half(1).TMap_gauss,0.9);
    session(j).PF_centroid_half(2).TMap_gauss = get_PF_centroid(session(j).TMap_half(2).TMap_gauss,0.9);
    session(j).pval = pval;
    session(j).PF_centroid = get_PF_centroid(session(j).TMap_gauss,0.9);
end

% Load 'control' block
ChangeDirectory_NK(session(3));
load('PlaceMaps.mat','TMap_half','pval');
load('ProcOut.mat','NumTransients');
session(3).NumTransients = NumTransients;
session(3).TMap_half = TMap_half;
session(3).pval = pval;
session(3).PF_centroid_1st = get_PF_centroid(session(3).TMap_half(1).TMap_gauss,0.9);
session(3).PF_centroid_2nd = get_PF_centroid(session(3).TMap_half(2).TMap_gauss,0.9);

% Get correlations between continous and delay blocks

% Keep only neurons that meet the p-value threshold for either set of
% blocks
neuron_filter = find(session(1).pval > (1-pval_filter) | ...
    session(2).pval > (1-pval_filter) & session(1).NumTransients > num_transient_min);

bw_sesh_corrs = nan(length(neuron_filter),1);
bw_sesh_corrs_half = cell(1,2);
for k = 1:length(neuron_filter)
    Tmap1 = session(1).TMap_gauss{neuron_filter(k)};
    Tmap2 = session(2).TMap_gauss{neuron_filter(k)};
    bw_sesh_corrs(k) = corr(Tmap1(:), Tmap2(:));
    
    % Now do the same but b/w 1st blocks and 2nd blocks in each condition
    % to see if sampling bias might make up for differences
    for m = 1:2
        TMap_half1 = session(1).TMap_half(m).TMap_gauss{neuron_filter(k)};
        TMap_half2 = session(2).TMap_half(m).TMap_gauss{neuron_filter(k)};
        bw_sesh_corrs_half{m}(k) = corr(TMap_half1(:), TMap_half2(:));
    end
end

bw_sesh_dist_all = get_PF_centroid_diff(session(1).PF_centroid, session(2).PF_centroid,...
    [1:size(session(1).PF_centroid,1)]',1); % Get distances b/w TMap centroids
bw_sesh_dist = bw_sesh_dist_all(neuron_filter); % Keep only those that meet the filter

% Get correlations between individual blocks of the same type (e.g.
% continuous v. continuous or delay v. delay)

if seshcmp(session(1),session(3)) || seshcmp(session(2),session(3))
    neuron_filter_control = neuron_filter;
else
    neuron_filter_control = find(session(3).pval > (1-pval_filter) ...
        & session(3).NumTransients > num_transient_min); % filter
end

bw_sesh_corrs_control = nan(length(neuron_filter_control),1);
for k = 1:length(neuron_filter_control)
    Tmap1 = session(3).TMap_half(1).TMap_gauss{neuron_filter_control(k)};
    Tmap2 = session(3).TMap_half(2).TMap_gauss{neuron_filter_control(k)};
    bw_sesh_corrs_control(k) = corr(Tmap1(:), Tmap2(:));
end
bw_sesh_dist_control_all = get_PF_centroid_diff(session(3).PF_centroid_1st, session(3).PF_centroid_2nd,...
    [1:size(session(3).PF_centroid_1st,1)]',1); % Get distances b/w TMap centroids
bw_sesh_dist_control = bw_sesh_dist_control_all(neuron_filter_control); % Keep only those that meet the filter

%%% PLOTS %%%

% Distance ecdf
figure(100) 
ecdf(bw_sesh_corrs); hold on; 
ecdf(bw_sesh_corrs_control); 
xlabel('TMap correlation value')
legend('Cont v Delay', 'Cont v Cont')

% Distance ecdf
figure(101) 
ecdf(bw_sesh_dist); hold on; 
ecdf(bw_sesh_dist_control); 
xlabel('Distance b/w centroids')
legend('Cont v Delay', 'Cont v Cont')

%% Step 6: Get within field firing rate for each condition, perform chi-squared test (Sam)
% step 1) threshold TMap to get extent of smoothed firing field (suggest starting with
% thresh eps, but this may end up too large, so will need to play around) and
% calculate a) # of passes through the field by the mouse, and b) # passes
% in which a transient occurs

% step 2) perform chi-squared test between conditions (I have no idea how
% to do this...)

%% Step 6.1 - Start quantifying remapping types

% Cutoffs - anything below this fails the test
corr_cutoff_high = 0.7; % Correlation value above which we consider stable
corr_cutoff_low = 0.7; % Correlation value below which we consider remapping
dist_cutoff_low = 5; % cm - distance cutoff below which we consider stable
dist_cutoff_high = 5; % cm - distance cutoff above which we consider remapping
rate_remap_ratio = 1.5; % if the ratio of IFFR between blocks in ANY field is greater than this, consider it a rate-remapper (if it also passes other criteria)
global_remap_ratio = 4; % if the ratio of IFFR between blocks in ANY field is greater than this, consider it a global-remapper (if it also passes other criteria)

% a) calculate firing binary for each set of blocks
fire_binary = ~isnan(bw_sesh_corrs); % This is a proxy but should work since TMap is Nan if FR = 0
fire_binary_control = ~isnan(bw_sesh_corrs_control);

% b) calculate binary for correlation and distance cutoffs
corr_binary_remap = bw_sesh_corrs <= corr_cutoff_low | ~fire_binary;
corr_binary_stable = bw_sesh_corrs > corr_cutoff_high;
dist_binary_remap = bw_sesh_dist >= dist_cutoff_high;
dist_binary_stable = bw_sesh_dist < dist_cutoff_low;

corr_binary_control_remap = bw_sesh_corrs_control <= corr_cutoff_low | ~fire_binary_control;
corr_binary_control_stable = bw_sesh_corrs_control > corr_cutoff_high;
dist_binary_control_remap = bw_sesh_dist_control >= dist_cutoff_high;
dist_binary_control_stable = bw_sesh_dist_control < dist_cutoff_low;

% c) calculate binary for rate remapping - these aren't quite correct
global_remap_fr_binary = any(PFiffr_ratio > global_remap_ratio | ...
    PFiffr_ratio < 1/global_remap_ratio,2);
global_remap_fr_binary = global_remap_fr_binary(neuron_filter);
rate_remap_fr_binary = any((PFiffr_ratio > rate_remap_ratio | PFiffr_ratio < 1/rate_remap_ratio) ...
    & (PFiffr_ratio ~= 0 & ~isinf(PFiffr_ratio)),2);
rate_remap_fr_binary = rate_remap_fr_binary(neuron_filter);

stable_fr_binary = any((PFiffr_ratio < rate_remap_ratio & PFiffr_ratio ~= 0) & ...
    (PFiffr_ratio > 1/rate_remap_ratio & ~isinf(PFiffr_ratio)),2);
stable_fr_binary = stable_fr_binary(neuron_filter);

rate_remap_fr_binary_control = any((PFiffr_ratio_control > rate_remap_ratio | ...
    PFiffr_ratio_control < 1/rate_remap_ratio) ...
    & (PFiffr_ratio_control ~= 0 & ~isinf(PFiffr_ratio_control)),2);
rate_remap_fr_binary_control = rate_remap_fr_binary_control(neuron_filter_control);
global_remap_fr_binary_control = any(PFiffr_ratio_control > global_remap_ratio | ...
    PFiffr_ratio_control < 1/global_remap_ratio,2);
global_remap_fr_binary_control = global_remap_fr_binary_control(neuron_filter_control);
stable_fr_binary_control = any((PFiffr_ratio_control < rate_remap_ratio & PFiffr_ratio_control ~= 0) & ...
    (PFiffr_ratio_control > 1/rate_remap_ratio & ~isinf(PFiffr_ratio_control)),2);
stable_fr_binary_control = stable_fr_binary_control(neuron_filter_control);

% Get ratios of each type of neuron
num_filtered = length(bw_sesh_corrs);
global_remappers = neuron_filter(~fire_binary | global_remap_fr_binary | ...
    (fire_binary & ~rate_remap_fr_binary & corr_binary_remap));
stable_or_rate = neuron_filter(fire_binary & ~global_remap_fr_binary);
stable = neuron_filter(corr_binary_stable & fire_binary & stable_fr_binary);
rate_remappers = neuron_filter(corr_binary_stable & fire_binary & rate_remap_fr_binary);

% stable2 = neuron_filter(stable & stable_fr_binary);

num_filtered_control = length(bw_sesh_corrs_control);
% remappers_control = corr_binary_control_remap |...
%     ~fire_binary_control;
stable_control = neuron_filter_control(corr_binary_control_stable &...
    fire_binary_control & stable_fr_binary_control);
rate_remappers_control = neuron_filter_control(corr_binary_control_stable & ...
    fire_binary_control & rate_remap_fr_binary_control);
global_remappers_control = neuron_filter_control(corr_binary_control_remap | ...
    (corr_binary_control_stable & global_remap_fr_binary_control | ~fire_binary_control));
% stable2_control = neuron_filter_control(stable_control & stable_fr_binary_control);

%%% NRK - need to update here to get correct numbers out
global_remap_corr_ratio = length(global_remappers)/num_filtered;
rate_remap_corr_ratio = length(rate_remappers)/num_filtered;
stable_corr_ratio = length(stable)/num_filtered;
global_remap_corr_ratio_control = length(global_remappers_control)/num_filtered_control;
rate_remap_corr_ratio_control = length(rate_remappers_control)/num_filtered_control;
stable_corr_ratio_control = length(stable2_control)/num_filtered_control;

stable_dist_ratio = sum(fire_binary & dist_binary_stable)/length(fire_binary);
remap_dist_ratio = sum(fire_binary & dist_binary_remap | ~fire_binary)...
    /length(fire_binary);

stable_dist_ratio_control = sum(fire_binary_control & dist_binary_control_stable)...
    /length(fire_binary_control);
remap_dist_ratio_control = sum(fire_binary_control & dist_binary_control_remap ...
    | ~fire_binary_control)/length(fire_binary_control);

% Bar comparing proportions
figure(102)
bar([stable_corr_ratio, stable_corr_ratio_control; ...
    global_remap_corr_ratio, global_remap_corr_ratio_control; ...
    rate_remap_corr_ratio, rate_remap_corr_ratio_control]);
ylim([0 1]);
set(gca,'XTickLabel',{['Stable (rho > ' num2str(corr_cutoff_high) ')'],...
    ['Global Remapping (rho <= ' num2str(corr_cutoff_low) ' or no transients during one block type)'],...
    ['Rate Remapping']})
ylabel('Proportion of Neurons')
legend('Continuous v Delay','Control (within block type)')
title('Stability breakdown using correlation values')

figure(103)
bar([stable_dist_ratio, stable_dist_ratio_control; remap_dist_ratio,...
    remap_dist_ratio_control]);
ylim([0 1]);
set(gca,'XTickLabel',{['Stable (d_{centroid} < ' num2str(dist_cutoff_low) ' cm)'],...
    ['Remapping (d_{centroid} >= ' num2str(dist_cutoff_high) ' cm or no transients during one block type)']})
ylabel('Proportion of Neurons')
legend('Continuous v Delay','Control (within block type)')
title('Stability breakdown using distance between place field centroids')

%% Plot all the maps against each other
% disp('Displaying NaN corrs - hit any key over the figure window to scroll through')
% delay_pilot_TMap_compare(session(1), session(2), neuron_filter(~fire_binary), ...
%     1)

disp('Displaying global remappers - hit any key over the figure window to scroll through')
delay_pilot_TMap_compare(session(1), session(2), neuron_filter(corr_binary_remap), ...
    1,'disp_IFFR',PFhits,PFiffr)
disp('Displaying stable neurons - hit any key over the figure window to scroll through')
delay_pilot_TMap_compare(session(1), session(2), neuron_filter(corr_binary_stable), 1)

%% Step 7: Single-unit splitting (Nat)
% Run Will's functions for each condition and compare...

% Done for 1/13/2016 - we get a few here

%% Step 8: Create PV of firing rate in each condition and cross-correlate the two (Nat)
% Get TR for each condition for each neuron

% Create 1 x num_neurons vector for each condition with TR for each neuron

% Cross-correlate the two

% Should probably shuffle neuron identity in one condition 1000 times to
% get chance distribution

%% Step 9: Population Vector correlations between conditions

% Linearize maze and bin it (say 5cm bins minimum)

% For each bin:
    % For each condition
    
        % Get Occupancy 

        % Get TR for each neuron

        % Create PV
        
        % Do all the same but for each block within a condition and get
        % correlation within blocks...
        
   %end
   
   % Cross-correlate each bin's PV across conditions
   
   % Shuffle neuron identity in one condition 1000 times and get shuffled
   % distribution of PV correlations
   
%end


    

%% Step 10: Population Splitting (Nat)

% Identify L correct trials and R correct trials

% Bin center-stem into say, 5 bins, get population vector of transient
% rates for each bin by L/R correct trials

% Cross-correlate L correct and R correct PVs





