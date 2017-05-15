function [  ] = printNK( filename, location, hfig )
% printNK( filename, location, hfig )
%   Prints current figure to filename in location on NORVAL as a pdf with '-bestfit'
%   option specified.
%
%   Location: pwd if unspecified, see below for other options.
%
%   hfig (optional): assumes current figure (gcf) if left unspecfied

resolution_use = '-r600'; %'-r600' = 600 dpi

if nargin < 2
    location = pwd;
elseif nargin == 2
    switch location
        case 'russek'
            location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Presentations\Russek Day 2017\Poster';
        case '2env'
            location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Manuscripts\2env\Figures';
        case 'NO'
            location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Undergrads\Annalyse\plots';
        case 'NOlaptop'
            location = 'C:\Users\Nat\Dropbox\Imaging Project\Undergrads\Annalyse\plots';
        case '2env_laptop'
            location = 'C:\Users\Nat\Dropbox\Imaging Project\Manuscripts\2env\Figures';
        otherwise
    end
end

if nargin < 3
    hfig = gcf;
end

% set to landscape or portrait
if hfig.Position(3) > hfig.Position(4)
    hfig.PaperOrientation = 'landscape';
else
    hfig.PaperOrientation = 'portrait';
end

hfig.Renderer = 'painters';
save_file = fullfile(location, filename);
print(hfig, save_file,'-dpdf','-bestfit',resolution_use)

end

