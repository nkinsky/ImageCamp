function [ session_struct_full ] = complete_MD( session_struct )
% session_struct_full = complete_MD( session_struct )
%   Fills in partial MD sessions with all data in MakeMouseSessionList. Can
%   accomodate structures with up to 2 dimensions currently

%%
for j = 1:size(session_struct,1)
    for k = 1:size(session_struct,2)
        [~,session_struct_full(j,k)] = ChangeDirectory(session_struct(j,k).Animal,...
            session_struct(j,k).Date,session_struct(j,k).Session,0); %#ok<*AGROW>
    end
end
%%
end

