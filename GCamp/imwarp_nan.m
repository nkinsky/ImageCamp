function [ frame_use ] = imwarp_nan( frame_use, tform, base_ref )
% frame_use = imwarp_nan( frame_use, tform, base_ref )
%   Dare-bones function to take imwarp and apply it, but spit out an nan
%   filled array if the input is nans
nan_frame_use = ones(base_ref.ImageSize)*nan;
if ~isnan(sum(frame_use(:)))
    frame_use = imwarp(frame_use,tform,'OutputView',...
        base_ref,'InterpolationMethod','nearest');
else
    frame_use = nan_frame_use;
end

end

