function [] = scroll_tiff_frames(tstack_in, start_frame)
% Lets you scroll through frames in a tiffstack (read in by TIFFstack)
% start frame indicates where to start. Must pre-load tstack_in
%   Detailed explanation goes here

hf = figure;
nrange = [1, size(tstack_in,3)];
stay_in = true;
n_out = start_frame;
while stay_in
    imagesc_gray(squeeze(tstack_in(:,:,n_out)));
    title(['Frame ' num2str(n_out)]);
    [n_out, stay_in] = LR_cycle(n_out, nrange);
    
end

end

