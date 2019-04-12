function [h] = subplot_auto( n_total, n )
% h = subplot_auto( n_total, n )
%
% Automatically creates subplots that keep the images as close to square as
% possible, e.g. if you have 3 or 4 plots, it uses subplot (2,2,x), if you
% have somewhere between 10 and 16, it uses subplot (4,4,x), etc.
%
% INPUTS
%   n_total: the total number of plots you want to make
%
%   n: which number out of n_total plots you want to create a subplot for.
% 
% Example: subplot_auto(3,2) is the same as subplot(2,2,3);

if n_total == 1
    h = subplot(1,1,n);
elseif n_total <= 2
    h = subplot(1,2,n);
elseif n_total <= 4
    h = subplot(2,2,n);
elseif n_total <= 9
    h = subplot(3,3,n);
elseif n_total <= 16
    h = subplot(4,4,n);
else % Cap it at 25 subplots
  
    % If you've filled up the subplot, make a new figure and start
    % plotting into that one
    if n > 25 && mod(n,25) == 1
        pos = get(gcf,'Position');
        figure; set(gcf,'Position',pos);
    end
    
    if mod(n,25) == 0
        h = subplot(5, 5, 25);
    else
        h = subplot(5, 5, mod(n,25));
    end
    
% elseif n_total <= 25
%     h = subplot(5,5,n);
% elseif n_total <= 36
% %     h = subplot(6,6,n);
% else
%     disp('You really want to have more than 25 subplots in a figure?')
end

end

