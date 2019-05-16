function [bad_frames] = scroll_tiff_frames(tstack_in, start_frame)
% scroll_tiff_frames(tstack_in, start_frame)
%
% Lets you scroll through frames in a tiffstack (read in by TIFFstack)
% start frame indicates where to start. Must pre-load tstack_in

if nargin < 2
    start_frame = 1;
end

hf = figure;
set(hf,'Position', [440 280 610 500]);
nrange = [1, size(tstack_in,3)];
stay_in = true;
n_out = start_frame;
disp('Use L/R keys to scroll. hit B to log a bad frame!')
bad_frames = [];
while stay_in
    imagesc(squeeze(tstack_in(:,:,n_out)));
    colormap(gray);
    title(['Frame ' num2str(n_out)]);
    [n_out, stay_in, ~, ~, button] = LR_cycle(n_out, nrange);

    if button == 98 %98 = b
       bad_frames = [bad_frames, n_out]; %#ok<AGROW>
    end
    
end

end

