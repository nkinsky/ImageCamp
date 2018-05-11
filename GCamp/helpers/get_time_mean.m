function [ mean_pix_by_frame ] = get_time_mean( tiffmoviefile )
% mean_pix_by_frame = get_time_mean( tiffmoviefile )
%   Get the mean value of all pixels at each frame. TIFF only thus far.

tstack = TIFFStack(tiffmoviefile);
nframes = size(tstack,3);
mean_pix_by_frame = nan(1,nframes);

resol = 1; % Percent resolution for progress bar, in this case 10%
p = ProgressBar(100/resol);
update_inc = round(nframes/(100/resol)); % Get increments for updating ProgressBar
parfor j = 1:nframes 
    mean_pix_by_frame(j) = mean(mean(tstack(:,:,j))); 
    if round(j/update_inc) == (j/update_inc)
        p.progress; %#ok<PFBNS> % Also percent = p.progress;
    end
end


end

