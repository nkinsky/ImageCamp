function [deltaER] = get_deltaER(session1, session2)
% [deltaER] = get_deltaER(session1, session2)
%   Gets change in event rate for all neurons in session1 to session2

%% Load in variables
load(fullfile(session1.Location,'FinalOutput.mat'),'PSAbool','NeuronTraces');
PSA{1} = PSAbool; traces{1} = NeuronTraces;

load(fullfile(session2.Location,'FinalOutput.mat'),'PSAbool','NeuronTraces');
PSA{2} = PSAbool; traces{2} = NeuronTraces;

%% Calculate event rates
[event_rates, trans_frames, event_lengths] = cellfun(@(a) get_num_trans(a), ...
    PSA, 'UniformOutput', false);

event_rates = cellfun(@(a,b) a./(size(b,2)/20/60), event_rates, PSA,...
    'UniformOutput', false); % convert to events/min

%% Calculate event lengths


%% Get map between sessions
neuron_map = neuron_map_simple(session1, session2);

%% Register event rates from session2 to session 1
valid_bool = ~isnan(neuron_map) & neuron_map ~= 0;
event_rates_reg = nan(size(event_rates{1}));
event_rates_reg(valid_bool) = event_rates{2}(neuron_map(valid_bool));
%% Calculate delta event rate (session2 - session1)
deltaER = diff([event_rates{1} event_rates_reg],1,2);
keyboard

end

