function [f_min_mean, f_mean_mean] = get_baseline_fluor(session)
% [f_min_mean] = get_baseline_fluor(session)
%   Get mean flourescence of minimum and mean (if possible) projection. 

fmin_mean = nan;
fmean_mean = nan;
if ~isempty(session.Location)
    try
        minproj = load(fullfile(session.Location,'ICmovie_min_proj.tif'));
        f_min_mean = mean(minproj(:));
    catch
        disp(['ICmovie_min_proj missing for ' session.Animal ': ' session.Date ...
            '-s' num2str(session.Session)])
    end
    
    try
        meanproj = load(fullfile(session.Location,'ICmovie_min_proj.tif'));
        f_mean_mean = mean(meanproj(:));
    catch % don't display anything since you know the majority of sessions don't have this file yet
%         disp(['ICmovie_mean_proj missing for ' session.Animal ': ' session.Date ...
%             '-s' num2str(session.Session)])
    end
elseif isempty(session.Location)
    disp('session.Location is blank - check MakeMouseSessionList!')
end

end

