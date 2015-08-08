function [ x_split, y_split] = split_2env_tracking(x,y,varargin)
%[ x_split, y_split] = split_2env_tracking(x,y,xrestrict,yrestrict,...)
%   Takes x, y, and t data and dumps all data that outside of xrestrict and
%  yrestrict and sends them to (0,0) or another point of your choosing
%  specified in the varargin 'send_to'
%
% INPUTS
%   x,y,t: original data
%   xrestrict, yrestrict(semi-optional): 1x2 arrays [min max] containing the limits of the
%   data you wish to include. Only 1 of these arguments is required.
%   Specify as a varargin, e.g. ...'xrestrict',[250 500],...
%   'send_to': (optional,specifiy as ...,'send_to',1) not specified (default) = send
%   all data outside of the limits to (0,0), or you can specify the
%   coordinate to send all the stuff outside your limits to
%
% OUTPUTS
%   x_split, y_split: arrays the same length as x and y but with points
%   outside of the limits sent to (0,0)

% Specify defaults and get varargins
xrestrict = [min(x) max(x)];
yrestrict = [min(y) max(y)];
send_to = [0 0];
for j = 1:length(varargin)
   if strcmpi(varargin{j},'xrestrict') 
      xrestrict = varargin{j+1}; 
   end
   if strcmpi(varargin{j},'yrestrict') 
      yrestrict = varargin{j+1};
   end
   if strcmpi(varargin{j},'send_to') 
      send_to = varargin{j+1};
   end
end

% Get valid data points
restrict_ind = (x >= min(xrestrict) & x <= max(xrestrict)) & ...
    (y >= min(yrestrict) & y <= max(yrestrict));

% Intialize x_split and y_split and send all values to "send_to" value
x_split = ones(size(x))*send_to(1);
y_split = ones(size(y))*send_to(2);

% Include only the valid points
x_split(restrict_ind) = x(restrict_ind);
y_split(restrict_ind) = y(restrict_ind);

end

