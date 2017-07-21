function [ rotd, h ] = twoenv_plot_rotd( best_angle_all, incr_use, coh_sig, plot_flag) %#ok<INUSD>
% rotd = twoenv_plot_rotd( best_angle_all, rot_use, coh_sig, plot_flag )
%   Plots histogram of pairwise difference in rotation angles for all
%   neurons.  best_angle_all is from twoenv_rot_analysis_full, incr_use is
%   -180:incr:180 where incr is the increment you wish to use when plotting
%   the histogram, and coh_sig puts a star for any true values to indicate
%   significant coherence.

plot_flag = true;
if nargin < 2
    incr_use = 15;
    coh_sig = false(size(best_angle_all));
    plot_flag = false;
elseif nargin < 3
    coh_sig = false(size(best_angle_all));
    plot_flag = false;
elseif nargin < 4
    plot_flag = false;
end
rot_use = -180:incr_use:180;

rotd = cell(size(best_angle_all));

sesh_ind = find(~cellfun(@isempty,best_angle_all)); % Get valid sessions


for j = 1:length(sesh_ind)
    best_ang_use = best_angle_all{sesh_ind(j)};
    rotd{sesh_ind(j)} = calc_rotd(best_ang_use);
%     num_neurons = length(best_ang_use);
%     n = 1;
%     rot_temp = nan(1,num_neurons*(num_neurons-1)/2); % pre-allocate
%     % Calculate pairwise rotation difference
%     for k = 1:num_neurons-1
%         for ll = 2:num_neurons
%             rot_temp(n) = best_ang_use(k) - best_ang_use(ll);
%             n = n+1;
%         end
%     end
%     % Adjust to make data range from -180 to 180
%     rot_temp(rot_temp < 180) = rot_temp(rot_temp < 180) + 360;
%     rot_temp(rot_temp >= 180) = rot_temp(rot_temp >= 180) - 360;
%     rotd{sesh_ind(j)} = rot_temp;
end

if plot_flag
    h = figure;
    [ii, jj] = find(~cellfun(@isempty,best_angle_all)); % Get valid sessions
    for j = 1:length(ii)
       subplot(size(best_angle_all,1), size(best_angle_all,2), ...
           (ii(j)-1)*size(best_angle_all,2) + jj(j));
       histogram(rotd{sesh_ind(j)}, rot_use)
       if coh_sig(ii(j),jj(j)); title('*'); end
    end
end

end

