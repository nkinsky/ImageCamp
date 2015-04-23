function center = getcenterarm(x,y)
%function getcenterarm(x,y)
%   Takes position information and outputs boundaries of the center arm.
%   
%   X and Y are vectors of position information. 
%
%   BORDER is a struct with fields:
%       x = x coordinates of the rectangle surrounding the center arm. 
%       y = y coordinates of the rectangle surrounding the center arm. 
%

%% Get xy coordinate bounds for center arm. 
    xmax = max(x); xmin = min(x); 
    ymax = max(y); ymin = min(y); 
    
    %Calculations. 
    ymid = mean([ymin ymax]); 
    
    %For now, width is manually set to 40 AU and downward shift is set to 20. 
    w = 5.5; % 55; 
    shift = 3; % 30; 
    
    %l is the the length of center arm chopped off at the choice point. 
    l = 8; %80; 
    
    %Border. 
    center.x = [xmin+l, xmin+l, xmax-l, xmax-l]; 
    center.y = [ymid-shift, ymid-shift+w, ymid-shift, ymid-shift+w]; 
    
end