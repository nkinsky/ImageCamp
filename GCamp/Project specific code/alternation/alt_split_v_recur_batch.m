function [h] = alt_split_v_recur_batch(day_lag, comp_type, mice_sesh )
% h = alt_split_v_recur_batch(day_lag, comp_type, mice_sesh )
%   Plot various metrics of cell stability vs various metrics of
%   "splittiness" for all cells 

rely_edges = 0:0.025:1; 
delta_edges = 0:0.05:1;

nbins_rely = length(rely_edges) - 1;
nbins_delta = length(delta_edges) - 1;

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
   % ID sessions that are day_lag apart 
   tdiff_bool = feval(compfun, tdiff_cell{j}, day_lag);
   [a,b] = find(tdiff_bool);
   good_seshs{j} = [a,b];
end
num_sesh = max(cellfun(@(a) size(a,1),good_seshs));
%% Run alt_stability_v_cat
pco_v_rely_all = nan(num_mice,num_sesh,nbins_rely);
pstaybec_v_rely_all = nan(num_mice,num_sesh,nbins_rely); 
pco_v_delta_all = nan(num_mice,num_sesh,nbins_delta);
pstaybec_v_delta_all = nan(num_mice,num_sesh,nbins_delta);
rely_bin_bool_all = false(num_mice,num_sesh,nbins_rely);
delta_bin_bool_all = false(num_mice,num_sesh,nbins_delta);
for j = 1:num_mice
    seshs_use = good_seshs{j};
    sesh_temp = mice_sesh{j};
    for k = 1:size(seshs_use,1)
        [pco_v_rely_all(j,k,:), pstaybec_v_rely_all(j,k,:), ...
            pco_v_delta_all(j,k,:), pstaybec_v_delta_all(j,k,:), rely_centers, ...
            delta_centers, rely_bin_bool_all(j,k,:), delta_bin_bool_all(j,k,:)] = ...
            plot_split_v_recur(sesh_temp(seshs_use(k,1)), ...
            sesh_temp(seshs_use(k,2)),'plot_flag', false, ...
            'rely_edges', rely_edges, 'delta_edges', delta_edges);
    end

end

rely_centers_all = shiftdim(repmat(rely_centers,num_sesh,1,num_mice),2);
delta_centers_all = shiftdim(repmat(delta_centers,num_sesh,1,num_mice),2);
%% Plot everything
if strcmpi(comp_type,'exact')
    comp_str = 'exactly';
elseif strcmpi(comp_type,'le')
    comp_str = '<=';
end

h = figure;
h.Position = [2200 60 1080 820];

subplot(2,2,1)
scatter(rely_centers_all(rely_bin_bool_all), pco_v_rely_all(rely_bin_bool_all));
xlabel('Stem splitter reliability (1-p)');
ylabel('Reactivation prob');
[r_co_rely, pval_co_rely] = corr(rely_centers_all(rely_bin_bool_all),...
    pco_v_rely_all(rely_bin_bool_all),'type','Spearman');
xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
text(xlims(1)+0.025, ylims(2)-0.1, ['r = ' num2str(r_co_rely,'%0.2f')])
text(xlims(1)+0.025, ylims(2)-0.15, ['p = ' num2str(pval_co_rely,'%0.2d')])
title(['Sessions ' comp_str ' ' num2str(day_lag) 'day(s) apart'])

subplot(2,2,2)
scatter(rely_centers_all(rely_bin_bool_all), pstaybec_v_rely_all(rely_bin_bool_all))
xlabel('Stem splitter reliability (1-p)');
ylabel('Stay/Become splitter prob.');
[r_sb_rely, pval_sb_rely] = corr(rely_centers_all(rely_bin_bool_all),...
    pstaybec_v_rely_all(rely_bin_bool_all),'type','Spearman');
xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
text(xlims(1)+0.025, ylims(2)-0.1, ['r = ' num2str(r_sb_rely,'%0.2f')])
text(xlims(1)+0.025, ylims(2)-0.15, ['p = ' num2str(pval_sb_rely,'%0.2d')])

subplot(2,2,3)
scatter(delta_centers_all(delta_bin_bool_all), pco_v_delta_all(delta_bin_bool_all))
xlabel('Stem splitter \Delta_{max}');
ylabel('Reactivation prob');
[r_co_delta, pval_co_delta] = corr(delta_centers_all(delta_bin_bool_all),...
    pco_v_delta_all(delta_bin_bool_all),'type','Spearman');
xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
text(xlims(1)+0.025, ylims(2)-0.1, ['r = ' num2str(r_co_delta,'%0.2f')])
text(xlims(1)+0.025, ylims(2)-0.15, ['p = ' num2str(pval_co_delta,'%0.2d')])

subplot(2,2,4)
scatter(delta_centers_all(delta_bin_bool_all), pstaybec_v_delta_all(delta_bin_bool_all))
xlabel('Stem splitter \Delta_{max}');
ylabel('Stay/Become splitter prob.');
[r_sb_delta, pval_sb_delta] = corr(delta_centers_all(delta_bin_bool_all),...
    pstaybec_v_delta_all(delta_bin_bool_all),'type','Spearman');
xlims = get(gca,'XLim'); ylims = get(gca,'YLim');
text(xlims(1)+0.025, ylims(2)-0.1, ['r = ' num2str(r_sb_delta,'%0.2f')])
text(xlims(1)+0.025, ylims(2)-0.15, ['p = ' num2str(pval_sb_delta,'%0.2d')])

end

