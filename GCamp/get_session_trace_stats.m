function [half_all_mean, half_mean, LPerror_all, legit_trans_all] = ...
    get_session_trace_stats(session, varargin)
% [half_all_mean, half_mean, LPerror, legit_trans] = ...
%   get_session_trace_stats(session, varargin)
%   Get trace statistics and detect any neurons with sketchy transients
%   and/or low-pass filter artifacts. Default behavior is to NOT plot
%   everything currently.
%
% INPUTS: session - session structure (see MakeMouseSessionList/ChangeDirectory)
%
%         spam (optional): boolean to display warnings about neurons with
%         weird traces (highly conservative at this point). Default = true
%
% OUTPUTS: See plot_aligned_trace for full details
%          half_all_mean: mean half-life of all individual traces averaged
%          (sec)
%
%          half_mean: half-life of mean trace (sec)
%
%          LPerror_all: cell array with boolean, size = # good epochs, true = low-pass 
%          artifact detected
%
%          legit_trans_all: cell array with boolean, size = # total epochs,
%          true = good epochs used in calculation

%% Parse inputs
ip = inputParser;
ip.addRequired('session', @isstruct);
ip.addParameter('spam', true, @islogical); % output warnings about traces with weird transients
ip.addParameter('save_data', false, @islogical); % save data for fast loading later on
ip.addParameter('use_saved_data', false, @islogical); % load previously saved data!
ip.parse(session, varargin{:})

spam = ip.Results.spam;
save_data = ip.Results.save_data;
use_saved_data = ip.Results.use_saved_data;
%% Load saved data if applicable and skip the rest
load_success = false;
if use_saved_data
    try
        load(fullfile(session.Location,'trace_stats.mat'), 'trace_stats');
        if compare_sessions(trace_stats.session, session) %#ok<NODEF>
            half_all_mean = trace_stats.half_all_mean;
            half_mean = trace_stats.half_mean;
            LPerror_all = trace_stats.LPerror_all;
            legit_trans_all = trace_stats.legit_trans_all;
            load_success = true;
        end
    catch
        disp('Error loading trace_stats.mat - calculating directly rerun with flag to save_data if desired')
    end
end

%% Get session data
if ~load_success
PSAbool = []; NeuronTraces = []; SampleRate = [];
if ~isempty(session.Location)
    try
        load(fullfile(session.Location,'FinalOutput.mat'), 'PSAbool', 'NeuronTraces',...
            'SampleRate');
    catch
        disp('No FinalOutput.mat file found - loading Pos_align.mat')
        load(fullfile(session.Location,'Pos_align.mat'), 'PSAbool', 'RawTrace',...
            'LPtrace', 'SampleRate');
        NeuronTraces.RawTrace = RawTrace;
        NeuronTraces.LPtrace = LPtrace;
        clear RawTrace LPtrace
    end
    if isempty(SampleRate)
        SampleRate = 20;
        disp('SampleRate not found in FinalOutput.mat - must be older, using 20')
    end
else
    error('session.Location is empty - re-run MakeMouseSessionList and try again!')
end
    
nneurons = size(PSAbool,1);

%% Now calculate stats for all neurons
half_all_mean = nan(nneurons,1);
half_mean = nan(nneurons,1);
LPerror_all = cell(nneurons,1);
legit_trans_all = cell(nneurons,1);
for j = 1:nneurons
    [half_all, half_mean(j), LPerror, legit_trans] = ...
        plot_aligned_trace(PSAbool(j,:), NeuronTraces.RawTrace(j,:), ...
        NeuronTraces.LPtrace(j,:), 'SR', SampleRate, 'plot_flag', false);
    
    % Display any warnings about Low-pass artifact or bad transients.
    if spam
        if any(LPerror)
            disp(['Low-pass artifact discovered in neuron ' num2str(j) ...
                ': transient #s: ' num2str(find(LPerror'))])
        end
        
        if all(~legit_trans)
            disp(['ALL TRANSIENTS ARE SKETCHY IN NEURON ' num2str(j)])
        elseif any(~legit_trans)
            disp(['Sketchy traces (not used for calculation) in neuron ' num2str(j) ': transient #s: ' ...
                num2str(find(~legit_trans'))])
        end
    end
    half_all_mean(j) = nanmean(half_all);

    LPerror_all{j} = LPerror;
    legit_trans_all{j} = legit_trans;
end


if save_data
    trace_stats.session = session;
    trace_stats.half_all_mean = half_all_mean;
    trace_stats.half_mean = half_mean;
    trace_stats.LPerror_all = LPerror_all;
    trace_stats.legit_trans_all = legit_trans_all; %#ok<STRNU>
    save(fullfile(session.Location,'trace_stats.mat'), 'trace_stats')
end

end

end

