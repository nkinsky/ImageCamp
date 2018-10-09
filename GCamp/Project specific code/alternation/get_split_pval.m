function [psplit, pPF] = get_split_pval(session1, session2)
%  [psplit, pPF] = get_split_pval(session1, session2)
%   Gets p-values for delta_tuningcurves for splitters and all placefields
%   between sessions, based on shuffled values (shuffle stem cells only for
%   splitter p-value, shuffle all cells for place field p-value)

%% Get correlations
savename = ['split_corrs - ' session1.Date 's' num2str(session1.Session) ...
    'to ' session2.Date 's' num2str(session2.Session) '.mat'];
file1 = fullfile(session1.Location, savename);
file2 = fullfile(session1.Location, savename);

if exist(file1, 'file') || exist(file2, 'file')
    if exist(file1, 'file')
        load(file1) %#ok<*LOAD>
    elseif exist(file2, 'file')
        load(file2)
    end
elseif ~exist(file1, 'file') && ~exist(file2, 'file')
    num_shuffles = 1000;
    [deltacurve_corr, PFcorr, deltacurve_corr_shuf, PFcorr_shuf, ~]...
        = split_tuning_corr(session1, session2, 'num_shuffles',...
        num_shuffles, 'suppress_output', true);
end

if num_shuffles ~= 1000
    error('You aren''t using 1000 shuffles for this calculation!!!')
end

%% Calculate p-values

pPF = sum((nanmean(PFcorr) < nanmean(PFcorr_shuf,1)))/num_shuffles;
psplit = sum((nanmean(deltacurve_corr) < ...
    nanmean(deltacurve_corr_shuf,1)))/num_shuffles;


end

