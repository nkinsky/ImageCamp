function [  ] = Tenaspis2_batch( session_struct )
% Tenaspis2_NK( session_struct )
% Runs Tenapsis2 with only one input - the MD variable for the sessions in
% question from MakeMouseSessionList

Tenaspis2(session_struct(1).Animal,session_struct(1).Date,...
    session_struct(1).Session);


end

