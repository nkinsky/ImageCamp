function [ struct_out ] = NO_obj_des_all( struct_in)
% struct_out = NO_obj_des_all( struct_in)
%   Designates which object (UR/LL) is object 1 and which is object 2 and
%   puts the appropriate frame numbers when the mouse is exploring each
%   into struct_out.  Also designates which occupancy bin (output by
%   preplot_mouse) is for which object based on a 3 x 4 occupancy grid.

num_sessions = length(struct_in);
struct_out = struct_in;

for j = 1:num_sessions
    if ischar(struct_in(j).handscore_file)
        load(struct_in(j).handscore_file);
        [struct_out(j).n1, struct_out(j).n2, struct_out(j).frames1, ...
            struct_out(j).frames2, struct_out(j).bin1,...
            struct_out(j).bin2] = NO_obj_des(struct_in(j), NOtracking);
    else
       struct_out(j).n1 = nan; struct_out(j).n2 = nan;
       struct_out(j).frames1 = nan; struct_out(j).frames2 = nan;
       struct_out(j).bin1 = nan; struct_out(j).bin2 = nan;
    end
end

end

