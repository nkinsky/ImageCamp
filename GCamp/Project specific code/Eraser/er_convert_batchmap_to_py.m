function [] = er_convert_batchmap_to_py(mouse)
% er_convert_batchmap_to_py(mouse)
%   Converts a batch_session_map to separate variables so that they can be
%   imported into python without pulling your hair out. Should only have to
%   be used by Nat once after he fixes all the registrations.

%
[MD, ~, ref2] = MakeMouseSessionListEraser('Nat');

% Change to open field day 1 directory
base_dir = ChangeDirectory_NK(MD(ref2{strcmpi(mouse, ref2(:,1)),2}));

% Load batch_session_map
load(fullfile(base_dir, 'batch_session_map.mat'),'batch_session_map')

% Break into separate files
map = batch_session_map.map; session = batch_session_map.session;

% Now save in a *more* python friendly format
save(fullfile(base_dir, 'batch_session_map_py.mat'), 'map', 'session')

end