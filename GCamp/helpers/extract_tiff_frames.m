function extract_tiff_frames( tiff_file_in, varargin )
% extract_tiff_frames( tiffstack_in,... )
%  Takes a tiffstack movie and either temporally downsamples it by an
%  integer value (...'downsample',4), or grabs a custom set of frames
%  (...'custom', frame_list_array).

ip = inputParser;
ip.addRequired('tiff_file_in', @ischar);
ip.addParameter('downsample', nan, @(a) isnan(a) || a > 0 && round(a) == a);
ip.addParameter('custom', nan, @(a) isnan(a) || isnumeric(a));
ip.parse(tiff_file_in, varargin{:});
downsample = ip.results.downsample;
custom = ip.results.custom;

tstack = 
if isnan(downsample) && isnan(custom)
    error('Must specifiy either ''downsample'' or ''custom'' parameters')
elseif ~isnan(downsample) && isnan(custom)
    frames_grab = 1:downsample:
elseif ~isnan(downsample) && ~isnan(custom)
    error('Cannot specifiy both ''downsample'' and ''custom'' parameters')
end

[dir, fname, ext] = fileparts(tiff_file_in);



imwrite(im1,'myMultipageFile.tif')
imwrite(im2,'myMultipageFile.tif','WriteMode','append')


end

