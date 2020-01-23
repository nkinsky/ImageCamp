function [thalf_e, efitobj] = exp_fit_traces(session, varargin)
% [thalf_e, efitobj] = exp_fit_traces(traces, psabool)
%   Fit an exponential decay function to the last transient of each trace,
%   spit out model and half decay time
%
%   Note that if you only have a lot of transients in a row you can get
%   erroneously long decay times. For now, this only happens for ~1% of
%   neurons, so you can just exclude these neurons (t_half > ~7, very
%   conservatively).

ip = inputParser;
ip.addRequired('session', @isstruct);
ip.addParameter('save_data', false, @islogical); % save data for fast loading later on
ip.addParameter('use_saved_data', false, @islogical); % load previously saved data!
ip.addParameter('plot_flag', false, @islogical);
ip.addParameter('debug', false, @islogical);
ip.parse(session, varargin{:})
save_data = ip.Results.save_data;
use_saved_data = ip.Results.use_saved_data;
plot_flag = ip.Results.plot_flag;
debug = ip.Results.debug;

%% Get save file and check if exists
save_file = fullfile(session.Location,'efit_traces.mat');
load_success = false;
if use_saved_data
    try
        if exist(save_file, 'file')
            load(save_file,'thalf_e', 'efitobj')
            load_success = true;
        else
            load_success = false;
        end
    catch
        load_success = false;
    end
    if ~load_success
        disp('Error loading saved data - running from scratch')
    end
end
            
    
%% Load in data
if ~load_success
SampleRate = []; PSAbool = []; NeuronTraces = [];
load(fullfile(session.Location, 'FinalOutput.mat'), 'PSAbool', ...
    'NeuronTraces', 'SampleRate');
if isempty(SampleRate)
    SR = 20; %default value for older recordings where this wasn't saved in FinalOutput.
else 
    SR = SampleRate;
end
psabool = PSAbool; traces = NeuronTraces.LPtrace;
traces = double(traces); % make double if single
[nneurons, nframes] = size(traces); % # neurons & #frames

%% Start calculating things and plotting if desired
% arbitrary threshold - all fits above this look wonky, so try to fit an 
% earlier transient if above this value. Note that no matter what a couple
% neurons that only have a few transients in a row might not be able to be
% fit...
bad_length = 7; 
% max time after trace to include for fitting...
time_after_peak = 4; % seconds

mean_f = mean(traces,2); % get baseline fluorescence for each neuron
[ntrans, trans_frames] = get_num_trans(psabool); % get frames with transients

% ID last transient decay time and fit exponential to it
efitobj = cell(nneurons, 1);
thalf_e = nan(nneurons, 1);
for j = 1:nneurons
    trace_use = traces(j,:); % neuron trace to use
    ntrans_use = ntrans(j);
    
    % Calculate trace - set up while loop to check 2nd-4th last transients
    % if they are wonky at the end (i.e. if you get crazy long half-decay
    % values or negative values, which usually means there are a lot of
    % transients occurring afterward
    thalf_temp = nan;
    niters = 0; 
    
    while (isnan(thalf_temp(end)) || thalf_temp(end) > bad_length || ...
            thalf_temp(end) < 0) && niters <= (ntrans(j)-1)
        end_frame = trans_frames{j}(ntrans_use, 2); % frame at end of trace
        start_frame = trans_frames{j}(ntrans_use, 1);
        max_f = trace_use(end_frame); % fluor at end of trace
        start_f = trace_use(start_frame);
        % threshold when trace returns to baseline (<10% from baseline) -
        % better would be to see when it returns to 10% of start value...
%         baseline_fthresh = mean_f(j) + (max_f - mean_f(j))*0.1;
        baseline_fthresh = start_f + (max_f - start_f)*0.2;
        % ID frame when trace goes below threshold - go to max time_after_peak seconds
        % beyond peak to avoid next transient or fluor. from neighboring
        % neuron
        baseline_frame = min([find(trace_use(end_frame:min([(end_frame+time_after_peak*SR), nframes])) ...
            <  baseline_fthresh, 1, 'first') + end_frame, end_frame + time_after_peak*SR, nframes]); 
        fit_frames = end_frame:baseline_frame; % frames to fit with exponential.
        last_trans = trace_use(fit_frames); % fluor. values to fit with exponential
        efit_temp = fit((1:length(last_trans))'/SR, last_trans', 'exp1'); % calculate fit
        thalf_temp = [thalf_temp, log(0.5)/efit_temp.b]; % calculate half-life
        niters = niters + 1;
        ntrans_use = ntrans_use - 1;
    end
    if niters == ntrans_use && thalf_temp(end) > bad_length
        thalf_temp = nan; % set tha
        if debug
            disp(['Maxed out on neuron ' num2str(j)])
        end
    end
    efitobj{j} = efit_temp;
    
    % If you end up with a negative value for half-life, set to nan.
    % Otherwise, take the last value (which should be good).
    if thalf_temp(end) < 0
        thalf_e(j) = nan;
    else
        thalf_e(j) = thalf_temp(end);
    end
    
    % plot every 20th neuron OR plot long/short transients...
    if plot_flag
        if thalf_e(j) > 5 || thalf_e(j) < 0.1% niters == ntrans_use  % thalf_e(j) > 3  % j/20 == round(j/20) || j == nneurons
            trans_check = feval(efitobj{j}, (1:length(last_trans))'/SR); % calc fit for last trans
            % plot actual fluor values for +/- 3 seconds from fit
            expand_frames_plot = (end_frame-6*SR):min([baseline_frame+6*SR, nframes]);
            last_trans_expand = trace_use(expand_frames_plot);
            psa_expand = psabool(j, expand_frames_plot);
            figure; plot(expand_frames_plot, last_trans_expand, 'b-', ...
                expand_frames_plot(psa_expand), last_trans_expand(psa_expand), 'r.');
            hold on;
            plot(fit_frames, trans_check,'r--');
            plot(get(gca,'xlim'), [1 1]*mean_f(j), 'k-.')
            title(['Neuron ' num2str(j)])
            legend('Actual trace', 'psa', 'exp fit', 'baseline');
        end
    end
end

%% Save data if specified
if save_data
    save(save_file,'thalf_e', 'efitobj')
end

end

end

