function [ output_args ] = set_same_clim( h, sub, sub_ind )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% h = handle
% sub = size of subplots (e.g. 2x2,2x3)
% sub_ind = indices of subplots to change

for j = 1:length(sub_ind)
    subplot(sub(1), sub(2), sub_ind(j));
    cax(j,:) = caxis;
    
end

cmin = min(cax(:)); cmax = max(cax(:));

for j = 1:length(sub_ind)
    subplot(sub(1), sub(2), sub_ind(j));
    caxis([cmin cmax]);
    
end



end

