function [] = PFA_batch(session_struct,roomstr,progress_bar)
% PFA(session_struct, roomstr)
% 
% Batch place-field analysis wrapper function
%
% INPUTS
% session_struct - taken from MakeMouseSessionList, enter in the structure
% for the sessions you want to analyze
% roomstr is the name of the room e.g. '201a'
% progress bar = 1 is optional and will display a progress bar in lieu of
% spam to your screen for progress

if nargin < 3
    progress_bar = 0;
end

for j = 1:length(session_struct)
ChangeDirectory_NK(session_struct(j));

% Step 1: Calculate Placefields
disp(['Calculating Placefields for ' session_struct(j).Date ' session ' ...
    num2str(session_struct(j).Session) ])
CalculatePlacefields(roomstr,'progress_bar',progress_bar);

% Step 2: Calculate Placefield stats
disp(['Calculating Placefield Stats for ' session_struct(j).Date ' session ' ...
    num2str(session_struct(j).Session) ])
PFstats();

end

end

