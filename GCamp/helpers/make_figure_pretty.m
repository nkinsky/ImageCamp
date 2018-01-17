function [ hf ] = make_figure_pretty( hf )
% hf = make_figure_pretty( hf )
%   Makes all of the axes in the plot specified by handle hf pretty. If hf
%   is empty uses current figure handle

if nargin == 0
    hf = gcf;
end

hc = get(hf,'Children');
arrayfun(@make_plot_pretty, hc);


end

