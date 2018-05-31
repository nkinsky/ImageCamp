function [ ROIs, ROIweighted ] = cnmf_makeROIs(A,Cn)
% [ ROIs, ROIweighted ] = cnmf_makeROIs(A,Cn)
%  Make ROI masks for all neurons identified in results.A from CNMF_E
%  output.

% Get number of neurons and size of imaging window
num_neurons = size(A,2);
[pix1, pix2] = size(Cn);

% Pre-allocate
ROIs = cell(1,num_neurons); ROIweighted = cell(1,num_neurons);
[ROIs{:}] = deal(false(pix1,pix2));
[ROIweighted{:}] = deal(zeros(pix1,pix2));

for j = 1:num_neurons
   mask_ind = A(:,j);
   ROIind = mask_ind ~= 0;
   ROIs{j}(ROIind) = true;
   ROIweighted{j}(ROIind) = mask_ind(ROIind);
   
end


end

