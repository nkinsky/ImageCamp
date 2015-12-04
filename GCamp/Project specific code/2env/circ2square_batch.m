function [xtrans, ytrans ] = circ2square_full( session_struct, circle_rad, square_side)
% circ2square_batch( session_struct, true_rad, square_side )
%
% Runs circ2square for all the sessions listed in session_struct and saves
% it in the appropriate location in the file Pos_trans.mat
% 
% INPUTS 
%   session_struct: Mouse Database structure from MakeMouseSessionList. 
%
% OUTPUTS
%   the coordinates will be saved in either pos_trans

%% Arena Size Parameters
circle_rad = 14.33;
square_side = 25.4;
%%

keyboard

num_sessions = length(sesh);
sesh = session_struct;

curr_dir = cd;

%% Load all the appropriate data
ChangeDirectory(sesh.Animal, sesh.Date ,sesh.Session);
if ~isempty(regexpi(sesh.Room,'201b'))
    Pix2Cm = 0.15;
    disp(['Using 0.15 for Pix2Cm for ' sesh.Date ' Session ' num2str(sesh.Session)])
elseif ~isempty(regexpi(sesh.Room,'201a - 2015'))
    Pix2Cm = 0.0874;
    disp(['Using 0.0875 for Pix2Cm for ' sesh.Date ' Session ' num2str(sesh.Session)])
elseif ~isempty(regexpi(sesh.Room,'201a'))
    Pix2Cm = 0.0709;
    disp(['Using 0.0709 for Pix2Cm for ' sesh.Date ' Session ' num2str(sesh.Session)])
else
    Pix2Cm = [];
    disp('Need room to get Pix2Cm')
end
load('ProcOut.mat');
[x_square,y_square,~,~,~,~,~] = AlignImagingToTracking(Pix2Cm,FT);

%% Un-skew position data by scaling both x and y to the true radius
[f, x] = ecdf(x_square);
xspan = x(find(f > 0.95,1,'first')) - x(find(f < 0.05,1,'last'));
[f, y] = ecdf(y_square);
yspan = y(find(f > 0.95,1,'first')) - y(find(f < 0.05,1,'last'));

x_use = x_square*circle_rad/xspan;
y_use = y_square*circle_rad/yspan;

%% transform the data from circle to square
[xtrans, ytrans] = circ2square(x_use, y_use, square_side,...
    circle_rad);
%%
cd(curr_dir);
end

