function [] = alt_plotLR(session)
% alt_plotLR(session)
% Plots left and right trials with dots so that you can see how much
% overlap there is for each trial type

dirstr = ChangeDirectory_NK(session,0);

Alt = [];
load(fullfile(dirstr,'Alternation.mat'),'Alt');

figure;
subplot(2,2,1)
plot(Alt.x(Alt.choice == 1), Alt.y(Alt.choice == 1), 'r.', ...
    Alt.x(Alt.choice == 2), Alt.y(Alt.choice == 2), 'b.')
title('All Trials')

subplot(2,2,3)
plot(Alt.x(Alt.choice == 1 & Alt.alt == 1), Alt.y(Alt.choice == 1 & Alt.alt == 1), ...
    'r.', Alt.x(Alt.choice == 2 & Alt.alt == 1), Alt.y(Alt.choice == 2 ...
    & Alt.alt == 1), 'b.')
title('Correct Trials Only')

subplot(2,2,4)
plot(Alt.x(Alt.choice == 1 & Alt.alt == 0), Alt.y(Alt.choice == 1 & Alt.alt == 0), ...
    'r.', Alt.x(Alt.choice == 2 & Alt.alt == 0), Alt.y(Alt.choice == 2 ...
    & Alt.alt == 0), 'b.')
title('Incorrect Trials Only')

subplot(2,2,2)
text(0.1, 0.5, [mouse_name_title(session.Animal) mouse_name_title(session.Date) ...
    ' session ' num2str(session.Session)])
axis off

end

