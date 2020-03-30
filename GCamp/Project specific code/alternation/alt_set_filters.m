function [text_append] = alt_set_filters(wood_filt, half_thresh, use_expfit)
% [text_append] = alt_set_filters(wood_filt, half_thresh, ...)
%   Sets filters for excluding lateral/speed modulated cells and cells with
%   abnormally long half lives. wood_filt = boolean, half_thresh = thresh
%   (seconds). text_append - append to any files you save after running
%   this. use_expfit is an optional third argument that will calculate
%   half-life decay times using an exponential fit in exp_fit_trace and add
%   a '_expfit' to the end of text_append

if nargin < 3
    use_expfit = false;
end

global WOOD_FILT
global HALF_LIFE_THRESH
global USE_EXPFIT

WOOD_FILT = wood_filt;
HALF_LIFE_THRESH = half_thresh;
USE_EXPFIT = use_expfit;

text_append = '';
if ~isempty(WOOD_FILT) && WOOD_FILT
   text_append = [text_append '_woodfilt'];
end

if ~isempty(HALF_LIFE_THRESH)
    text_append = [text_append '_halfthresh' num2str(floor(HALF_LIFE_THRESH)) ...
        '_' num2str(round((HALF_LIFE_THRESH - floor(HALF_LIFE_THRESH))*100))];
end

if USE_EXPFIT
   text_append = [text_append '_expfit']; 
end


if ~isempty(text_append)
    text_append = ['_' text_append];
end
    
end

