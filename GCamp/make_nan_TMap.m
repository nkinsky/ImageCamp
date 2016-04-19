function [ OccMap_smooth, TMap_nan ] = make_nan_TMap( OccMap, TMap, varargin )
%[ OccMap_smooth, TMap_nan ] = make_nan_TMap( OccMap, TMap )
%   This function takes Occmap and TMap and assigned nans to all 0 values
%   in the Occmap so that you can plot the track as white using imagesc_nan
%   OccMap_smooth is a smoothed occupancy map, with zeros at points of zero
%   occupancy, TMap_nan is the same as TMap but with nans where 
%   OccMap_smooth = 0.
%
%   varargin: 'perform_smooth': 1 = perform smoothing of OccMap, 0 = do not
%   smooth OccMap (may need to do if you have large bin sizes).  Default =
%   1.

perform_smooth = 0; % default
for j = 1:length(varargin)
    if strcmpi('perform_smooth',varargin{j})
        perform_smooth = varargin{j+1};
    end
end

if perform_smooth == 1
    % Get sum of original occupancy map
    Occsum = sum(OccMap(:));
    % Set up smoothing
    sm = fspecial('disk',1);
    OccMap_smooth = imfilter(OccMap,sm); % apply smoothing
    
    OccMap_smooth = OccMap_smooth.*Occsum./sum(OccMap_smooth(:)); % keep sum the same (might not be necessary)
elseif perform_smooth == 0
    OccMap_smooth = OccMap;
end

TMap_nan = TMap;
TMap_nan(OccMap_smooth(:) == 0) = nan;

end

