function [ h ] = plot_delta_angle_hist( sesh1, sesh2, map_sesh, varargin)
% h = plot_delta_angle_hist( sesh1, sesh2, map_sesh, comp_type)
%   Plot angle of rotation between neurons

ip = inputParser;
ip.addRequired('sesh1',@isstruct);
ip.addRequired('sesh2',@isstruct);
ip.addRequired('map_sesh',@isstruct);
ip.addParameter('circ2square', false, @islogical);
ip.addParameter('TMap_type', 'TMap_unsmoothed', @(a) ...
    strcmp(a,'TMap_unsmoothed') || strcmp(a,'TMap_gauss'));
ip.addParameter('h', gobjects(0), @ishandle);
ip.addParameter('bin_size', 4, @(a) a == 1 || a == 4);
ip.addParameter('PCfilter', false, @islogical); % include only place cells = true, include all = false
ip.parse(sesh1, sesh2, map_sesh, varargin{:});
circ2square = ip.Results.circ2square;
TMap_type = ip.Results.TMap_type;
bin_size = ip.Results.bin_size;
PCfilter = ip.Results.PCfilter;
h = ip.Results.h;

if isempty(h)
    figure; set(gcf,'Position', [2200 420 580 330]);
    h = gca;
end

if circ2square; trans_append = '_trans'; else; trans_append = ''; end
map_sesh = complete_MD(map_sesh);
load(fullfile(map_sesh.Location,['batch_session_map' ...
    trans_append '.mat']));
batch_session_map = fix_batch_session_map(batch_session_map);

[delta_angle, delta_pos, pos1] = get_PF_angle_delta(sesh1, sesh2, ...
    batch_session_map, TMap_type, bin_size, PCfilter);

axes(h);
histogram(delta_angle,0:15:345);
xlim([0 360]);
xlabel('PF rotation'); ylabel('Count')

end

