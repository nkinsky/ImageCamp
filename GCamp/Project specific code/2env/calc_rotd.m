function [ rotd ] = calc_rotd( best_angle_vec )
% rotd = calc_rotd( best_angle_vec )
%   Twoenv task: Calculates pair-wise difference between best rotation angles 
%   for all cell pairs whose best rotation angle is listed in
%   best_angle_vec

num_neurons = length(best_angle_vec);
n = 1;
rot_temp = nan(1,num_neurons*(num_neurons-1)/2); % pre-allocate
% Calculate pairwise rotation difference
for k = 1:num_neurons-1
    for ll = 2:num_neurons
        rot_temp(n) = best_angle_vec(k) - best_angle_vec(ll);
        n = n+1;
    end
end
% Adjust to make data range from -180 to 180
rot_temp(rot_temp < 180) = rot_temp(rot_temp < 180) + 360;
rot_temp(rot_temp >= 180) = rot_temp(rot_temp >= 180) - 360;
rotd = rot_temp;

end

