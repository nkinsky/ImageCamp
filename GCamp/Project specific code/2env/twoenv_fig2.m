% 2env Figure 2

%% Square coherency plot - need to add in sig_star and sig_value info
[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(G31_square([6 7]),'square',...
    'num_shuffles', 1000, 'local_ref', false, 'map_session', G31_square(1));
arrayfun(@(a) set(a, 'Position', [2204 192 1226 703]), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);

%% Circle coherency plot
[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(G31_square(1:2),'square',...
    'num_shuffles', 1000, 'local_ref', true);
arrayfun(@(a) set(a, 'Position', [2204 192 1226 703]), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);

%% Circ2square coherency plot
[~, ~, ~, ~, ~, ~, hh] = twoenv_rot_analysis_full(G31_square(1:2),'square',...
    'num_shuffles', 1000, 'local_ref', true);
arrayfun(@(a) set(a, 'Position', [2204 192 1226 703]), hh);
arrayfun(@make_figure_pretty, hh,'UniformOutput',false);
