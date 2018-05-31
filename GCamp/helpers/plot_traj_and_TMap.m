function [ htraj, hmap ] = plot_traj_and_TMap( x, y, PSAbool, TMap, neuron,...
    htraj, hmap  )
% [htraj, hmap ] = plot_traj_and_TMap( x, y, PSAbool, TMap, neuron, htraj, hmap )
%   Plots trajectory with neuron activity and/or the TMap for a given
%   neuron into axes htraj and hmap. specify hmap or htraj as [] if you
%   don't want to plot that one. If both are left blank a new figure is
%   opened.

if nargin == 5
    figure; set(gcf,'Position', [200 420 1080 420]);
    htraj = subplot(1,2,1);
    hmap = subplot(1,2,2);
end

PSAuse = PSAbool(neuron,:);
TMap_use = TMap{neuron};
if ~isempty(htraj)
    axes(htraj);
    plot(x,y,'k',x(PSAuse),y(PSAuse),'r*')
    axis off
    title(['Neuron ' num2str(neuron)])
end

if ~isempty(hmap)
    axes(hmap);
    imagesc_nan(TMap_use);
    set(gca,'YDir','normal');
    axis off
end

end

