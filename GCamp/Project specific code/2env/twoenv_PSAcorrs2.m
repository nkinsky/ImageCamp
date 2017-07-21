function [hcb] = twoenv_PSAcorrs2(Mouse_var, mouse_num, sesh1_ind, sesh2_ind, comp_type)
% twoenv_PSAcorrs2(Mouse_var, mouse_num, sesh1_ind, sesh2_ind)
%   Plots PSA/cell recruitment curves with correlations identified for each
%   neuron to look for potential time course of recruitment of coherent vs
%   non-coherent cells.  sesh1_ind must be less than sesh2_ind for within
%   circle or within square comparisons,  sesh1_ind must correspond to
%   square and sesh2_ind must correspond to circle for circ2square
%   comparisons

if strcmpi(comp_type,'circ2square')
    square_ind = [1 2 7 8 9 12 13 14];
    circ_ind = [3 4 5 6 10 11 15 16];
    sesh{1} = Mouse_var(mouse_num).sesh.(comp_type)(square_ind(sesh1_ind));
    sesh{2} = Mouse_var(mouse_num).sesh.(comp_type)(circ_ind(sesh2_ind));
else
    sesh{1} = Mouse_var(mouse_num).sesh.(comp_type)(sesh1_ind);
    sesh{2} = Mouse_var(mouse_num).sesh.(comp_type)(sesh2_ind);
end


corr_mat_use = Mouse_var(mouse_num).corr_mat.(comp_type);
if strcmpi(comp_type,'circ2square')
    corr_mat_use = twoenv_squeeze(corr_mat_use);
end

corrs_use = corr_mat_use{sesh1_ind,sesh2_ind};

figure
for j = 1:2
    hax = subplot(2,1,j);
    dir_use = ChangeDirectory_NK(sesh{j},0);
    load(fullfile(dir_use,'FinalOutput.mat'),'PSAbool');
    hcb(j) = twoenv_plot_PSAcorrs(PSAbool, corrs_use, hax);
    title([mouse_name_title(sesh{j}.Animal) ' - ' mouse_name_title(sesh{j}.Date) ...
        ' - session ' num2str(sesh{j}.Session)]);
end

end

