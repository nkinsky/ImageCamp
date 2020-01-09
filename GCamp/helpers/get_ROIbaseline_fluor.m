function [F0, error_flag] = get_ROIbaseline_fluor(MD)
% [F0, error_flag] = get_baseline_fluor(MD)
%   Gets baseline fluorescence for each neuron ROI in session MD from the
%   minimum projection. Pixel intensities in min projection and mean 
%   projection are highly correlated so this works well. error_flag = 1
%   means you had troube loading the minimum projection, 2 means you loaded
%   successfully but that it was normalized to the maximum and so you will
%   need to re-run it and save without normalizing (probably as a .mat file
%   too since MATLAB won't let you save doubles or singles as TIFFs I
%   think...).

% Load neuron ROIs
load(fullfile(MD.Location,'FinalOutput.mat'),'NeuronImage');

% Load minimum projection
error_flag = 0;
try
    minproj = imread(fullfile(MD.Location,'ICMovie_min_proj.tif'));
    
    if max(minproj(:)) < 0
        error_flag = 2;
    end
catch
    disp(['error loading ICmovie_min_proj.tif for ' MD.Animal ':' ...
        MD.Date '-s' num2str(MD.Session)])
    error_flag = 1;
end

% Calculate F0 for all neurons
F0 = cellfun(@(a) sum(a(:).*minproj(:)), NeuronImage);

end

