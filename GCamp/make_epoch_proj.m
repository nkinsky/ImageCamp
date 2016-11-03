function [ epoch_mean_proj, epoch_z_proj ] = make_epoch_proj( h5file, frames, varargin )
% [ epoch_mean_proj, epoch_z_proj ] = make_epoch_proj( h5file, frames, varargin )
%   Makes mean projection and z projection (if mean_frame and std_frame for
%   the whole session are provided) for the epochs provided in frames

%% Parse Inputs
p = inputParser;
p.KeepUnmatched = true;
p.addRequired('h5file',@(x) exist(x,'file'));
p.addRequired('frames',@(x) isnumeric(x));
p.addParameter('mean_frame', 0);
p.addParameter('std_frame', 0);
p.parse(h5file, frames, varargin{:});                
    
%Compile.
mean_frame = p.Results.mean_frame;
std_frame = p.Results.std_frame;

%% Make mean projection for epochs in frames
info = h5info(h5file,'/Object');

epochs = find_epochs(frames); % Get epochs of consecutive frames
epoch_sum = zeros(info.Dataspace.Size(1:2)); % Pre-allocate

% Get sum of pixel intensities for each epoch in frames
for j = 1:size(epochs,2)
    epoch_frames = epochs(j,1):epochs(j,2);
    num_frames = length(epoch_frames);
    temp = make_mean_frame(h5file,epoch_frames);
    epoch_sum = epoch_sum + temp*num_frames;
end
epoch_mean_proj = epoch_sum/length(frames); % Get mean from sum

% Get z-scored pixel intensity projection
if mean_frame ~= 0
    epoch_z_proj = (epoch_mean_proj - mean_frame)./std_frame;
else
    epoch_z_proj = nan;
end


end

