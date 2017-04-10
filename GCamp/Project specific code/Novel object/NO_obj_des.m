function [ n1, n2, frames1, frames2, bin1, bin2 ] = NO_obj_des( struct_in, NOtracking)
% [struct_out ] = NO_obj_des( struct_in, NOtracking)
%   Adds in total number frames exploring object 1 and object 2, as well as
%   frame numbers when exploring each object to struct_in and inserts them
%   into struct_out.  Must designate .Obj1 and .Obj2 in struct_in as either
%   'LL' or 'UR';

struct_out = struct_in;

obj_name{1} = struct_in.Obj1;
obj_name{2} = struct_in.Obj2;

n_name = {'n1', 'n2'};
f_name = {'frames1', 'frames2'};
occ_name = {'bin1', 'bin2'};
for j = 1:2
    if strcmp(obj_name{j}, 'LL')
        struct_out.(n_name{j}) = NOtracking.nLL;
        struct_out.(f_name{j}) = NOtracking.LLframes;
        struct_out.(occ_name{j}) = 1;
    elseif strcmp(obj_name{j}, 'UR')
        struct_out.(n_name{j}) = NOtracking.nUR;
        struct_out.(f_name{j}) = NOtracking.URframes;
        struct_out.(occ_name{j}) = 12;
    else
        struct_out.(n_name{j}) = 'error';
        struct_out.(f_name{j}) = 'error';
    end
end

n1 = struct_out.n1;
n2 = struct_out.n2;
frames1 = struct_out.frames1;
frames2 = struct_out.frames2;
bin1 = struct_out.bin1;
bin2 = struct_out.bin2;
end

