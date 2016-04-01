function [ min_dist, vec ] = get_PF_centroid_diff( PlaceMap1, PlaceMap2, neuron_map, centroid_input, varargin )
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
%       centroid_input: 1 = indicates that centroids (obtained from get_PF_centroid) are
%       entered in lieu of the PlacMap cell arrays for the first two
%       inputs. Use if running a lot to save time.  0 = default. 2 = use
%       centroids in lieu of location of max firing (not recommended)
%
%       varargins: ...,'todebug',1) will plot PlaceMaps with overlying
%       differences between the two.
%
%   OUTPUTS:
%
%       min_dist: an array the length of PlaceMap1 with the minimum
%       distance between placefields between sessions
%
%       vec: a data structure with fields:
%           .xy which contains the x,y coordinates of the field in PlaceMap1
%           .uv which contains the dx,dy vector direction it moved to in
%           PlaceMap2

%% FUTURE ADD-INS
% 1) Angle and distance from center so that you can later determine if
% remapping is due to just rotation (e.g. angles change consistently and
% radii change is ~0), or global (both angles and radii change randomly)

%% Parse centroid_input

if nargin < 4
    centroid_input = 0;
end

%% Parse varargins
for j = 1:length(varargin)
   if strcmpi(varargin{j},'todebug')
       todebug = logical(varargin{j+1});
       if todebug == 1 && centroid_input ~= 0
           todebug = false;
           disp('todebug can only be set to 1 in combination with centroid_input = 1')
       end
   end
end
%%
thresh = 0.9; % PF threshold

% Get number of valid neurons in each session
num_neurons(1) = min([length(PlaceMap1) length(neuron_map)]); % if a number of the last neurons have no valid map, this catches that
num_neurons(2) = min([length(PlaceMap2) max(neuron_map)]);
%%
if centroid_input == 0
    [ ~, session(1).PF_centroid ] = get_PF_centroid(PlaceMap1,thresh);
    [ ~, session(2).PF_centroid ] = get_PF_centroid(PlaceMap2,thresh);
elseif centroid_input == 1
    session(1).PF_centroid = PlaceMap1;
    session(2).PF_centroid = PlaceMap2;
elseif centroid_input == 2
    [ session(1).PF_centroid, ~ ] = get_PF_centroid(PlaceMap1,thresh);
    [ session(2).PF_centroid, ~ ] = get_PF_centroid(PlaceMap2,thresh);
end

%% Calculate distance to closest PF centroid

% Pre-allocate
min_dist = nan(num_neurons(1),1);
vec.xy = nan(num_neurons(1),2);
vec.uv = nan(num_neurons(1),2);
if todebug
    hqc = figure;
end
% Step through each neuron
for j = 1:num_neurons(1)
    try % Error catching statement
        neuron2 = neuron_map(j); % Get second session neuron to use
        if neuron2 ~= 0 && neuron2 <= num_neurons(1)% proceed only if there is a valid neuron in the second session
            
            % Identify the number of PlaceMaps that are legitimate (i.e. are not NaN)
            num_valid(1) = sum(cellfun(@(a) ~isempty(a),session(1).PF_centroid(j,:)));
            num_valid(2) = sum(cellfun(@(a) ~isempty(a),session(2).PF_centroid(neuron2,:)));
            
            % Get distances between all field centroids
            if num_valid(1) > 0 && num_valid(2) > 0 % Only run if both sessions have a valid PF
                %%% OLD CODE - looked for minimum distance between all pairs of fields.
                %%% Better is to look for distance only between fields with
                %%% the max firing rate...
%                 dist_temp = [];
%                 cent_diff = [];
%                 for k = 1:num_valid(1)
%                     for ll = 1:num_valid(2)
%                         cent_diff{k,ll} = session(1).PF_centroid{j,k} - ...
%                             session(2).PF_centroid{neuron2,ll};
% %                         dist_temp = [dist_temp sqrt(cent_diff(1)^2 + cent_diff(2)^2)];
%                         dist_temp(k,ll) = sqrt(cent_diff{k,ll}(1)^2 + cent_diff{k,ll}(2)^2);
%                     end
%                 end
%                 min_dist(j) = min(dist_temp(:));
%                 [sesh1_field, sesh2_field] = find(dist_temp == min_dist(j)); % Get fields in 1st and 2nd session to which this distance corresponds
%                 vec.xy(j,:) = session(1).PF_centroid{j,sesh1_field(1)}; % x,y coordinates of sesh1 field centroid
%                 vec.uv(j,:) = cent_diff{sesh1_field(1),sesh2_field(1)};
                
                cent_diff= session(2).PF_centroid{neuron2,1} - ...
                    session(1).PF_centroid{j,1};
                min_dist(j) = sqrt(cent_diff(1)^2 + cent_diff(2)^2);
                vec.xy(j,:) = session(1).PF_centroid{j,1}; % x,y coordinates of sesh1 field centroid
                vec.uv(j,:) = cent_diff;
                
                % Debug plotting
                if todebug
                    figure(hqc)
                    subplot(1,2,1) % PlaceMap1 with uv plotted on it using quiver
                    imagesc(PlaceMap1{j})
                    set(gca, 'YDir', 'Normal')
                    hold on
                    plot(session(1).PF_centroid{j,1}(1),...
                        session(1).PF_centroid{j,1}(2),'w*')
                    quiver(vec.xy(j,1),vec.xy(j,2), vec.uv(j,1), vec.uv(j,2),0,'w');
                    title('Session 1 place field with displacement vector noted')
                    hold off
                    subplot(1,2,2) % PlaceMap2 with uv plotted on it using quiver
                    imagesc(PlaceMap2{neuron_map(j)})
                    set(gca, 'YDir', 'Normal')
                    hold on
                    plot(session(2).PF_centroid{neuron_map(j),1}(1),...
                        session(1).PF_centroid{neuron_map(j),1}(2),'w*')
                    quiver(vec.xy(j,1),vec.xy(j,2), vec.uv(j,1), vec.uv(j,2),0,'w');
                    title('Session 2 place field with displacement vector noted')
                    hold off
                    waitforbuttonpress
                    
                end
                
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

if todebug
    close(hqc)
end
end

