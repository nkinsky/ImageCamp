function [ pos_log ] = Pos_same( posdir1, posdir2, use_pos_align )
% pos_log = Pos_same( posdir1, posdir2 )
%   Checks if the variables in posdir1 and posdir2 are the same or
%   different. Looks at either Pos.mat or Pos_align.mat

if ~use_pos_align
    load(fullfile(posdir1,'Pos_align.mat'),'x_adj_cm'); x1 = x_adj_cm;
    load(fullfile(posdir2,'Pos_align.mat'),'x_adj_cm'); x2 = x_adj_cm;
elseif use_pos_align
    load(fullfile(posdir1,'Pos.mat'),'xpos_interp'); x1 = xpos_interp;
    load(fullfile(posdir2,'Pos.mat'),'xpos_interp'); x2 = xpos_interp;
end

if length(x1) ~= length(x2)
    pos_log = false;
else
    pos_log = sum(x1 == x2) == length(x1);
end

end

