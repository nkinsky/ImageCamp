function [ output_args ] = twoenv_coherence_v_pval( input_args )
% bare bones skeleton code to see if cells with higher spatial info tend to
% align to local cues more?  Or maybe something else.  General idea is that
% I want to see if cells with higher spatial info tend to stay in a
% configuration more than cells with low spatial info...

%% Very rough code to get this going - wanted to get it down before heading on vacation
[best_angle, best_angle_all] = twoenv_rot_analysis_full(G30_square(1:3), 'square');
load('Placefields_rot0.mat', 'pval'); % sesh1
good_neurons = find(~isnan(best_angle_all{1,2}));
pval_use = pval; pval_use(isnan(best_angle_all{1,2})) = nan;
figure; plot(best_angle_all{1,2}, pval_use, '.')
figure; boxplot(pval(best_angle_all{1,2} == 0)); ylim([-0.1 1])
figure; boxplot(pval(best_angle_all{1,2} == 90)); ylim([-0.1 1])
figure; boxplot(pval(best_angle_all{1,2} == 180)); ylim([-0.1 1])
figure; boxplot(pval(best_angle_all{1,2} == 270)); ylim([-0.1 1])

end

