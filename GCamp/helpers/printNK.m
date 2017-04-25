function [  ] = printNK( filename, location )
% printNK( filename, location )
%   Prints current figure to filename in location on NORVAL as a pdf with '-bestfit'
%   option specified.
%
%   Location: pwd if unspecified, see below for other options.

if nargin < 2
    location = pwd;
elseif nargin == 2
    if strcmpi(location, 'russek')
        location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Presentations\Russek Day 2017\Poster';
    elseif strcmpi(location, 'NO')
        location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Undergrads\Annalyse\plots';
    elseif strcmpi(location, 'NOlaptop')
        location = 'C:\Users\Nat\Dropbox\Imaging Project\Undergrads\Annalyse\plots';
    end
end

save_file = fullfile(location, filename);
print(save_file,'-dpdf','-bestfit')

end

