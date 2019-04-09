function [glm_t, glm_tx, glm_txy, glm_step] = splitter_glm(FT, x, y, trial_type)
% [glm_t, glm_tx, glm_txy, glm_step] = splitter_glm(FT, x, y, trial_type)
%  Constructs a glm for a given splitter neuron based on the mouses's x/y
%  position, calcium event activity, and trial type. Inputs must be row
%  vectors;

%% Super simple version - does trial type influence event probability on its
% own?
t_pred = cat(2, trial_type');
glm_t = fitglm(t_pred, FT', 'VarNames', {'TurnDir', 'CaProb'}, ...
    'Distribution', 'binomial');

%% Trial type + x position (5th order polynomial)
tx_pred = cat(2, trial_type', x', x'.^2, x'.^3, x'.^4, x'.^5);
glm_tx = fitglm(tx_pred, FT', 'VarNames', {'TurnDir', 'x', 'x2', 'x3', ...
    'x4', 'x5', 'CaProb'}, 'Distribution', 'binomial');

%% Trial type + x position (5th order polynomial) + y position (linear)
txy_pred = cat(2, trial_type', x', x'.^2, x'.^3, x'.^4, x'.^5, y');
glm_txy = fitglm(txy_pred, FT', 'VarNames', {'TurnDir', 'x','x2', 'x3', ...
    'x4', 'x5', 'y', 'CaProb'}, 'Distribution', 'binomial');

%% Now do this in stepwise fashion 
glm_step = stepwiseglm(txy_pred, FT', 'constant', 'VarNames', {'TurnDir', 'x',...
    'x2', 'x3', 'x4', 'x5', 'y', 'CaProb'}, 'Distribution', 'binomial', ...
    'Criterion','AIC');

%% Now what do I do with this information? I can get values for each variable
% but what do they mean? Is the value or the p-value more important?

end

