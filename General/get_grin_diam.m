function [ ] = get_grin_diam( image_file )
% Function to get diameter of grin lens in

keyboard

pixel_move = 10;
%% Load Files
if nargin == 0
    [image_fname image_pname findex] = uigetfile('*.tif','Please select a TIF file');
    image_file = [image_pname image_fname];
end
brain_image = im2double(imread(image_file));


h_brain = figure;
imagesc(brain_image); colormap(gray);
    
rad = input('Please enter radius of circle to use in pixels: ');
xc = input('Enter x coordinate for circle center: ');
yc = input('Enter y coordinate for circle center: ');
adj_mode = [];

%% Match up diameter
ok = 'n';
while ~strcmpi(ok,'y')
    figure(h_brain)
    imagesc(brain_image); colormap(gray);
    plotcirc_pix(h_brain, xc, yc, rad);
    
    if isempty(adj_mode)
    adj_mode = input('Enter "c" to adjust circle center, enter "r" to adjust radius, or "y" when done: ','s');
    elseif strcmpi(adj_mode,'y')
        ok = 'y';
    elseif strcmpi(adj_mode,'c')
        disp('Use arrow keys to adjust circle center.  Hit "r" to adjust radius, "p" to adjust # pixels moved, "y" when done.')
        [a b button] = ginput(1);
        switch button
            case 30 % Up
                yc = yc - pixel_move; % This is backwards due to MATLAB weirdness
                disp('Move up 1 pixel')
            case 31 % Down
                yc = yc + pixel_move;
                disp ('Move down 1 pixel')
            case 28 % Left
                xc = xc - pixel_move;
                disp('Move left 1 pixel')
            case 29 % Right
                xc = xc + pixel_move;
                disp('Move right 1 pixel')
            case {50 52 54 56}
                disp ('Use arrow keys, not number keys')
            case 114 % Letter r 
                adj_mode = 'r';
            case 112 % Letter p
                pixel_move = input('Please input number of pixels to move with each button push: ');
            case 121 % 
                ok = 'y';
%                 adj_mode = 'y';
            otherwise
        end
    elseif strcmpi(adj_mode,'r')
        rad = input('Enter the radius to use in pixels: ');
        while isempty(rad)
            rad = input('Key press error.  Try again: ');
        end
        adj_mode = [];
    end
        
%     ok = input('Is this ok? (y/n): ','s');
%     if strcmpi(ok,'n')
%         coords = input('Input new xc, yc, and rad ([ xc yc rad]) :');
%     end
%     xc = coords(1); yc = coords(2); rad = coords(3);
end

[filepath filename ext] = fileparts(image_file);
d = date;

save( [filepath '\GrinRadiusData.mat'], 'filepath', 'filename', 'd','xc', 'yc', 'rad')

keyboard
end

