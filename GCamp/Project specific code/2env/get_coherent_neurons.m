function [ coherent_bool, abs_diff] = get_coherent_neurons(best_angle_pop, best_angle_all, ...
    cutoff)
% coherent_bool = get_coherent_neurons(best_angle_pop, best_angle_all, cutoff)
%   Get neurons that maintain a coherent map between arenas (e.g.
%   those within cutoff (default = 30 degrees) of the best angle of the population)

if nargin < 4
    cutoff = 30;
end

diff_temp = abs(best_angle_all - best_angle_pop); % Get absolute value of difference
diff_temp(diff_temp > 180) = diff_temp(diff_temp > 180) - 360; 
abs_diff = abs(diff_temp);
coherent_bool = abs_diff <= cutoff;


end

