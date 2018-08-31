function [good_bool, good_reg_mat_hand] = alt_hand_reg_order_check(sessions)
% [good_bool, good_reg_mat_hand] = alt_hand_reg_order_check(sessions)
%   Check to make sure good_reg_mat_hand matches the sessions you input!
%   Could later be adjusted to only include some sessions by either making
%   a new hand_reg file or limiting the input sessions.

load(fullfile(sessions(1).Location, 'good_reg_mat_hand')); %#ok<LOAD>
sesh_order = arrayfun(@(a) [a.Date '_s' num2str(a.Session)],...
    sessions,'UniformOutput', false);
mat_order = cellfun(@(a,b) [a '_s' num2str(b)], reg_mat_hand_date, ...
    mat2cell(reg_mat_hand_sesh, size(reg_mat_hand_sesh,1), ...
    ones(1,size(reg_mat_hand_sesh,2))),'UniformOutput', false);
mat_order = cellfun(@(a) regexprep(a,'/','_'), mat_order,'UniformOutput', ...
    false); % Replace / with _
mat_order = cellfun(@(a) regexprep(a,'_\d?_',['_0' a(regexp(a,'_\d?_')+1) '_']), ...
    mat_order, 'UniformOutput', false); % Make sure any single digits get a 0 in front of them
good_bool = all(cellfun(@(a,b) strcmpi(a,b), sesh_order, mat_order)); 

end

