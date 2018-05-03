%% Two-env on/off analysis
% Compare # cells turning on/off entirely between square and circle days
% 1-2 and 3-4  and 7-8 versus those staying on in circle days 2-3 to see how much
% going into a different arena causes new cells to come online.
% Next, do the same but for same day comparisons: 1,2,3,4,7,8 within and
% 5,6 across arenas. include cells with DI = -1/1 too?

% Run plot_pfangle_batch w/plot_flag=false, no PCfilter and nto get coh_ratio and gr_ratio
% and ncells for each session-pair. Better yet, just run twoenv_mismatch first.
% Then run classify_cells with batch_session_map for each session pair and 
% get new/old ratio. Then make a breakdown for each session of: #coh, #gr,
% #silent, #new. Then aggregate this breakdown for all coherent and all global
% remapping sessions on the same day (maybe 1-3 days lag?). 
% Show that there is no difference for local vs mismatch pairs.

%% Start here and vet for square
good_map_sq = cell(4,8,8);
become_silent_sq = cell(4,8,8);
new_cells_sq = cell(4,8,8);
p = ProgressBar(4*28);
for j = 1:4
    
    load(fullfile(all_square2(j,1).Location,'batch_session_map.mat'));
    batch_map = fix_batch_session_map(batch_session_map);
    for k = 1:7
        for ll = (k+1):8
            [good_map_sq{j,k,ll}, become_silent_sq{j,k,ll}, new_cells_sq{j,k,ll}] = ...
                classify_cells(all_square2(j,k), all_square2(j,ll),0,...
                '', 'batch_map',batch_map);
            p.progress;
        end
    end
    
end
p.stop;

% use ncells for total number of cells for each session, NOT length
% good_map since ncells only includes cells active above the speed
% threshold.

% Need to calc PVs for each session too to get DI!!! Run twoenv_scratchpad
% with pval_filt = 0 and ntrans_thresh = 0

% Note that good_map size (or non-nan/0 values) should match up with
% ncells data from mismatch_histograms

%%

% Then get breakdown as above for 0 day within vs across (hallway
% comparison), and 1 day within (day 2-3) vs across (day 1-2, 3-4, 7-8).
% Should characterize how much basal on/off stuff is going on vs remapping
% vs coherency.