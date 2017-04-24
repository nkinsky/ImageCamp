function [ output_args ] = twoenv_coherence_v_pval( input_args )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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

