function [  ] = Tenaspis2_batch( session_struct, varargin )
% Tenaspis2_NK( session_struct )
% Runs Tenapsis2 with only one input - the MD variable for the sessions in
% question from MakeMouseSessionList
%
% same varargins as Tenaspis2_profile

%% Run it
for k = 1:length(session_struct)
    Tenaspis2_profile(session_struct(k).Animal,session_struct(k).Date,...
        session_struct(k).Session, varargin{:});
end


end

