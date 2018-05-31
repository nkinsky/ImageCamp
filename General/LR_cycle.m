function [ n_out, stay_in, x, y, button] = LR_cycle( n_in, n_range)
% [ n_out, stay_in, x, y, button] = LR_cycle( n_in, n_range)
%
%   Lets you cycle n_in up one value or down one value depending on if you
%   push the left or right buttons (spacebar exits).  Similar use to
%   waitforbuttonpress within a for loop, except using LR_cycle in a while
%   loop allows you to step forward or backward through plots.  n_range is 
%   [n_min, n_max], the range of ns you want to scroll through. escape_flag
%   is whatever you want to use to exit your while loop. x, y, button gives you
%   the button you pushed and where if you want it. To scroll through 10 at
%   a time use 7 and 9 in liue of L and R.
%
%   NOTE: typing 'k' allows you to enter keyboard mode (i.e. to print or
%   save the figure). Type 'dbcont' to re-enter scroll mode.
%
%   Example:
%
%   figure
%   xy = rand([6,2]);
%   n_out = 1;
%   stay_in = true;
%   while stay_in
%       plot(xy(n_out,1),xy(n_out,2));
%       [n_out, stay_in] = LR_cycle(n_out,[1 6]);
%   end

% ASCII definitions here
right = 29; left = 28; spacebar = 32; k = 107; rightmouse = 3;
right9 = 57; left7 = 55; % left4 = 52; right6 = 54;

%% Set up and display output
persistent disp_flag; % Set persistent variable so that you only display 
% below the 1st time it is called in a while loop
% Will clear out when you push spacebar
if ~exist('disp_flag','var') || isempty(disp_flag)
    disp('Use L/R keys to scroll. Hit spacebar to stop cycling, ''k'' to enter keyboard mode')
    disp_flag = 1;
end

%% Run it
try
    [x,y,button] = ginput(1);
    switch button
        case {left, left7}
            if button == left
                n_out = n_in - 1;
            elseif button == left7
                n_out = n_in - 10;
            end
            stay_in = true;
            
            % Skip to end if you are at beginning and hit left
            if n_out < min(n_range)
                n_out = max(n_range);
            end
        case {right, right9}
            if button == right
                n_out = n_in + 1;
            elseif button == right9
                n_out = n_in + 10;
            end
            stay_in = true;
            
            % Skip to beginning if you are at end and hit right
            if n_out > max(n_range)
                n_out = min(n_range);
            end
        case {spacebar, rightmouse}
%             n_out = [];
            n_out = n_in;
            stay_in = false;
            clear disp_flag
        case k
            disp('Stepping into LR_cycle.  Type dbcont to keep on running')
            

            keyboard
            n_out = n_in;
            stay_in = true;
        otherwise
            disp('error')
            n_out = n_in;
            stay_in = true;
            
    end
catch % clear disp_flag if you exit randomly for some reason
    clear disp_flag
    return
end

end

