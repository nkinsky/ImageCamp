% Alt: compare Will's function performance to hand calculated performance

perf_comp = [];
free_bool = [];
for m = 1:4
    sesh_use = alt_all_cell{m};
    [~, ~, ~, acclim_bool, forced_bool, perf_calc, perf_notes] = ...
        get_split_v_perf(sesh_use);
    perf_comp = [perf_comp; perf_calc, perf_notes];
    free_bool = [free_bool; ~acclim_bool' & ~forced_bool'];

end

free_bool = logical(free_bool);

%%
figure; set(gcf,'Position',[2250 240 890 640])
plot(100*perf_comp(free_bool,1), 100*perf_comp(free_bool,2), 'o')
hold on
plot([45 100], [45 100], 'r--')
xlim([45 100])
ylim([45 100])
xlabel('Performance by Will''s MATLAB functions (%)')
ylabel('Performance from Hand Notes (%)')