function [h, delta_angle_med, arena_rot, pshuf, ncells, coh_ratio, coh_bool,...
    neuron_id, disp_metric] = plot_pfangle_batch(sessions, sessions2, nshuf, PCfilter, ...
    coh_ang_thresh, plot_flag, bin_size)
% [h, delta_angle_med, arena_rot, pshuf, ncells, coh_ratio, coh_bool,...
%     neuron_id, disp_metric] = plot_pfangle_batch(sessions, sessions2, nshuf, ...
%     PCfilter, coh_ang_thresh, plot_flag, bin_size)
%   Does a batch run of plot_delta_angle_hist for a given mouse using
%   specified parameters nshuf (default = 0), PCfilter (default = false),
%   and coh_ang_thresh (default = 22.5). Specify only sessions1 and leave
%   sessions2 empty ([]) for within arena comparisons, specify square
%   sessions in session1 and circle sessions in session2 for across arena
%   comparisons.


map_type = 'TMap_gauss';
if nargin < 7
    bin_size = 1; % bin_size for TMaps
end

circ2square = false;
if nargin >= 2 && ~isempty(sessions2)
    circ2square = true;
    num_sessions2 = length(sessions2);
end
num_sessions = length(sessions);

if nargin < 3
    nshuf = 0;
end

if nargin < 4
    PCfilter = false;
end

if nargin < 5
    coh_ang_thresh = 22.5;
end

if nargin < 6
    plot_flag = true;
end

if plot_flag
    h = figure;
else
    h = gobjects(0);
end
delta_angle_med = nan(num_sessions,num_sessions);
arena_rot = nan(num_sessions, num_sessions);
pshuf = nan(num_sessions, num_sessions);
ncells = nan(num_sessions, num_sessions);
coh_ratio = nan(num_sessions, num_sessions);
coh_bool = cell(num_sessions);
neuron_id = cell(num_sessions);
disp_metric = nan(num_sessions,num_sessions);
n = 1;

if ~circ2square
    ncomps = length(sessions)*(length(sessions)-1)/2;
    nsesh = length(sessions);
    p = ProgressBar(ncomps);
    for j = 1:num_sessions-1
        for k = j+1:num_sessions
            sesh1 = sessions(j);
            sesh2 = sessions(k);
            if plot_flag
                ha = subplot(nsesh,nsesh,nsesh*(j-1)+k);
            else
                ha = gobjects(0);
            end
            try
                [~, delta_angle_med(j,k), arena_rot(j,k), pshuf(j,k), ncells(j,k), ...
                    coh_ratio(j,k), coh_bool{j,k}, neuron_id{j,k}, disp_metric(j,k)] = ...
                    plot_delta_angle_hist(...
                    sesh1, sesh2, sessions(1), 'TMap_type',map_type, ...
                    'bin_size', bin_size, 'PCfilter', PCfilter,'h',ha,...
                    'plot_arena_rot', true, 'nshuf', nshuf, 'plot_legend', false,...
                    'sig_thresh', 0.05/ncomps, 'coh_ang_thresh', coh_ang_thresh,...
                    'plot_flag', plot_flag);
            catch
                disp(['Error in ' num2str(j) ' vs ' num2str(k)])
                
            end
            p.progress;
        end
    end
    p.stop;
elseif circ2square
    ncomps = length(sessions)*length(sessions2);
    nsesh1 = length(sessions); nsesh2 = length(sessions2);
    p = ProgressBar(ncomps);
    for j = 1:num_sessions
        for k = 1:num_sessions2
            sesh1 = sessions(j);
            sesh2 = sessions2(k);
            if plot_flag
                ha = subplot(nsesh1,nsesh2,nsesh2*(j-1)+k);
            else
                ha = gobjects(0);
            end
%             try
                [~, delta_angle_med(j,k), arena_rot(j,k), pshuf(j,k), ncells(j,k), ...
                    coh_ratio(j,k), coh_bool{j,k}, neuron_id{j,k}, disp_metric(j,k)] ...
                    = plot_delta_angle_hist(...
                    sesh1, sesh2, sessions(1), 'TMap_type',map_type, ...
                    'bin_size', bin_size, 'PCfilter', PCfilter,'h',ha,...
                    'circ2square', true, 'plot_arena_rot', true,'nshuf',nshuf,...
                    'plot_legend',false,'sig_thresh',0.05/ncomps, ...
                    'coh_ang_thresh', coh_ang_thresh, 'plot_flag', plot_flag);
%             catch
%                 disp(['Error in ' num2str(j) ' vs ' num2str(k)])
% %                 keyboard
%                 
%             end
            p.progress;
        end
    end
    p.stop;
else
    
end

if plot_flag
    subplot(8,8,1);
    title(mouse_name_title(sessions(1).Animal))
end

end

