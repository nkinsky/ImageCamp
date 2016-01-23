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
% -quantify number of cells that exhibit rate remapping, global remapping,
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
% close to zero, IFFR difference doesn't matter
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

%% Step 6: Get within field firing rate for each condition, perform chi-squared test (Sam)
% step 1) threshold TMap to get extent of smoothed firing field (suggest starting with
% thresh eps, but this may end up too large, so will need to play around) and
% calculate a) # of passes through the field by the mouse, and b) # passes
% in which a transient occurs

% step 2) perform chi-squared test between conditions (I have no idea how
% to do this...)

%% Step 7: Single-unit splitting (Nat)
% Run Will's functions for each condition and compare...

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





