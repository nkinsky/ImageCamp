function [text_append] = alt_set_filters(wood_filt, half_thresh)
% [text_append] = alt_set_filters(wood_filt, half_thresh)
%   Sets filters for excluding lateral/speed modulated cells and cells with
%   abnormally long half lives. wood_filt = boolean, half_thresh = thresh
%   (seconds). text_append - append to any files you save after running
%   this.

global WOOD_FILT
global HALF_LIFE_THRESH

WOOD_FILT = false;
HALF_LIFE_THRESH = 2;

text_append = '';
if ~isempty(WOOD_FILT) && WOOD_FILT
   text_append = [text_append '_woodfilt'];
end

if ~isempty(HALF_LIFE_THRESH)
    text_append = [text_append '_halfthresh' num2str(floor(HALF_LIFE_THRESH)) ...
        '_' num2str(round((HALF_LIFE_THRESH - floor(HALF_LIFE_THRESH))*100))];
end


if ~isempty(text_append)
    text_append = ['_' text_append];
end
    
end

