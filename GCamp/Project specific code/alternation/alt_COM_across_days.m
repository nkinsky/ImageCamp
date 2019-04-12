function [COM_bw_sesh] = alt_COM_across_days(sesh1, sesh2)
% function [COM_bw_sesh] = alt_COM_across_days(sesh1, sesh2)
% Track splitter COMs between sessions
%
%   INPUTS 
%       sesh1/sesh2: session structure for each session
%
%   OUTPUTS
%       COM_bw_sesh: 2 column array with each row corresponding to the COM
%       of firing along the stem for each splitter cell.

ratio_thresh = 0; % Must be active on this proportion of trials to be considered.

% Get COMs across all trials for each session
[COML1, COMR1, ~, ~, sigID1] = alt_COM_bytrial(sesh1);
[COML2, COMR2, ~, ~, sigID2] = alt_COM_bytrial(sesh2);

% Get map between sessions
neuron_map = neuron_map_simple(sesh1, sesh2, 'suppress_output', true); 
valid_map_bool = ~isnan(neuron_map) & neuron_map ~= 0;

% Assume splitter neuron tuning curves move together, combine across L/R
% trials
COM1 = cat(1, COML1, COMR1);
COM2 = cat(1, COML2, COMR2);
ntrials1 = size(COM1, 1);
ntrials2 = size(COM2, 1);

% Get COMmean for all neurons that are active on at least trial_ratio of 
% trials. Reduces noise due to sparsely active splitters (should not really
% be any that pass the threshold, but this might be necessary for return
% arm place fields when I get there).
nactive1 = sum(~isnan(COM1),1);
nactive2 = sum(~isnan(COM2),1);
pass1_bool = nactive1/ntrials1 >= ratio_thresh; % ID neurons that are sufficiently active
pass2_bool = nactive2/ntrials2 >= ratio_thresh;


% Assign mean Center-of-Mass (COM) to appropriate # neuron in each session
COMmean1 = nan(1, max(cat(1,length(neuron_map), sigID1)));
COMmean1(1, sigID1(pass1_bool)) = nanmean(COM1(:, pass1_bool),1);
COMmean2 = nan(1,max(cat(1,sigID2,neuron_map)));
COMmean2(1, sigID2(pass2_bool)) = nanmean(COM2(:, pass2_bool),1);

% Now combine the two into one array
COM_bw_sesh = nan(length(neuron_map),2);
COM_bw_sesh(sigID1,1) = COMmean1(sigID1);
COM_bw_sesh(valid_map_bool,2) = COMmean2(neuron_map(valid_map_bool));

end

