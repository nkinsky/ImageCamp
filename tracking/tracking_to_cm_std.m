function [ x_out, y_out ] = tracking_to_cm_std( x_in, y_in, x_lm, y_lm, Pix2Cm, in_format, limits_percent, arena_effective_size )
%[ x_out, y_out ] = tracking_to_cm_std( x_in, y_in, x_lm, y_lm, Pix2Cm, in_format, arena_effective_lims )
%   Takes input tracking data in DVT or cm format, corrects for any lens
%   distortion, and sets the bottom-left extent of the arena at 0,0.
%
%   x_in, y_in: tracking data, either in DVT coordinates or cm.  0,0 in this
%   reference frame is the bottom-left of the AVI, NOT the bottom-left of
%   the arena
%   x_lm, y_lm: linear models.  Note that these are specific for a given
%   experiment and convert AVI pixels to centimeters
%   arena_effective_size: a length(2) vector [xdim ydim] with the effective length of
%   the arena able to be covered by the mouse in inches (e.g. if the arena
%   is 10"x10", this would probably be [9 9], assuming a mouse's centroid
%   can get no closer than 1/2" to the wall).  This is used to calculate a
%   secondary scaling factor. If ommitted, there will be no secondary
%   scaling.
%   Pix2Cm: factor to convert pixels to cm if the data is in cm format.  
%   in_format: 'cm' indicates that the data has been translated into cm 
%   (most likely from a run of PlaceMaps function), whereas 'DVT' indicates 
%   it is still in DVT format.
%
%   x_out, y_out: output tracking data, corrected for any lens distortion,
%   sent back to cm, and set with 0,0 as the bottom-left extent of the
%   arena

% global limits_percent

in_2_cm = 2.54; % conversion from inches to cms, necessary because the linear models currently convert AVI to inches



DVT_to_AVI = 0.6246;

% Convert back to DVT coordinates if required
if strcmp(in_format,'cm')
   x_in = x_in/Pix2Cm;
   y_in = y_in/Pix2Cm;
elseif strcmp(in_format,'DVT')
    
end

% Convert from DVT to AVI coordinates
x_use = x_in*DVT_to_AVI;
y_use = y_in*DVT_to_AVI;

% Flip vector to column vector if necessary
if size(x_use,2) > 1
    flipped = 1;
    x_use = x_use';
    y_use = y_use';
end



% Correction for distortion using the linear model
x_int = predict(x_lm,x_use);
y_int = predict(y_lm,y_use);

%% Calculate secondary scale factor

[xlims, ylims] = get_occupancy_limits(x_int, y_int, limits_percent);
if nargin < 8 % No scale if arena_effective_limits isn't specified
    x_scale = 1;
    y_scale = 1;
elseif nargin == 8
    x_scale = arena_effective_size(1)/abs(xlims(2)-xlims(1));
    y_scale = arena_effective_size(2)/abs(ylims(2)-ylims(1));
end

% Get occupancy limits again to calculate correct offset after 2ndary
% scaling
[xlims2, ylims2] = get_occupancy_limits(x_int*x_scale, y_int*y_scale, limits_percent);

x_offset = xlims(1) - xlims2(1);
y_offset = ylims(1) - ylims2(1);

% Scale data by secondary scaling factor and re-align, convert from inches
% to cm
x_out = (x_int*x_scale + x_offset)*in_2_cm;
y_out = (y_int*y_scale + y_offset)*in_2_cm;

% Flip back data to row vector if input was row vector
if flipped == 1
    x_out = x_out';
    y_out = y_out';

end

