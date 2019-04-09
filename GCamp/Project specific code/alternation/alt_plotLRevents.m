function [hf] = alt_plotLRevents(session, neuron)
% hf = alt_plotLRevents(session)
% Plots trajectory with dots for L and R turn spikes. Returns fig handle.
dirstr = ChangeDirectory_NK(session,0);

Alt = []; PSAbool = [];
load(fullfile(dirstr,'Alternation.mat'),'Alt');
load(fullfile(dirstr,'Placefields_cm1.mat'), 'PSAbool')

psa_use = PSAbool(neuron,:);
hf = figure;
subplot(2,2,1)
hp = plot(Alt.x, Alt.y, 'k-', Alt.x(Alt.choice == 1 & psa_use), ...
    Alt.y(Alt.choice == 1 & psa_use), 'r*', Alt.x(Alt.choice == 2 & psa_use), ...
    Alt.y(Alt.choice == 2 & psa_use), 'b*');
camroll(180)
hp(1).Color = [0 0 0 0.25]; % Make trajectory fairly transparent
hl = legend(hp, {'Trajectory', 'L events', 'R events'});
hl.Position = [0.4226 0.9223 0.0547 0.0530];
axis off
title({['Neuron ' num2str(neuron)], 'Ca events: All Trials'})

subplot(2,2,3)
hp = plot(Alt.x, Alt.y, 'k-', Alt.x(Alt.choice == 1 & Alt.alt == 1 & psa_use), ...
    Alt.y(Alt.choice == 1 & Alt.alt == 1 & psa_use), 'r*', ...
    Alt.x(Alt.choice == 2 & Alt.alt == 1 & psa_use), ...
    Alt.y(Alt.choice == 2 & Alt.alt == 1 & psa_use), 'b*');
camroll(180)
hp(1).Color = [0 0 0 0.25]; % Make trajectory fairly transparent
axis off
title({['Neuron ' num2str(neuron)], 'Ca events: Correct Trials Only'})

subplot(2,2,4)
hp = plot(Alt.x, Alt.y, 'k-', Alt.x(Alt.choice == 1 & Alt.alt == 2 & psa_use), ...
    Alt.y(Alt.choice == 1 & Alt.alt == 2 & psa_use), 'r*', ...
    Alt.x(Alt.choice == 2 & Alt.alt == 2 & psa_use), ...
    Alt.y(Alt.choice == 2 & Alt.alt == 2 & psa_use), 'b*');
camroll(180)
hp(1).Color = [0 0 0 0.25]; % Make trajectory fairly transparent
axis off
title({['Neuron ' num2str(neuron)], 'Ca events: Incorrect Trials Only'})

subplot(2,2,2)
plot(Alt.x(Alt.choice == 1), Alt.y(Alt.choice == 1), 'r.', ...
    Alt.x(Alt.choice == 2), Alt.y(Alt.choice == 2), 'b.')
camroll(180)
title( [mouse_name_title(session.Animal) mouse_name_title(session.Date) ...
    ' session ' num2str(session.Session) ': L/R trajectories'])
axis off

end

