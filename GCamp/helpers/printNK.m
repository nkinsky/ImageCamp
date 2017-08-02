function [  ] = printNK( filename, location, hfig, varargin )
% printNK( filename, location, hfig, varargin )
%   Prints current figure to filename in location on NORVAL as a pdf with '-bestfit'
%   option specified.
%
%   Location: pwd if unspecified, see below for other options.
%
%   hfig (optional): assumes current figure (gcf) if left unspecfied or
%   empty
%
%   varargin: can specify any flags valid for the print command here

resolution_use = '-r600'; %'-r600' = 600 dpi - might not be necessary

if nargin < 2
    location = pwd;
elseif nargin >= 2
    switch location
        case 'russek'
            location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Presentations\Russek Day 2017\Poster';
        case '2env'
            location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Manuscripts\2env\Figures';
        case '2env_rot' % 2env rotation analysis figures
            location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Manuscripts\2env\Figures\Rotation Analysis';
        case 'NO'
            location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Undergrads\Annalyse\plots';
        case 'NOlaptop'
            location = 'C:\Users\Nat\Dropbox\Imaging Project\Undergrads\Annalyse\plots';
        case '2env_laptop'
            location = 'C:\Users\Nat\Dropbox\Imaging Project\Manuscripts\2env\Figures';
        otherwise
    end
end

if nargin < 3 || isempty(hfig)
    hfig = gcf;
end

% set to landscape or portrait
% if hfig.Position(3) > hfig.Position(4)
%     hfig.PaperOrientation = 'landscape';
% else
%     hfig.PaperOrientation = 'portrait';
% end

hfig.Renderer = 'painters'; % This makes sure weird stuff doesn't happen when you save lots of data points by using openGL rendering
save_file = fullfile(location, filename);
print(hfig, save_file,'-dpdf',resolution_use, varargin{:});
% print(hfig, save_file,'-dpdf','-bestfit',resolution_use)

end

