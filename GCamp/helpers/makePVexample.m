function [ hPV ] = makePVexample( TMaps_use)
% hPV = makePVexample( TMaps_use )
%
% Makes example figure for how PVs are constructed by plotting out a series
% of TMaps in 3d.
num_cells = length(TMaps_use);
spacing = 20;
cm = 'jet';
norm_er = true; % flag to normalize calcium event rates to 1 for each neuron 
% - makes plot prettier but make sure it matches the way you calc PVs 
% (e.g. true if you z-score, false if you don't)

if exist('hPV','var'); try close(hPV); catch; disp('some error closing hPV'); end; end
hPV = figure;
z_use = num_cells*spacing;
for j = 1:num_cells
    if norm_er
        tmap_use = TMaps_use{j}/max(TMaps_use{j}(:)); % Normalize it so that peak FR shows up as red for each cell...
    else
        tmap_use = TMaps_use{j};
    end
    imagesc_nan(tmap_use,cm,'z',z_use)
    hold on
    z_use = z_use - spacing;
end
axis off

end

