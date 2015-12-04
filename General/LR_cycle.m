function [ n_out] = LR_cycle( n_in, n_range, escape_flag )
%[ n_out] = LR_cycle( n_in, n_range, escape_flag )
%   Lets you cycle n_in up one value or down one value depending on if you
%   push the left or right buttons (spacebar exits).  Similar use to
%   waitforbuttonpress within a for loop, except using LR_cycle in a while
%   loop allows you to step forward or backward through plots.  n_range is 
%   [n_min, n_max}, the range of ns you want to scroll through. escape_flag
%   is whatever you want to use to exit your while loop.

% ASCII definitions here
right = 29; left = 28; spacebar = 32;

[~,~,button] = ginput(1);

%%
disp('Hit spacebar to stop cycling')
switch button
    case left
        n_out = n_in -1;
        if n_out < min(n_range)
            n_out = min(n_range);
        end
    case right
        n_out = n_in + 1;
        if n_out > max(n_range)
            n_out = max(n_range);
        end
    case spacebar
        n_out = escape_flag;
    otherwise
        disp('error')
        n_out = n_in;
   
end

