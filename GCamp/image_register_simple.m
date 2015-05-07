function [ cell_id] = image_register_simple( base_file, reg_file)
%image_register_simple( base_file, reg_file)
%   Detailed explanation goes here

%% Magic variables
min_thresh = 3; % distance in pixels beyond which we consider a cell a different cell

manual_reg_enable = 0;

%% Perform Image Registration
RegistrationInfoX = image_registerX(base_file, reg_file, 0);

%% Get working folders for each session

sesh(1).folder = base_file(1:max(regexpi(base_file,'\\'))-1);
sesh(2).folder = reg_file(1:max(regexpi(reg_file,'\\'))-1);

%% Get centers-of-mass of all cells after registering 2nd image to 1st image
for k = 1:2
    cd(sesh(k).folder);
    load('ProcOut.mat','NeuronImage');
    if k == 2 % Don't get registration info if base session
        keyboard
        [tform_struct ] = get_reginfo(sesh(1).folder, sesh(2).folder, RegistrationInfoX );
    end
    disp('Calculating cell center of masses')
    for j = 1:size(NeuronImage,2);
        temp = NeuronImage{j};
        if k == 2 % Don't do registration if base session
            neuron_image_use = imwarp(temp,tform_struct.tform,'OutputView',...
                tform_struct.base_ref,'InterpolationMethod','nearest');
        elseif k == 1
            neuron_image_use = temp;
        end
        [it, jt] = find(neuron_image_use == 1);
        day(k).cms(j).x = mean(jt);
        day(k).cms(j).y = mean(it);
        day(k).NeuronImage_reg{j} = neuron_image_use;
    end
end

%% Get distance to all other cells
for j = 1:size(day(1).cms,2);
    pos_cm(:,1) = [day(1).cms(j).x ; day(1).cms(j).y];
    for m = 1:size(day(2).cms,2)
        pos_cm(:,2) = [day(2).cms(m).x ; day(2).cms(m).y];
        temp = dist(pos_cm);
        cm_dist(j,m) = temp(1,2);
        
    end
end

cm_dist_min = min(cm_dist,[],2);

n = 0;
for j = 1:length(cm_dist_min)
    if cm_dist_min(j) > min_thresh
        cell_id{j} = [];
        n = n+1;
    else
        cell_id{j} = find(cm_dist_min(j) == cm_dist(j,:));
    end
    
end

% Check to see if any cells from session 1 map to the same cell in session
% 2 or vice versa
for j = 1:size(cell_id,2)-1; 
    for k = j+1:size(cell_id,2)
        if cell_id{j} == cell_id{k} 
            same_cell(j,k) = 1;
        else
            same_cell(j,k) = 0;
        end
    end
end

num_same = sum(same_cell(:));
num_notassigned = n;

%% Plot out combined sessions
for k = 1:2
   sesh(k).AllNeuronMask = create_AllICmask(day(k).NeuronImage_reg); 
end

figure;
imagesc(sesh(1).AllNeuronMask + 2*sesh(2).AllNeuronMask); colorbar
title('1 = session 1, 2 = session 2, 3 = both sessions')

keyboard

end

