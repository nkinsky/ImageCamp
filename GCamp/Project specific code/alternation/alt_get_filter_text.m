function [text_append] = alt_get_filter_text()
% [text_append] = alt_set_filters()
%   Gets the text appended to any files ran with cell filtering using the
%   global variable WOOD_FILT and HALF_LIFE_THRESH. See parse_splitters and
%   alt_parse_cell_category for implementation of filters...

global WOOD_FILT
global HALF_LIFE_THRESH
global USE_EXPFIT

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

