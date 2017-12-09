function [ session_struct_out ] = add_workdir( session_struct )
% session_struct_out = add_dirstr( session_struct )
%   Adds the working directory into a data structure for that session as
%   .dirstr.

session_struct_out = session_struct;
for j = 1:length(session_struct)
    dirstr = ChangeDirectory(session_struct(j).Animal,session_struct(j).Date,...
        session_struct(j).Session,0);
    session_struct_out(j).dirstr = dirstr;
    session_struct_out(j).Location = dirstr;
end
end

