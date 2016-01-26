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

session = MD(160); % Continuous block(s)
session(2) = MD(161); % Delay block(s)
session(3) = MD(160); % Control - Continuous baseline session for comparison

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

% Load FT from PlaceMaps.mat for full session, sum all frames during one session
% versus the other while the mouse is running (important, must set a
% velocity threshold, suggest 2 cm/s)

%% Step 5: Get TMap correlations b/w conditions (Nat)
% probably the easiest step - Spearman? - use output from Step 3.

disp('Getting TMap correlations and distances')

%%% VARIABLES %%%
corr_type = 'Spearman'; % type of correlation - recommend Spearman
pval_filter = 0.1; % Keep only neurons whose TMap has a p-value below this

% Load each trial block
for j = 1:2
    ChangeDirectory_NK(session(j));
    load('PlaceMaps.mat','TMap_gauss','TMap_half','pval');
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
session(3).TMap_half = TMap_half;
session(3).pval = pval;
session(3).PF_centroid_1st = get_PF_centroid(session(3).TMap_half(1).TMap_gauss,0.9);
session(3).PF_centroid_2nd = get_PF_centroid(session(3).TMap_half(2).TMap_gauss,0.9);

% Get correlations between continous and delay blocks

% Keep only neurons that meet the p-value threshold for either set of
% blocks
neuron_filter = find(session(1).pval > (1-pval_filter) | ...
    session(2).pval > (1-pval_filter));

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

neuron_filter_control = find(session(3).pval > (1-pval_filter)); % filter

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
corr_cutoff_low = 0.3; % Correlation value below which we consider remapping
dist_cutoff_low = 5; % cm - distance cutoff below which we consider stable
dist_cutoff_high = 15; % cm - distance cutoff above which we consider remapping

% a) calculate firing binary for each set of blocks
fire_binary = ~isnan(bw_sesh_corrs); % This is a proxy but should work since TMap is Nan if FR = 0
fire_binary_control = ~isnan(bw_sesh_corrs_control);

% b) calculate binary for correlation and distance cutoffs
corr_binary_remap = bw_sesh_corrs <= corr_cutoff_low;
corr_binary_stable = bw_sesh_corrs > corr_cutoff_high;
dist_binary_remap = bw_sesh_dist >= dist_cutoff_high;
dist_binary_stable = bw_sesh_dist < dist_cutoff_low;

corr_binary_control_remap = bw_sesh_corrs_control <= corr_cutoff_low;
corr_binary_control_stable = bw_sesh_corrs_control > corr_cutoff_high;
dist_binary_control_remap = bw_sesh_dist_control >= dist_cutoff_high;
dist_binary_control_stable = bw_sesh_dist_control < dist_cutoff_low;

stable_corr_ratio = sum(fire_binary & corr_binary_stable)/length(fire_binary);
remap_corr_ratio = sum(fire_binary & corr_binary_remap | ~fire_binary)...
    /length(fire_binary);

stable_corr_ratio_control = sum(fire_binary_control & corr_binary_control_stable)...
    /length(fire_binary_control);
remap_corr_ratio_control = sum(fire_binary_control & corr_binary_control_remap ...
    | ~fire_binary_control)/length(fire_binary_control);

stable_dist_ratio = sum(fire_binary & dist_binary_stable)/length(fire_binary);
remap_dist_ratio = sum(fire_binary & dist_binary_remap | ~fire_binary)...
    /length(fire_binary);

stable_dist_ratio_control = sum(fire_binary_control & dist_binary_control_stable)...
    /length(fire_binary_control);
remap_dist_ratio_control = sum(fire_binary_control & dist_binary_control_remap ...
    | ~fire_binary_control)/length(fire_binary_control);

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





