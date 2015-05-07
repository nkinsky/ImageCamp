% Script to approximate cell registration between days for alternation
% sessions and see if splitters continue to split

sesh(1).folder = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_11_2014\Working';
sesh(1).tform_ind = 4;
sesh(3).folder = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\11_13_2014\Working';
sesh(1).tform_ind = 2;
calib_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\alternation\RegistrationInfoX.mat';
load(calib_file);

for k = 1:2:3
    cd(sesh(k).folder);
    load('ProcOut.mat','NeuronImage');
    [tform_struct ] = get_reginfo( sesh(k).folder, RegistrationInfoX );
    for j = 1:size(NeuronImage,2);
        temp = NeuronImage{j};
        neuron_image_use = imwarp(temp,tform_struct.tform,'OutputView',...
                tform_struct.base_ref,'InterpolationMethod','nearest');
        [it, jt] = find(neuron_image_use == 1);
        day(k).cms(j).x = mean(jt);
        day(k).cms(j).y = mean(it);
        day(k).NeuronImage_reg{j} = neuron_image_use;
    end
end

%% Get distance to all other cells
for j = 1:size(day(1).cms,2);
    pos_cm(:,1) = [day(1).cms(j).x ; day(1).cms(j).y];
    for m = 1:size(day(3).cms,2)
        pos_cm(:,2) = [day(3).cms(m).x ; day(3).cms(m).y];
        temp = dist(pos_cm);
        cm_dist(j,m) = temp(1,2);
        
    end
end

cm_dist_min = min(cm_dist,[],2);

min_thresh = 3; % distance in pixels beyond which we consider a cell a different cell
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
