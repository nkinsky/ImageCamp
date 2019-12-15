function [half_all, half_mean, LPerror, legit_trans] = plot_aligned_trace(...
    psa, rawtrace, LPtrace, varargin)
% plot_aligned_trace(psa, trace, varargin)
%
% Plots all calcium events for a given neuron aligned to onset. Also can
% use to calculate traces without plotting (plot_flag = false);
%
% INPUTS:   psa (1xnframes boolean of putative spiking activity for one
%           neuron)
%
%           rawtrace: same as psa but raw DF/F for that neuron
%
%           LPtrace: same as rawtrace but spatial low-pass trace (used to
%           calculate 1/2 life in a less noisy manner)
%
%           ax(optional): axes to plot into (default = plot in new fig)
%
%           SR(optional): sample rate (20 = default)
%
%           offset(optional): time in seconds to display before/after
%           putative spiking onset
%
%           plot_flag(optiona): boolean (default = true)
%
%           min_epoch_time(optional, not yet implemented): exclude any
%           transients with rise times less than this long
%
% OUTPUTS:  half_all: half-life times for all transients (seconds).
%           Calculated from LPtrace.
%           
%           half_mean: half-life of mean transient (seconds)
%
%           LPerror: true if a low-pass artifact is discovered and a neuron
%           is tossed out. ~1% of neurons
%
%           bad_trans_error: true if bad transients (not all rising phases
%           are actually rising) detected for ALL transients. (Rare, ~1/500)
%
%           poor_merge: true if you can't get a mean trace, likely due to a
%           larger transient from a neighboring neuron making it into the
%           traces variable. (Rare, only 1 seen in 4 sessions so far).

ip = inputParser;
ip.addRequired('psa', @islogical); % boolean of rising times
ip.addRequired('rawtrace', @(a) length(a) == length(psa)); % Raw trace
ip.addRequired('LPtrace', @(a) length(a) == length(psa)); %  LP trace
ip.addParameter('SR', 20, @(a) a > 0 && round(a) == a); % Sample rate
ip.addParameter('ax', nan, @(a) ishandle(a) || isnan(a)); % Axes for plotting
ip.addParameter('offset', 10, @(a) a > 0 && round(a) == a); % time before/after start to plot
ip.addParameter('plot_flag', true, @islogical); % plot results?
ip.addParameter('min_epoch_time', 0.2, @(a) a > 0); % exclude transients with rise times less than this long
ip.addParameter('debug_badtrans', false, @islogical); % Debug how you id sketchy traces by plotting them all
ip.parse(psa, rawtrace, LPtrace, varargin{:});

SR = ip.Results.SR;
ax = ip.Results.ax;
offset = ip.Results.offset;
plot_flag = ip.Results.plot_flag;
min_epoch_time = ip.Results.min_epoch_time;
debug_badtrans = ip.Results.debug_badtrans;

if ~ishandle(ax) && plot_flag
    figure; ax = gca;
end

% Calculate # frames
offset_frames = offset*SR; 
onset_frame = offset_frames + 1;

% Get putative spiking epochs
epochs = NP_FindSupraThresholdEpochs(psa, eps);
nepochs = size(epochs,1);

% Edge-case: toss any very small epochs where there seem to be a lot of decaying
% values during psa (found in only two neurons so far). Must have more than
% 25% of transient decaying... (this still allows transients that have a
% brief 1-2 frame dip - these are most likely due to two successive bursts
% in a row))
thresh = 0.25;
legit_trans = false(nepochs, 1);
for j = 1:nepochs
    legit_trans(j,1) = sum(diff(LPtrace(epochs(j,1):epochs(j,2))) >= 0) >= ...
        (1-thresh)*diff(epochs(j,:));
%    legit_trans(j,1) = all(diff(LPtrace(epochs(j,1):epochs(j,2))) >= 0);
end

if debug_badtrans
    figure;
    plot_style = {'r*', 'g*'};
    plot(LPtrace,'k-'); hold on;
    for j = 1:nepochs
        plot(epochs(j,1):epochs(j,2), LPtrace(epochs(j,1):epochs(j,2)), ...
            plot_style{legit_trans(j)+1});
    end
    disp('DEBUGGING BAD TRANSIENTS in plot_aligned_trace')
    keyboard
end

good_epochs = epochs(legit_trans, :);
nepochs = size(good_epochs,1);
nframes = length(psa); 

if all(~legit_trans)
    bad_trans_error = true;
else
    bad_trans_error = false;
end

