function [ cell_rotate ] = cell_rotate( cell_array, degrees)
%UNTITLED Rotates or flips a cell - degrees is either 90, -90, or 180
%(right hand rule so -90 = CW, 90 = CCW)

temp = cell(size(cell_array));
if degrees == 90
    temp = cell_array';
    cell_rotate = flipud(temp);
elseif degrees == -90
    temp = flipud(cell_array);
    cell_rotate = temp';
elseif degrees == 180
    temp = flipud(cell_array);
    cell_rotate = fliplr(temp);
else
    error('degrees can only be entered as -90, 90, or 180')
end


end

