function [ conn_filt_cell ] = twoenv_make_conn_filt( base_sesh, filt_type)
% conn_filt_cell = twoenv_make_conn_filt( base_sesh )
%   Spits out a cell containing only the appropriate cells specified in
%   filt_type for each session.



load(fullfile(ChangeDirectory_NK(base_sesh,0),'batch_session_map_trans.mat'));
batch_session_map = fix_batch_session_map(batch_session_map);
session = batch_session_map.session(9:12);
base_session = batch_session_map.session(1);

conn_filt_cell = cell(8,8);
% Square to circle day 5
filt_bool = twoenv_pairwise_filt(base_session, session(1), session(2),...
    'circ2square', filt_type);
[conn_filt_cell{1:4,1:4}] = deal(filt_bool);
% % Circle to square day 5
% filt_bool = twoenv_pairwise_filt(base_session, session(2), session(1),...
%     'circ2square', filt_type);
% [conn_filt_cell{[2,4],1:4}] = deal(filt_bool);
% Square 5 to circle 6
filt_bool = twoenv_pairwise_filt(base_session, session(1), session(3),...
    'circ2square', filt_type);
[conn_filt_cell{1:4,5:8}] = deal(filt_bool);
% % Circle 5 to square day 6
% filt_bool = twoenv_pairwise_filt(base_session, session(2), session(4),...
%     'circ2square', filt_type);
% [conn_filt_cell{[2,4],5:8}] = deal(filt_bool);

% Square to circle day 6
filt_bool = twoenv_pairwise_filt(base_session, session(4), session(3),...
    'circ2square', filt_type);
[conn_filt_cell{5:8,5:8}] = deal(filt_bool);
% % Circle to square day 6
% filt_bool = twoenv_pairwise_filt(base_session, session(3), session(4),...
%     'circ2square', filt_type);
% [conn_filt_cell{[5,7],5:8}] = deal(filt_bool);
% % Square 6 to circle 5
% filt_bool = twoenv_pairwise_filt(base_session, session(4), session(2),...
%     'circ2square', filt_type);
% [conn_filt_cell{[6,8],1:4}] = deal(filt_bool);
% % Circle 6 to square day 5
% filt_bool = twoenv_pairwise_filt(base_session, session(3), session(1),...
%     'circ2square', filt_type);
% [conn_filt_cell{[5,7],1:4}] = deal(filt_bool);

[conn_filt_cell{tril(true(8),-1)}] = deal([]);


end

