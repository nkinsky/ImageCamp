function [PETH_out, trace_out ] = NO_PETH(session, frame_buffer)
% [PETH_out, trace_out ] = NO_PETH(session, frame_buffer)
%   Plots a peri-event histogram for each neuron for each object.  Frame
%   buffer is the number of frames that you wish to
%   display before/after using the imaging sampling rate (20 fps).  
%   Default = 40 if not specified.

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
sesh_full = NO_obj_des_all(session);
obj_frames{1} = sesh_full.frames1; % Should have done this in the original function
obj_frames{2} = sesh_full.frames2;

%% Calculate PETHs
PETH_out = cell(1,2);
trace_out = cell(1,2);
for j = 1:2
    % Identify exploration epochs for the object
	event_frames_AVI = get_event_frames(obj_frames{j},frame_buffer(1)*aviSR/imageSR);
    event_times_AVI = obj_frames{j}(event_frames_AVI)/aviSR;
    event_frames = arrayfun(@(a) findclosest(a,aviFrame), event_times_AVI);
    [ PETH_out{j}, trace_out{j} ] = make_PETH(PSAbool, LPtrace, event_frames, frame_buffer );
    
end

%% Scroll through and plot for each neuron
times_plot = (-frame_buffer:frame_buffer)/imageSR;

figure

n_out = 1;
stay_in = true;
while stay_in
    for k = 1:2
        subplot(2,1,k)
        trace_plot = squeeze(trace_out{k}(n_out,:,:));
        baseline = mean(trace_plot,2);
        mean_trace = mean(trace_plot - baseline,1);
        plot(times_plot,(trace_plot - baseline),'r:');
        hold on
        plot(times_plot, mean_trace,'k');
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

