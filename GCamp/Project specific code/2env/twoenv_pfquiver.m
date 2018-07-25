function [hq, ha] = twoenv_pfquiver(sesh1, sesh2, map_sesh, ha, gauss_bool, trans_bool)
% [hq, ha] = twoenv_pfquiver(sesh1, sesh2, map_sesh, ha)
%
%   Plot place field movements as a function of position in a quiver plot -
%   can look by eye for rotations, or rotations + translations
if nargin < 6
    trans_bool = false;
    if nargin < 5
        gauss_bool = true; % Use TMaps with gaussian smoothing and 1cm bins - false = unsmoothed and 4cm bins
        if nargin < 4
            figure;
            ha = gca;
        end
    end
end

if isempty(ha)
    figure; ha = gca;
end

if trans_bool
    load(fullfile(ChangeDirectory_NK(map_sesh,0),'batch_session_map_trans'));
elseif ~trans_bool
    load(fullfile(ChangeDirectory_NK(map_sesh,0),'batch_session_map'));
end

[~, PFrot_use] = arrayfun(@get_rot_from_db, sesh1);

if gauss_bool
    [~, delta_pos, pos1 ] = get_PF_angle_delta(sesh1, sesh2, batch_session_map, ...
        'TMap_gauss', 1, false, false, 0);
    
    load(fullfile(['Placefields_rot' num2str(PFrot_use) '.mat']), 'TMap_gauss')
    map_size = size(TMap_gauss{1}); % In MATLAB conventions, dim1 = y, dim2 = x
else
    [~, delta_pos, pos1 ] = get_PF_angle_delta(sesh1, sesh2, batch_session_map, ...
        'TMap_unsmoothed', 4, false, false, 0);
    
    load(fullfile(['Placefields_cm4_rot' num2str(PFrot_use) '.mat']), 'TMap_unsmoothed')
    map_size = size(TMap_unsmoothed{1}); % In MATLAB conventions, dim1 = y, dim2 = x
end
    

%%
delta_pos_mean = nan(map_size(1), map_size(2), 2);
pos1_all = nan(map_size(1), map_size(2), 2);
for j = 1:map_size(1)*map_size(2)
   [ybin_use, xbin_use] = ind2sub(map_size,j);
   inbin_bool = pos1(:,1) == xbin_use & pos1(:,2) == ybin_use;
   delta_pos_mean(ybin_use, xbin_use, 1) = nanmean(delta_pos(inbin_bool,1));
   delta_pos_mean(ybin_use, xbin_use, 2) = nanmean(delta_pos(inbin_bool,2));
   pos1_all(ybin_use, xbin_use,:) = [ybin_use, xbin_use];
    
end
pos1a = squeeze(pos1_all(:,:,1));
pos2a = squeeze(pos1_all(:,:,2));
delta_pos1a = squeeze(delta_pos_mean(:,:,1));
delta_pos2a = squeeze(delta_pos_mean(:,:,2));

axes(ha)
% hq = quiver(pos1a(:), map_size(1) - pos2a(:), delta_pos1a(:), delta_pos2a(:));
hq = quiver(pos1a(:), pos2a(:), delta_pos2a(:), delta_pos1a(:));
axis tight
axis off

end