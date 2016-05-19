function [ overlap_ratio, overlap_pixels, total_pixels, overlap_ratio2, overlap_ratio3 ] = reg_calc_overlap( ROIs1, ROIs2)
% [ ROI_overlap, overlap_pixels, total_pixels ] = reg_calc_overlap( ROIs1, ROIs2, neuron_map )
%
% Gets the overlap of neuron ROIs between two sessions that are mapped by
% neuron_map. ROIs2 must have already been mapped to ROIs1 using the 
% map_ROIs function.


% step through and get overlapping pixels for each neuron's ROI
overlap_ratio = nan(length(ROIs1),1);
overlap_pixels = nan(length(ROIs1),1);
total_pixels = nan(length(ROIs1),1);
overlap_ratio2 = nan(length(ROIs1),1);
overlap_ratio3 = nan(length(ROIs1),1);

%%
for j = 1:length(ROIs1)
    try
    overlap_pixels(j) = sum(ROIs1{j}(:) & ROIs2{j}(:));
    total_pixels(j) = sum(ROIs1{j}(:) | ROIs2{j}(:));
    overlap_ratio(j) = overlap_pixels(j)/total_pixels(j);
    overlap_ratio2(j) = max([min([1, overlap_pixels(j)/sum(ROIs1{j}(:))]), ...
        min([1, overlap_pixels(j)/sum(ROIs2{j}(:))])]);
    overlap_ratio3(j) = overlap_pixels(j)/sum(ROIs1{j}(:))*...
        overlap_pixels(j)/sum(ROIs2{j}(:));
    catch
        keyboard
    end
end

%%
end

