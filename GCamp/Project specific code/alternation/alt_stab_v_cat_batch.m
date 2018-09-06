function [ stay_prop_all, coactive_prop_all, cat_names ] = ...
    alt_stab_v_cat_batch(day_lag, comp_type, mice_sesh, PFname )
%  [stay_prop, coactive_prop, cat_names ] = alt_stab_v_cat_batch(...
%       day_lag, comp_type, mouse1, mouse2,... )
%   Batch function for getting splitter stability for all mice at the
%   specified day lag. Comp_type = 'exact' only calculates metrics for that
%   exact day lag, 'le' calculates metrics for all sessions <= day_lag
%   apart.
%   mice_sesh = data structure with all sessions for one mouse OR cell
%   containing data structure for each mouse for combined plotting
%   color_mice parameter set to true (default) colors each mouse's data
%   point separately, false plots all in black

if nargin < 4
    PFname = 'Placefields.mat';
end

% Deal out mice_sesh into appropriate variable (must be a cell)
if iscell(mice_sesh)
    num_mice = length(mice_sesh);
elseif isstruct(mice_sesh)
    num_mice = 1;
    temp = mice_sesh; 
    clear mice_sesh
    mice_sesh{1} = temp;
end

switch comp_type
    case 'exact'
        compfun = @eq;
    case 'le'
        compfun = @le;
    otherwise
        error('Must specify either ''exact'' or ''le'' for 2nd arg')
end

%% Get day lag between all sessions
tdiff_cell = cell(num_mice,1);
good_seshs = cell(num_mice,1);
for j = 1:num_mice
   tdiff_cell{j} = make_timediff_mat(mice_sesh{j});
   % ID sessions that are exactly day_lag apart (or <= if 'le' specified)
   tdiff_bool = feval(compfun, tdiff_cell{j}, day_lag);
   % Get hand_check_mat to grab only good sessions
   [~, good_reg_mat_hand] = alt_hand_reg_order_check(mice_sesh{j});
   % reject any sessions not meeting the hand check
   tdiff_bool(good_reg_mat_hand == 0) = false;
   [a,b] = find(tdiff_bool);
   good_seshs{j} = [a,b];
end

%% Run alt_stability_v_cat
stay_prop_all = cell(num_mice,1);
coactive_prop_all = cell(num_mice,1);
for j = 1:num_mice
    seshs_use = good_seshs{j};
    sesh_temp = mice_sesh{j};
    for k = 1:size(seshs_use,1)
        [~, stay_prop, coactive_prop, cat_names] = alt_stability_v_cat(...
            sesh_temp(seshs_use(k,1)), sesh_temp(seshs_use(k,2)), ...
            'plot_flag', false, 'PFname', PFname);
        stay_prop_all{j} = cat(1,stay_prop_all{j},stay_prop);
        coactive_prop_all{j} = cat(1,coactive_prop_all{j},coactive_prop);
    end
end


end

