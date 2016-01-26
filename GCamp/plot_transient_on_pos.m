function [ ] = plot_transient_on_pos(FT, t, x, y ,NeuronsToPlot, h)
% plot_transient_on_pos(FT, t, x, y, NeuronsToPlot, h)
%   FT, t, x, y come from PlaceMaps.mat.  NeuronsToPlot is a logical vector
%   that selects which neurons to use. h is a handle to a figure (not
%   required)

if nargin < 4
    h = figure;
end
figure(h);

FT_use = FT(NeuronsToPlot,:);
neuron_use_num = find(NeuronsToPlot);

for j = 1:size(FT_use,1)
    
    trans_vec = logical(FT_use(j,:));
    
    % Plot x-position data with transients overlaid
    hx = subplot(2,1,1);
    plot(t, x, 'b', t(trans_vec), x(trans_vec), 'r*');
    xlabel('time'); ylabel('x position');
    title(['Neuron ' num2str(neuron_use_num(j))]);
    
    % Plot y-position data with transients overlaid
    hy = subplot(2,1,2);
    plot(t, y, 'b', t(trans_vec), y(trans_vec), 'r*');
    xlabel('time'); ylabel('y position');
    
    linkaxes([hx, hy],'x');
    
    waitforbuttonpress
    
end


end

