function [ h, delta_med, arena_rot ] = plot_delta_angle_hist( sesh1, sesh2, ...
    map_sesh, varargin)
% [h, delta_median, arena_rot] = plot_delta_angle_hist( sesh1, sesh2, map_sesh, ...)
%   Plot angle of rotation between neurons

ip = inputParser;
ip.addRequired('sesh1',@isstruct);
ip.addRequired('sesh2',@isstruct);
ip.addRequired('map_sesh',@isstruct);
ip.addParameter('circ2square', false, @islogical);
ip.addParameter('TMap_type', 'TMap_unsmoothed', @(a) ...
    strcmp(a,'TMap_unsmoothed') || strcmp(a,'TMap_gauss'));
ip.addParameter('h', gobjects(0), @ishandle);
ip.addParameter('bin_size', 4, @(a) a == 1 || a == 4 || isnan(a));
ip.addParameter('PCfilter', false, @islogical); % include only place cells = true, include all = false
ip.addParameter('plot_arena_rot', true, @islogical);
ip.parse(sesh1, sesh2, map_sesh, varargin{:});
circ2square = ip.Results.circ2square;
TMap_type = ip.Results.TMap_type;
bin_size = ip.Results.bin_size;
PCfilter = ip.Results.PCfilter;
plot_arena_rot = ip.Results.plot_arena_rot;
h = ip.Results.h;

if isempty(h)
    figure; set(gcf,'Position', [2200 420 580 330]);
    h = gca;
end

sesh1 = complete_MD(sesh1); sesh2 = complete_MD(sesh2);

if circ2square; trans_append = '_trans'; else; trans_append = ''; end
map_sesh = complete_MD(map_sesh);
load(fullfile(map_sesh.Location,['batch_session_map' ...
    trans_append '.mat']));
batch_session_map = fix_batch_session_map(batch_session_map); %#ok<NODEF>

[delta_angle, delta_pos, pos1] = get_PF_angle_delta(sesh1, sesh2, ...
    batch_session_map, TMap_type, bin_size, PCfilter);

delta_med = circ_rad2ang(circ_median(circ_ang2rad(delta_angle)));
if delta_med < 0; delta_med = delta_med + 360; end

[~, rot1] = get_rot_from_db(sesh1);
[~, rot2] = get_rot_from_db(sesh2);
arena_rot = rot2 - rot1;
if arena_rot < 0; arena_rot = arena_rot + 360; end
sesh1_ind = get_session_index(sesh1, batch_session_map.session);
sesh2_ind = get_session_index(sesh2, batch_session_map.session);
mouse = sesh1.Animal;

envs = {'sq', 'oct'};
sesh1_env = envs{isempty(regexpi(sesh1.Env,'square')) + 1};
sesh2_env = envs{isempty(regexpi(sesh2.Env,'square')) + 1};

axes(h);
histogram(delta_angle,0:15:345);
ylims = get(gca,'YLim');
xlim([0 360]);
xlabel('PF rotation'); ylabel('Count')
hold on
if plot_arena_rot
    hrot = plot([arena_rot arena_rot], ylims, 'r--');
    legend(hrot, 'Arena rotation')
end
title([mouse_name_title(mouse) ': ' sesh1_env num2str(sesh1_ind)...
    ' v ' sesh2_env  num2str(sesh2_ind)])

end

