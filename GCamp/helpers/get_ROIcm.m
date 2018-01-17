function [ cmx, cmy, error_code ] = get_ROIcm( ROIin )
% [ cmx, cmy, error_code ] = get_ROIcm(ROIbool )
%   Calculates center-of-mass of ROIin (must be 2d boolean or 0s/1s).
%   Output is x and y position of the neuron ROI and an error code: 0 = all
%   good, 1 = size zero neuron detected (most likely due to registering an
%   ROI near the edge to some other session), 2 = multiple blobs for ROI
%   detected with the largest one chosen, and 3 = multiple blobs for ROI
%   and none meet the area threshold

stats = regionprops(ROIin,'Centroid');

if size(stats,1) == 0 % If registered neuron disappears, dump it to 0,0
    %     disp([' Size zero neuron detected.  See neuron # ' num2str(j)])
    cmx = 0;
    cmy = 0;
    error_code = 1;
elseif size(stats,1) == 1 % Normal case
    cmx = stats.Centroid(1);
    cmy = stats.Centroid(2);
    error_code = 0;
else % If multiple blobs are present for a neuron, only use the largest one
    temp4 = regionprops(ROIin,'ConvexArea');
    sizes = arrayfun(@(a) a.ConvexArea,temp4);
    blob_use = max(sizes) == sizes;
    % Size limitation here - must be bigger than 50 pixels
    try
        if length(blob_use) > 1 || max(sizes) < 50
            %             disp(['MULTIPLE BLOBS AND/OR SMALL SIZE OF NEURON ' num2str(j) ...
            %                 ' DETECTED.'])
            cmx = 0; cmy = 0;
            error_code = 3;
        else
            cmx = stats(blob_use).Centroid(1);
            cmy = stats(blob_use).Centroid(2);
            error_code = 2;
        end
    catch
        cmx = 0; cmy = 0;
        error_code = 3;
    end
    
end



end

