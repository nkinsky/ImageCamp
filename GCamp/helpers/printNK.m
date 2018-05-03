function [  ] = printNK( filename, varargin )
% printNK( filename, location, ... )
%   Prints current figure to filename in location on NORVAL as a pdf with '-bestfit'
%   option specified.
%
%   Location(optional): pwd if unspecified, see below for other options.
%
%   'hfig' (name-value pair): assumes current figure (gcf) if left unspecfied or
%   empty
%
%   'append' (name-value pair): default = false; append into one file. Note
%   that this is a .ps file that you can easily convert to a pdf with Adobe
%   Distiller.
%

screen_height_in = 11; % inches: User-specific - set for proper output scaling
screen_height_pix = 1000; % pixels, same as above
resolution_use = '-r300'; % >= 300dpi required by Nature Neuro, so that's what I'm using.

ip = inputParser;
ip.addRequired('filename', @ischar);
ip.addOptional('location', '', @ischar); % See below for valid locations
ip.addParameter('hfig', gcf, @ishandle);
ip.addParameter('append', false, @islogical);
ip.parse(filename, varargin{:});
location = ip.Results.location;
hfig = ip.Results.hfig;
append = ip.Results.append;

%%
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
    case 'alt'
        location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Manuscripts\Alternation\Figures';
    case 'cnmf'
        location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\MATLAB\CNMF vs T4';
    case 'eraser'
        location = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Manuscripts\Eraser';
    otherwise
end


% set to landscape or portrait
if hfig.Position(3) > hfig.Position(4)
    hfig.PaperOrientation = 'landscape';

    % Scale to custom paper size with min dimension approximately the size
    % as shown on screen
    aspect_ratio = hfig.Position(3)/hfig.Position(4);
    scale_factor = hfig.Position(4)/screen_height_pix;
    paper_dims = [round(screen_height_in*aspect_ratio,1), screen_height_in]*...
        scale_factor;
    hfig.PaperSize(1:2) = paper_dims;
    hfig.PaperPosition = [0 0 paper_dims];
    
    %%% The code below seems to squash stuff
    %     hfig.PaperUnits = 'normalized';
    %     hfig.PaperPosition = [0 0 1 1];
else
    hfig.PaperOrientation = 'portrait';
    aspect_ratio = hfig.Position(4)/hfig.Position(3);
    scale_factor = hfig.Position(3)/screen_height_pix;
    paper_dims = [screen_height_in, round(screen_height_in*aspect_ratio,1)]*...
        scale_factor;
    hfig.PaperSize(1:2) = paper_dims;
    hfig.PaperPosition = [0 0 paper_dims]; % [0 0 paper_dims(1)/aspect_ratio paper_dims(2)]; %
end

hfig.Renderer = 'painters'; % This makes sure weird stuff doesn't happen when you save lots of data points by using openGL rendering
save_file = fullfile(location, filename);
if ~append
    print(hfig, save_file, '-dpdf', resolution_use)
elseif append
    print(hfig, save_file, '-dpsc', resolution_use, '-append');
end

end

