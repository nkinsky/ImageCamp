function [divide_frame] = alt_get_loop_end(sesh, divide_time)
% divide_frame = alt_get_forced_end(sesh, divide_time)
%  Gets frame where you transition from looping to forced trials for G30.

dir_use = ChangeDirectory_NK(sesh,0);
copyfile(fullfile(dir_use,'Placefields_cm1.mat'),...
    fullfile(dir_use,'Placefields_combined_cm1.mat'));

load(fullfile(dir_use,'Pos_align.mat'),'x_adj_cm','y_adj_cm',...
    'time_interp')

divide_frame = findclosest(time_interp, divide_time);
exc_frames_loop = divide_frame:length(time_interp);
exc_frames_forced = 1:divide_frame;

figure; set(gcf,'Position', [426   302   959   507])
subplot(2,2,1)
plot(x_adj_cm, y_adj_cm,'b-', ...
    x_adj_cm(divide_frame), y_adj_cm(divide_frame), 'r*')
axis off
title([mouse_name_title(sesh.Animal) ' ' mouse_name_title(sesh.Date) ' s' ...
    num2str(sesh.Session)])
subplot(2,2,2)

axis off

subplot(2,2,3:4)
hp = plot(time_interp(exc_frames_loop), y_adj_cm(exc_frames_loop),'r*',...
    time_interp(exc_frames_forced), y_adj_cm(exc_frames_forced),'b-');
xlabel('Time (s)'); ylabel('y position (cm)')
legend('Forced','Loop')

save(fullfile(dir_use, 'exclude_frames_loop_forced.mat'),...
    'exc_frames_loop', 'exc_frames_forced')

end

