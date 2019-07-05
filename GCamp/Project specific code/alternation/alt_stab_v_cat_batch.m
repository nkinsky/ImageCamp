function [ stay_prop_all, coactive_prop_all, cat_names, ncoactive_all , ntrials1_all] = ...
    alt_stab_v_cat_batch(day_lag, comp_type, mice_sesh, PFname, matchER, trial_type )
%  [stay_prop, coactive_prop, cat_names ] = alt_stab_v_cat_batch(...
%       day_lag, comp_type, mouse1, mouse2,... )
%   Batch function for getting splitter stability for all mice at the
%   specified day lag.
%
%   Comp_type = 'exact' only calculates metrics for that
%   exact day lag, 'le' calculates metrics for all sessions <= day_lag
%   apart.
%
%   mice_sesh = data structure with all sessions for one mouse OR cell
%   containing data structure for each mouse for combined plotting
%   color_mice parameter set to true (default) colors each mouse's data
%   point separately, false plots all in black
%
%   PFname = Placefields file name. default = Placefields_cm1.mat
%
%   match_ER: set to true to roughly match median event rates between all
%   groups of neurons. default = false
%
%   trial_type: types of trials to compare. 'free_only' (default),
%   'forced_only', 'all'

if nargin < 6
    trial_type = 'free_only';
    if nargin < 5
        matchER = false; % Don't match event-rates between splitters and other cells by default
        if nargin < 4
            PFname = 'Placefields_cm1.mat';
        end
    end
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

%% Get appropriate trial types and create boolean for selecting them in next step
for j = 1:num_mice
    [loop_bool, forced_bool] = alt_id_sesh_type(mice_sesh{j});
    if ismember(trial_type, {'all', 'forced_only', 'free_only', 'no_loop'})
        switch trial_type
            case 'all'
                good_bool{j} = true(size(loop_bool));
            case 'forced_only'
                good_bool{j} = forced_bool;
            case 'free_only'
                good_bool{j} = ~forced_bool & ~loop_bool;
            case 'no_loop'
                good_bool{j} = ~loop_bool;
            otherwise
                error('comp_type variable value is invalid')
        end
    end
end

%% Get day lag between all sessions
tdiff_cell = cell(num_mice,1);
good_seshs = cell(num_mice,1);
for j = 1:num_mice
   tdiff_cell{j} = make_timediff_mat(mice_sesh{j});
   % ID sessions that are exactly day_lag apart (or <= if 'le' specified)
   tdiff_bool = feval(compfun, tdiff_cell{j}, day_lag);
   % Make sure you only include the appropriate session types
   tdiff_bool = tdiff_bool & good_bool{j}.*good_bool{j}';
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
ncoactive_all = cell(num_mice, 1);
ntrials1_all = cell(num_mice, 1);
cat_names = [];
for j = 1:num_mice
    seshs_use = good_seshs{j};
    sesh_temp = mice_sesh{j};
    for k = 1:size(seshs_use,1)
        [~, stay_prop, coactive_prop, cat_names, coactive_bool] = ...
            alt_stability_v_cat(...
            sesh_temp(seshs_use(k,1)), sesh_temp(seshs_use(k,2)), ...
            'plot_flag', false, 'PFname', PFname, 'matchER', matchER);
        stay_prop_all{j} = cat(1,stay_prop_all{j},stay_prop);
        coactive_prop_all{j} = cat(1,coactive_prop_all{j}, coactive_prop);
        ncoactive_all{j} = cat(1, ncoactive_all{j}, sum(coactive_bool));
        
        % Get # trials here
        ntrials1 = alt_get_ntrials(sesh_temp(seshs_use(k,1)));
        ntrials1_all{j} = cat(1, ntrials1_all{j}, ntrials1);
%         if any(stay_prop == 1)
%             keyboard
%         end
    end
end


end

