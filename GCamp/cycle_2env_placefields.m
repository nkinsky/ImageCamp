% cycle_2env_placefields - currently used to cycle through and plots
% fields from the 19th and 22nd for G30

%%
close all
clear all

%% Directories

comp_name = 'norval';

if strcmpi(comp_name,'laptop')
    seshlist{1} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\';
    seshlist{2} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\2 - 2env square mid 201B\Working\';
    seshlist{3} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\1 - 2env octagon left\Working\';
    seshlist{4} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_20_2014\2 - 2env octagon right 90CCW\Working\';
    seshlist{5} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\1 - 2env square right 201B\Working\'; % Incorrect
    seshlist{6} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\2 - 2env square mid 90CW 201B\Working\'; % Incorrect
    seshlist{7} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\1 - 2env square right 201B\Working\';
    seshlist{8} = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_22_2014\2 - 2env square mid 90CW 201B\Working\';
    
    cell_register_file = 'C:\Users\Nat\Documents\BU\Imaging\Working\GCamp Mice\G30\2env\11_19_2014\1 - 2env square left 201B\Working\CellRegisterInfo.mat';
    
elseif strcmpi(comp_name,'norval')
    seshlist{1} = 'I:\GCamp Mice\G30\2env\Plots for HBE meeting 2015MAR12\11_19_2014\1 - 2env square left 201B\';
    seshlist{2} = 'I:\GCamp Mice\G30\2env\Plots for HBE meeting 2015MAR12\11_19_2014\2 - 2env square mid 201B\';
    seshlist{3} = 'I:\GCamp Mice\G30\2env\Plots for HBE meeting 2015MAR12\11_20_2014\1 - 2env octagon left\';
    seshlist{4} = 'I:\GCamp Mice\G30\2env\Plots for HBE meeting 2015MAR12\11_20_2014\2 - 2env octagon right 90CCW\';
    seshlist{5} = 'I:\GCamp Mice\G30\2env\Plots for HBE meeting 2015MAR12\11_21_2014\1 - 2env octagon mid 201B\';
    seshlist{6} = 'I:\GCamp Mice\G30\2env\Plots for HBE meeting 2015MAR12\11_21_2014\2 - 2env ocatgon left 90CW 201B\';
    seshlist{7} = 'I:\GCamp Mice\G30\2env\Plots for HBE meeting 2015MAR12\11_22_2014\1 - 2env square right 201B\';
    seshlist{8} = 'I:\GCamp Mice\G30\2env\Plots for HBE meeting 2015MAR12\11_22_2014\2 - 2env square mid 90CW 201B\';
    
    cell_register_file = 'I:\GCamp Mice\G30\2env\Plots for HBE meeting 2015MAR12\11_19_2014\1 - 2env square left 201B\CellRegisterInfo.mat';
end

daylist = [1 1 2 2 3 3 4 4];
sesh_use = [1 2 7 8];
session_title = [1 2 1 2 1 2 1 2];

% Get sessions to apply rotations to
rotate90CCW = cellfun(@(a) ~isempty(regexpi(a,'90CW')),seshlist);
rotate90CW = cellfun(@(a) ~isempty(regexpi(a,'90CCW')),seshlist);
rotate180 = cellfun(@(a) ~isempty(regexpi(a,'180')),seshlist);
rotate_array = rotate90CCW*1 + rotate180*2 + rotate90CW*3;
rot_title = {'90 degrees CCW' '180 degrees' '90 degrees CW'};

% Hack to go 180 with session 8
rotate_array(8) = 2;

%% Import Data
for j = 1:length(sesh_use)
    sesh{j}.PlaceMaps = importdata([seshlist{sesh_use(j)} 'PlaceMaps.mat']);
end

load(cell_register_file);
cell_reg_n = max(size(CellRegisterInfo));

% Get cell register file indices - I know, this is probably unnecessarily
% complicated, but was the best I could do for now
for j = 1:length(seshlist)
    temp = find(cellfun(@(a) ~isempty(a),regexpi(seshlist{j},CellRegisterInfo(cell_reg_n).cell_map_header(2,:))) ...
        & cellfun(@(a) ~isempty(a),regexpi(seshlist{j},CellRegisterInfo(cell_reg_n).cell_map_header(1,:))),1);
    if isempty(temp)
        cell_reg_ind(j) = 0;
    else
        cell_reg_ind(j) = temp;
    end
end

reg_ind_use = cell_reg_ind(sesh_use);

register_use = CellRegisterInfo(cell_reg_n).cell_map;
ICuse = CellRegisterInfo(cell_reg_n).GoodICf_comb;

%% Plot out it all

figure
for j = 1:size(register_use,1)
    for k = 1:length(sesh_use)
        subplot(2,length(sesh_use),k)
        if isempty(register_use{j,k+1})
            imagesc(zeros(size(sesh{1}.PlaceMaps.TMap{1})))
        else
            imagesc(rot90(sesh{k}.PlaceMaps.TMap{register_use{j,reg_ind_use(k)}},rotate_array(sesh_use(k))))
            if rotate_array(sesh_use(k)) ~= 0
               title(['Day ' num2str(daylist(sesh_use(k))) ' Session ' ...
                   num2str(session_title(sesh_use(k))) ' rotated ' ...
                   rot_title{rotate_array(sesh_use(k))}]);
            else
                title(['Day ' num2str(daylist(sesh_use(k))) ' Session ' ...
                   num2str(sesh_use(k)) ]);
            end
        end
        subplot(2,length(sesh_use),length(sesh_use)+k)
        imagesc(ICuse{j})
        if isempty(register_use{j,k+1})
        else
            title([ 'Cell number ' num2str(register_use{j,reg_ind_use(k)}) ])
        end
    end
    
    waitforbuttonpress
end

