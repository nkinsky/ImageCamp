function [ session_struct_full ] = complete_MD( session_struct )
% session_struct_full = complete_MD( session_struct )
%   Fills in partial MD sessions with all data in MakeMouseSessionList

%%
for j = 1:length(session_struct)
    [~,session_struct_full(j)] = ChangeDirectory(session_struct(j).Animal,...
        session_struct(j).Date,session_struct(j).Session,0);
end
%%
end

