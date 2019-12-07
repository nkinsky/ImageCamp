function [fmin_mean, fmean_mean, fmincrop_mean, fmeancrop_mean] = ...
    get_baseline_fluor(session, crop_percent)
%   [fmin_mean, fmean_mean, fmincrop_mean, fmeancrop_mean] = ...
%     get_baseline_fluor(session, crop_percent)
%
%   Get mean flourescence of minimum and mean (if possible) projection.
%   Also spits out values with crop_percent at each edge 
%   removed to make sure you aren't including any edge values that could 
%   artifically drive values down?

if nargin < 2
    crop_percent = 10;
end
crop_ratio = crop_percent/100;

fmin_mean = nan;
fmean_mean = nan;
if ~isempty(session.Location)
    try
        % Whole image mean
        minproj = imread(fullfile(session.Location,'ICmovie_min_proj.tif'));
        fmin_mean = double(mean(minproj(:)));

        
        % Cropped mean
        [ydim, xdim] = size(minproj);
        minproj_crop = minproj(round(ydim*crop_ratio):round(ydim*(1-crop_ratio)), ...
            round(xdim*crop_ratio):round(xdim*(1-crop_ratio)));
        fmincrop_mean = mean(minproj_crop(:));
    catch
        disp(['ICmovie_min_proj missing for ' session.Animal ': ' session.Date ...
            '-s' num2str(session.Session)])
    end
    
    try
        % Whole image mean
        meanproj = imread(fullfile(session.Location,'ICmovie_mean_proj.tif'));
        fmean_mean = double(mean(meanproj(:)));
        
        % Cropped mean
        [ydim, xdim] = size(meanproj);
        meanproj_crop = meanproj(round(ydim*crop_ratio):round(ydim*(1-crop_ratio)), ...
            round(xdim*crop_ratio):round(xdim*(1-crop_ratio)));
        fmeancrop_mean = mean(meanproj_crop(:));
        
    catch % don't display anything since you know the majority of sessions don't have this file yet
%         disp(['ICmovie_mean_proj missing for ' session.Animal ': ' session.Date ...
%             '-s' num2str(session.Session)])
    end
elseif isempty(session.Location)
    disp('session.Location is blank - check MakeMouseSessionList!')
end

end

