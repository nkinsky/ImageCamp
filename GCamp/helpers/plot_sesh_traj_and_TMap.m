function [ ] = plot_sesh_traj_and_TMap( sesh, pf_append )
% plot_sesh_traj_and_TMap( sesh, pf_append )
%   Plots trajectory information with PSA and TMap for each neuron in sesh,
%   allowing you to scroll through. pf_append is any text appended onto the
%   Placefields file you wish to use (e.g. Placefields_tt.mat -> pf_append
%   = _tt)

dir = ChangeDirectory_NK(sesh,0);
load(fullfile(dir,'Pos.mat'),'xpos_interp','ypos_interp')
load(fullfile(dir,['Placefields' pf_append '.mat']),...
    'PSAbool','x','y','TMap_gauss');
% Flip x and y to be compatible with everything else
TMap = cellfun(@transpose, TMap_gauss, 'UniformOutput', false);  %#ok<*NODEF>

nneurons = length(TMap);
neuron = 1; stay_in = true;
figure; set(gcf,'Position', [200 420 1080 420]);
htraj = subplot(1,2,1);
hmap = subplot(1,2,2);
while stay_in
    plot_traj_and_TMap( x, y, PSAbool, TMap, neuron, htraj, hmap);
    [neuron, stay_in] = LR_cycle(neuron, [1, nneurons]);
end


end

