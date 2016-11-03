function [ epoch_mean, epoch_z, frames_use ] = DNMP_PVrough( FT, frames, frame_type)
% [ epoch_mean, epoch_z ] = DNMP_PV( FT, frames, frame_type)
%   spits out a rough PV based on the epochs designated in frames,
%   frame_type = 1 enter frames to exclude, 2 = frames to include.  If 2,
%   you can enter either a logical or actual frame numbers.

if frame_type == 1
    [~, frames_use] = exc_to_inc(frames,size(FT,2));
elseif frame_type == 2
    frames_use = frames;
end

PV_mean = mean(FT,2);
PV_std = std(FT,1,2);

epoch_mean = mean(FT(:,frames_use),2);
epoch_z = (epoch_mean-PV_mean)./PV_std;

end

