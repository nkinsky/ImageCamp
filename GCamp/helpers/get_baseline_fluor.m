function [fmin_mean, fmean_mean] = get_baseline_fluor(session)
% [f_min_mean, fmean_mean] = get_baseline_fluor(session)
%   Get mean flourescence of minimum and mean (if possible) projection.
%   Future possibility: spit out values with crop_percent at each edge 
%   removed to make sure you aren't including any edge values that could 
%   artifically drive values down?

% if nargin < 2
%     crop_percent = 10;
% end
% crop_ratio = crop_percent/100;

fmin_mean = nan;
fmean_mean = nan;
if ~isempty(session.Location)
    try
        minproj = imread(fullfile(session.Location,'ICmovie_min_proj.tif'));
%         [ydim, xdim] = size(minproj);
%         fmin_crop = fmin((ydim*crop_ratio):(ydim*(1-crop_ratio))
        fmin_mean = mean(minproj(:));
    catch
        disp(['ICmovie_min_proj missing for ' session.Animal ': ' session.Date ...
            '-s' num2str(session.Session)])
    end
    
    try
        meanproj = imread(fullfile(session.Location,'ICmovie_mean_proj.tif'));
        fmean_mean = mean(meanproj(:));
    catch % don't display anything since you know the majority of sessions don't have this file yet
%         disp(['ICmovie_mean_proj missing for ' session.Animal ': ' session.Date ...
%             '-s' num2str(session.Session)])
    end
elseif isempty(session.Location)
    disp('session.Location is blank - check MakeMouseSessionList!')
end

end

