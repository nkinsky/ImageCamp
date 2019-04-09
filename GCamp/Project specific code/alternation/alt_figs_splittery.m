% Supplemental Fig to check how much splitters are governed by y-position
% of mouse

%% Start simple - plot histogram for each session with L and R y-position
% histograms along the whole stem.

sesh_all2 = cat(2, G30loop_alt, G30forced_alt, alt_all);
for j = 1:length(sesh_all2)
    [~, hf] = alt_stem_hists(sesh_all2(j));
    printNK('Stem lateral occupancy by bin - All Mice', 'alt', ...
        'hfig', hf, 'append', true);
    close(hf)
end


%% GLM - seems legit, but I don't really know how to interpret the output yet.
% Should I be looking at the p-value of each regressor/predictor? Should I
% only consider neurons where turn-direction is a significant predictor?
% Should I exclude neurons where y position is a significatn predictor?
% What if y is significant but just barely contributes, or is the last
% added to the glm?

load(fullfile(G30_alt(1).Location, 'Alternation.mat'), 'Alt')
% Would need to write a for loop to find and go through significant
% splitters below.
j = 62; stem_bool = Alt.section == 3 & ismember(Alt.choice, [1,2]); 
[glm_t, glm_tx, glm_txy, glm_step] = splitter_glm(PSAbool(j, stem_bool), ...
    Alt.x(stem_bool), Alt.y(stem_bool), Alt.choice(stem_bool));

%% Loop through and plot L/R trajectories AND cell activity overlaid in 2D 
% for each significant splitter to inspect by eye. Spits out a PDF in each
% working directory...
sigthresh = 3;

for mouse = 1:4
    full_sesh = alt_all_cell{mouse};
    nsesh = length(full_sesh);
    for ns = 1:nsesh
        sesh_use = full_sesh(ns);
        sigbool = alt_id_sigsplitters(sesh_use, sigthresh);
        sigind = find(sigbool);
        nsplitters = length(sigind);
        for j = 1:nsplitters
            neuron_use = sigind(j);
            hf = alt_plotLRevents(sesh_use, neuron_use);
            filename = ['traj_and_LRevents-' sesh_use.Animal '-' sesh_use.Date ...
                '-session' num2str(sesh_use.Session)];
            printNK(filename, sesh_use.Location, 'hfig', hf, 'append', true);
            close(hf)
            
        end
    end
end