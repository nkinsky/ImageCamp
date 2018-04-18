function [h, delta_angle_med, arena_rot  ] = plot_pfangle_batch( sessions,...
 sessions2)
% [h, delta_angle_med, arena_rot  ] = plot_pfangle_batch( sessions )
%   Detailed explanation goes here


map_type = 'TMap_gauss';
bin_size = 1;
PCfilter = false;

circ2square = false;
if nargin == 2
    circ2square = true;
    num_sessions2 = length(sessions2);
end
num_sessions = length(sessions);

h = figure;
delta_angle_med = nan(num_sessions,num_sessions);
arena_rot = nan(num_sessions, num_sessions);
if ~circ2square
    for j = 1:num_sessions-1
        for k = j+1:num_sessions
            sesh1 = sessions(j);
            sesh2 = sessions(k);
            ha = subplot(8,8,8*(j-1)+k);
            [~, delta_angle_med(j,k), arena_rot(j,k)] = plot_delta_angle_hist(...
                sesh1, sesh2, sessions(1), 'TMap_type',map_type, ...
                'bin_size', bin_size, 'PCfilter', PCfilter,'h',ha,...
                'plot_arena_rot', false);
           
        end
    end
    subplot(8,8,1);
    title(mouse_name_title(sessions(1).Animal))
elseif circ2square
    for j = 1:num_sessions
        for k = 1:num_sessions2
            sesh1 = sessions(j);
            sesh2 = sessions2(k);
            ha = subplot(8,8,8*(j-1)+k);
            [~, delta_angle_med(j,k), arena_rot(j,k)] = plot_delta_angle_hist(...
                sesh1, sesh2, sessions(1), 'TMap_type',map_type, ...
                'bin_size', bin_size, 'PCfilter', PCfilter,'h',ha,...
                'circ2square', true, 'plot_arena_rot', false);
           
        end
    end
    subplot(8,8,1);
    title(mouse_name_title(sessions(1).Animal))
else
    
end

end