%Pre-allocate
traces_aligned = nan(nepochs, 2*offset_frames+1);
LPtraces_aligned = nan(nepochs, 2*offset_frames+1);
LPmax = nan(nepochs,1);
psa_aligned = false(nepochs, 2*offset_frames+1);
decay_aligned = false(nepochs, 2*offset_frames+1);
plot_times = (-offset_frames:1:offset_frames)/SR;

% Construct traces aligned to onset of each transient
for j = 1:nepochs 
    start_frame = good_epochs(j,1);
    end_frame = good_epochs(j,2);
    plot_frames = start_frame-offset_frames:1:start_frame + offset_frames; 
    valid_frames = plot_frames > 0 & plot_frames <= nframes;
    traces_aligned(j, valid_frames) = rawtrace(plot_frames(valid_frames));
    LPtraces_aligned(j, valid_frames) = LPtrace(plot_frames(valid_frames));
    psa_aligned(j, valid_frames) = psa(plot_frames(valid_frames));
    
    % Get boolean for all times after peak of transient (decay period)
    decay_aligned(j, (end_frame-start_frame+offset_frames):end) = true;
    LPmax(j, 1) = LPtrace(end_frame); % max of each low-pass trace
end

% Check for smaller transients entirely within plotting window for larger
% transient? Or just show them? Plot both! Eliminate and don't!

% Grab mean overall fluorescence for ENTIRE trace
trace_mean = nanmean(rawtrace);

% Plot
if plot_flag
    htraces = plot(ax, plot_times, traces_aligned, 'b-');
    arrayfun(@(a) set(a, 'Color', [0 0 1 0.5]), htraces)
    xlabel(ax, 'Time from onset (s)')
    ylabel(ax, 'DF/F')
    hold on;
    plot(ax, plot_times, nanmean(traces_aligned,1), 'k-')
    plot(ax, plot_times, ones(size(plot_times))*trace_mean, 'k--')
    set(ax,'box','off')
end

%% Conservatively calculate stats from LPtrace only! Time back to where
% trace starts for each trace!
% Note that if there is a small transient followed quickly by a very large
% transient this could be VERY unconservative, might want to exclude any
% traces like this...

% Other edge case to consider - if trace starts well below zero (right
% after large adjacent neuron is activated) then you get a sharp rise and
% no decay since it just goes back to zero. Artifact of low-pass filtering
% effectively makes it look like there is NO decay!!!
LP_zero = LPtraces_aligned - LPtraces_aligned(:, onset_frame); % make all traces start at DF/F=0
LPmax_zero = LPmax - LPtraces_aligned(:, onset_frame); % Find LPmax relative to starting DF/F for that trace
half_all = nan(max([nepochs,1]),1);
LPerror = false(nepochs,1);
for j = 1:nepochs
    if isempty(find(LP_zero(j,:) <= LPmax_zero(j)/2 & decay_aligned(j,:), ...
            1, 'first'))
        LPerror(j) = true;
    else
        half_all(j,1) = (find(LP_zero(j,:) <= LPmax_zero(j)/2 & decay_aligned(j,:), ...
            1, 'first') - onset_frame)/SR; % half-life in seconds
    end
end

%% Now get stat from mean trace - is this different?
max_epoch_length = max(diff(epochs,1,2)); % max you are looking for should be limited to this + one frame
mean_trace = nanmean(LPtraces_aligned(~LPerror, onset_frame:end), 1); % include only from start of rising phase of legitimate transients w/o LP artifact
[mean_max, imax] = max(mean_trace(1:(max_epoch_length+1)));
mean_zero = mean_trace(1);
decay_bool = false(size(mean_trace));
decay_bool(imax+1:end) = true; 
poor_merge = false;
if nepochs > 0
    half_mean = find((mean_trace - mean_zero) < ...
        (mean_max - mean_zero)/2 & decay_bool, 1, 'first')/SR;
    
    % You can get an empty array if a larger transient from a neighboring
    % neuron somehow made it through and swamped your signal, likely
    % because of rare neighbor spiking perfectly timed after the original
    % neuron spike.
    if isempty(half_mean)
        poor_merge = true;
        half_mean = nan;
    end
else
    half_mean = nan;
end

%% What about rise times? What if these are unaffected?

%% Put stats in plot
if plot_flag
    text(ax, 0.25*offset, 0.8*max(get(gca,'YLim')), ['\tau_{1/2,mean} = ' ...
        num2str(half_mean,'%0.2g') 'sec'])
    text(ax, 0.25*offset, 0.7*max(get(gca,'YLim')), ['\tau_{1/2,all,mean} = ' ...
        num2str(nanmean(half_all),'%0.2g') 'sec'])
end

end

