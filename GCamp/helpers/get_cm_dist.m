function [ cm_dist ] = get_cm_dist( cms1, cms2, suppress_output )
% cm_dist = get_cm_dist( cms1, cms2, suppress_out )
%   Gets distances between ROI centers of mass in two sessions. cms1 and
%   cms2 must be nx2 or 2xn arrays of x,y center-of-mass values for each
%   neuron. If suppress_output is set to true you will get a progress bar
%   (default = false);

if nargin < 3
    suppress_output = true;
end

% Make cms nx2 vectors
if size(cms1,1) == 2
    cms1 = cms1';
end
if size(cms2,1) == 2
    cms2 = cms2';
end
n1 = size(cms1,1); n2 = size(cms2,1);
if ~suppress_output
    disp('Calculating Distances between cells')
    p = ProgressBar(n1);
end

%%
cm_dist = 100*ones(n1,n2); % Set all values to arbitrarily large distances to start.
for j = 1:n1 % Cycle through all base session neurons
    if ~isnan(cms1(j,1))
        cm1 = cms1(j,:); % Set base neuron location
        for m = 1:n2 % get distances to all registration session neurons
            if ~isnan(cms2(m,1))
                cm2 = cms2(m,:);
                % Calculate Distance
                cm_dist(j,m) = sqrt(sum(diff([cm1; cm2]).^2));
                
            elseif isnan(cms2(m,1))
                % Edge case where one of the neurons has disappeared during
                % registration (probably due to being near the edge of the
                % screen - shouldn't happen if you are using the same base
                % session for both Tenaspis and multi_image_reg, but can if you
                % are doing independent registrations
                cm_dist(j,m) = 100; % Set distance to very far for these neurons so they never get mapped to another neuron
            end
        end
        
        if ~suppress_output
            p.progress;
        end
    end
        
end

if ~suppress_output
    p.stop;
end
%%
end

