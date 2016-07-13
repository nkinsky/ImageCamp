function [overlap_ratio] = calc_PF_overlap(PF_cell_1, PF_cell_2)
% Calculates the overlap between the place fields in PF_cell_1 and
% PF_cell_2, where each entry is the placefield for a given neuron in
% session 1 and session 2.

if length(PF_cell_1) ~= length(PF_cell_2)
    error('PF_cell_1 and PF_cell_2 must be the same size across all dimensions')
end

overlap_ratio = nan(length(PF_cell_1),1);
for j = 1:length(PF_cell_1)
    try
        if isnan(sum(PF_cell_1{j}(:))) && isnan(sum(PF_cell_2{j}(:)))
            overlap_ratio(j) = nan;
        elseif isnan(sum(PF_cell_1{j}(:))) || isnan(sum(PF_cell_2{j}(:)))
            overlap_ratio(j) = 0;
        else
            total_pixels = sum(PF_cell_1{j}(:) | PF_cell_2{j}(:));
            overlap_pixels = sum(PF_cell_1{j}(:) & PF_cell_2{j}(:));
            overlap_ratio(j) = overlap_pixels/total_pixels;
        end
    catch
        keyboard
    end
end

end