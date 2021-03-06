function [ rect_crop_mos, rect_crop ] = mos_cropmovie_gui( movie_use)
% [ rect_crop_mos, rect_crop ] = mos_cropmovie_gui( movie_use)
%   Takes input movie and allows you to draw a cropping rectangle on top.
%   spits out:
%   rect_crop_mos in mosaic API rectangle coordinates format [left top right bottom] 
%   and rect_crop in MATLAB rectangle coordinates [xmin ymin width height]

crop1_ok = 'n';

disp('Crop movie with a rectangle')
while strcmpi(crop1_ok,'n')
   h = movie_use.view(); % This fuction may get removed from the API...
   rect_crop = getrect(h);
   figure(h);
   rectangle('Position', rect_crop);   
   crop1_ok = input('Is this ok? Type ''y'' if it is, ''n'' to redraw: ', 's');
   close(h);
end

% Deal rectangle to left, top, right, bot coordinates
left = rect_crop(1);
top = rect_crop(2) + rect_crop(4);
right = rect_crop(1) + rect_crop(3);
bottom = rect_crop(2);

rect_crop_mos = [left top right bottom];

end

