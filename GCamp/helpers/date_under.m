function [date_underscore] = date_under(date_slash)
% date_underscore = date_under(date_slash)
%   Takes date formatted with slashes or underscores and 1 or 2 numbers for month and day
%   and outputs MM_DD_YYYY formatted string. 


slashes = regexpi(date_slash,'/');
if isempty(slashes)
    unders = regexpi(date_slash, '_');
    if length(unders) == 2
        slashes = unders;
    end
end

YYYY = num2str(date_slash((slashes(2)+1):end));
if slashes(1) == 2
    MM = ['0' num2str(date_slash(1))];
    if slashes(2) == 4    
        DD = ['0' num2str(date_slash(3))];
    elseif slashes(2) == 5
        DD = num2str(date_slash(3:4));
    end
elseif slashes(1) == 3
    MM = num2str(date_slash(1:2));
    if slashes(2) == 5
        DD = ['0' num2str(date_slash(4))];
    elseif slashes(2) == 6
        DD = num2str(date_slash(4:5));
    end
end

date_underscore = [MM '_' DD '_' YYYY];


end

