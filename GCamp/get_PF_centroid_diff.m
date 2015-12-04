function [ min_dist ] = get_PF_centroid_diff( PlaceMap1, PlaceMap2, neuron_map, centroid_input )
% min_dist = get_PF_centroid_diff( PlaceMap1, PlaceMap2, neuron_map )
%   Gets distance between a neuron's place map from one session to the
%   next.  In the case of multiple fields, it finds the minimum distance
%   between any fields from session1 to session2.
%
%   INPUTS:
%  
%       PlaceMap1, PlaceMap2: cell arrays containing the TMaps for session1
%       and session2.
%
%       neuron_map: array the length of PlaceMap1 that designates which
%       neuron in session2 maps to session1.  0 = no neuron maps.
%
%       centroid_inpu5t: 1 = indicates that centroids (obtained from get_PF_centroid) are
%       entered in lieu of the PlacMap cell arrays for the first two
%       inputs. Use if running a lot to save time.  0 = default
%
%   OUTPUTS:
%
%       min_dist: an array the length of PlaceMap1 with the minimum
%       distance between placefields between sessions

%% FUTURE ADD-INS
% 1) Angle and distance from center so that you can later determine if
% remapping is due to just rotation (e.g. angles change consistently and
% radii change is ~0), or global (both angles and radii change randomly)

%% Parse centroid_input

if nargin < 4
    centroid_input = 0;
end
%%
thresh = 0.9; % PF threshold

num_neurons(1) = length(PlaceMap1);
num_neurons(2) = length(PlaceMap2);
%%
if centroid_input == 0
    session(1).PF_centroid = get_PF_centroid(PlaceMap1,thresh);
    session(2).PF_centroid = get_PF_centroid(PlaceMap2,thresh);
else
    session(1).PF_centroid = PlaceMap1;
    session(2).PF_centroid = PlaceMap2;
end

%% Calculate distance to closest PF centroid
min_dist = nan(num_neurons(1),1);
for j = 1:num_neurons(1)
    neuron2 = neuron_map(j); % Get second session neuron to use
    try % Error catching statement
        
        if neuron2 ~= 0 && neuron2 <= num_neurons(1)% proceed only if there is a valid neuron in the second session
            
            % Identify the number of PlaceMaps that are legitimate (i.e. are not NaN)
            num_valid(1) = sum(cellfun(@(a) ~isempty(a),session(1).PF_centroid(j,:)));
            num_valid(2) = sum(cellfun(@(a) ~isempty(a),session(2).PF_centroid(neuron2,:)));
            
            if num_valid(1) > 0 && num_valid(2) > 0 % Only run if both sessions have a valid PF
                dist_temp = [];
                for k = 1:num_valid(1)
                    for ll = 1:num_valid(2)
                        cent_diff = session(1).PF_centroid{j,k} - ...
                            session(2).PF_centroid{neuron2,ll};
                        dist_temp = [dist_temp sqrt(cent_diff(1)^2 + cent_diff(2)^2)];
                    end
                end
                min_dist(j) = min(dist_temp);
            else
                continue
            end
            
        else
            min_dist(j) = nan;
        end
    
    catch
        disp('Error catching in get_PF_centroid_diff')
        keyboard
    end
end


end

