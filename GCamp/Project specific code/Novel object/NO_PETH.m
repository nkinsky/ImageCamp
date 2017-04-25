function [PETH_out, trace_out, trace_shuffle, sig_sum ] = NO_PETH(session, varargin)
% [PETH_out, trace_out, trace_shuffle, sig_sum ] = NO_PETH(session, frame_buffer, scroll_flag)
%   Plots a peri-event histogram for each neuron for each object.  Frame
%   buffer is the number of frames that you wish to
%   display before/after using the imaging sampling rate (20 fps).
%   Default = 40 if not specified.
%
%   Must have NOtracking_final and Pos_align.mat in the working directory
%   in session.

ip = inputParser;
ip.addRequired('session',@isstruct);
ip.addOptional('frame_buffer', 40, @(a) a >=0 && round(a,0) == a);
ip.addParameter('scroll_flag', true, @(a) islogical(a) || a == 0 || a == 1);
ip.addOptional('num_shuffles', 100, @(a) a >=0 && round(a,0) == a);
ip.parse(session, varargin{:});

frame_buffer = ip.Results.frame_buffer;
scroll_flag = ip.Results.scroll_flag;
num_shuffles = ip.Results.num_shuffles;

aviSR = 30;
imageSR = 20;
% Default is to display 40 frames (2 sec) before/after object exploration
if nargin < 2
    frame_buffer = 40;
end

if length(frame_buffer) == 1
    frame_buffer(1,2) = frame_buffer;
end


% Load variables into workspace
if isfield(session,'posfile')
    dirstr = fileparts(session.posfile);
else
    dirstr = ChangeDirectory_NK(session,0);
end
load(fullfile(dirstr,'Pos_align.mat'),'time_interp','aviFrame','PSAbool','LPtrace');
load(fullfile(dirstr,'NOtracking_final.mat'));

% Allocate out variables
num_neurons = size(PSAbool,1);
num_frames = size(PSAbool,2);
num_objects = 2;
try
    sesh_full = NO_obj_des_all(session);
catch % Error catching to match up MD and mouse-specific data structures from AK senior thesis work
    Bellatrix_DataStructure; Polaris_DataStructure;
    MD_AK = cat(2, Bellatrix, Polaris); % Load both these into the workspace
    session_id = false;
    AKdirs = arrayfun(@(a) fileparts(a.posfile),MD_AK,'UniformOutput',false);
    session_id = cellfun(@(a) strcmpi(a,session.Location),AKdirs);
    if any(session_id) && sum(session_id) == 1
        sesh_full = NO_obj_des_all(MD_AK(session_id));
    else
        error('Cannot find matching data structure data in MD vs Polaris/Bellatrix')
    end
end
obj_frames{1} = sesh_full.frames1; % Should have done this in the original function
obj_frames{2} = sesh_full.frames2;

%% Calculate PETHs
PETH_out = cell(1,2);
trace_out = cell(1,2);
for j = 1:num_objects
    % Identify exploration epochs for the object
	event_frames_AVI = get_event_frames(obj_frames{j},frame_buffer(1)*aviSR/imageSR);
    event_times_AVI = obj_frames{j}(event_frames_AVI)/aviSR;
    event_frames = arrayfun(@(a) findclosest(a,aviFrame), event_times_AVI);
    [ PETH_out{j}, trace_out{j} ] = make_PETH(PSAbool, LPtrace, event_frames, frame_buffer );
    
    % Set up and run shuffling
    num_frames = size(PSAbool,2);
    shuf_shifts = randperm(num_frames,num_shuffles);
    trace_shuffle{j} = [];
    for k = 1:num_shuffles
        PSAshift = circshift(PSAbool,shuf_shifts(k),2);
        LPshift = circshift(LPtrace,shuf_shifts(k),2);
        [~, temp] = make_PETH(PSAshift, LPshift, event_frames, frame_buffer);
        trace_shuffle{j} = cat(2,trace_shuffle{j},temp);
        
    end
    
end

%% Need to subtract shuffled trace from mean trace for each shuffle and quantify
% significant times as those that fall below zero less than 5% of the time
% 

alpha = 0.05; % Significance level
sig_sum = nan(num_objects,num_neurons,size(PETH_out{j},3));
for j = 1:num_objects
    for k = 1:num_neurons
        trace_use = squeeze(trace_out{j}(k,:,:));
        baseline = mean(trace_use,2);
        mean_trace = mean(trace_use - baseline,1);
        
        trace_diff = mean_trace - squeeze(trace_shuffle{j}(k,:,:)); % Subtrace shuffled traces from mean trace
        sig_sum(j,k,:) = sum(trace_diff > 0,1)/size(trace_shuffle{j},2) > (1-alpha); % Identify how many times the mean trace was above the shuffled trace

    end
end

%% Scroll through and plot for each neuron
if scroll_flag
    times_plot = (-frame_buffer:frame_buffer)/imageSR;
    
    figure
    
    n_out = 1;
    stay_in = true;
    while stay_in
        for k = 1:2
            subplot(2,1,k)
            trace_plot = squeeze(trace_out{k}(n_out,:,:));
            baseline = nanmean(trace_plot,2);
            mean_trace = nanmean(trace_plot - baseline,1);
            
            shuf_plot = squeeze(trace_shuffle{k}(n_out,:,:));
            baseline_shuf = nanmean(shuf_plot,2);
            mean_shuffle = nanmean(shuf_plot - baseline_shuf,1);
            
            plot(times_plot,(trace_plot - baseline),'r:');
            hold on
            plot(times_plot, mean_trace,'b');
            plot(times_plot, mean_shuffle,'k--')
            hold off
            xlabel('Time from object sample (s)')
            ylabel('Fluorescence (au)')
            title(['Neuron ' num2str(n_out) ' - Object ' num2str(k)])
            ylims(k,:) = get(gca,'YLim');
        end
        
        for k = 1:2
            subplot(2,1,k)
            ylim([min(ylims(:,1)), max(ylims(:,2))])
        end
        [n_out, stay_in] = LR_cycle(n_out, [1 num_neurons]);
        
    end
end
% 
end

%% Find frames of exploration and parse out ones that are continuous and within the frame buffer to only count the first one
function [frames_use] = get_event_frames(frames_in, thresh)
epochs = NP_FindSupraThresholdEpochs(diff(frames_in),thresh+eps,0);

ind_frames = [];
grouped_frames = [];
for j = 1:size(epochs,1)
    start_frame = epochs(j,1)+1;
    if j == 1 && start_frame == 2 % edge case
        start_frame = 1;
    elseif j == 1
    end
    end_frame = epochs(j,2);
    ind_frames = [ind_frames start_frame:end_frame]; %#ok<AGROW> % Get individual frames
    grouped_frames = [grouped_frames end_frame+1]; %#ok<AGROW> % Only grab the 1st frame when he is exploring it a bunch in a ros
end
frames_use = unique([1 grouped_frames ind_frames]); % Have to add in 1 to guarantee that it is counted

end
%% Make mean trace - baseline subtracted
function [mean_trace] = make_mean_trace(trace_in)
trace_use = squeeze(trace_in);
baseline = mean(trace_use,2);
mean_trace = mean(trace_use - baseline,1);
end

