% Script to cycle through and place fields and ICs from each cell for G30
% for his 9/23-10/7 triangular track sessions.

% MAKE THIS INTO A FUNCTION - input = any number of directories and
% CellRegisterBase.mat...



close all

directory{1} = 'I:\GCamp Mice\G31\10_14_2014\triangle track 201B\IC400-Objects\Obj_1';
directory{2} = 'I:\GCamp Mice\G31\10_14_2014\triangle track rotated plus 120 201B\IC400_downsample_usingICmovie_spatialmean_min_proj-Objects\Obj_1';

% directory{1} = 'I:\GCamp Mice\G30\9_23_2014\1 - triangle track 201B';
% directory{2} = 'I:\GCamp Mice\G30\9_23_2014\2 - triangle track 201A';
% directory{3} = 'I:\GCamp Mice\G30\9_24_2014\1 - triangle track 201A';
% directory{4} = 'I:\GCamp Mice\G30\9_24_2014\2 - triangle track 201B';
% directory{5} = 'I:\GCamp Mice\G30\10_7_2014\1 - triangle track 201B';

header = {'triangle track' 'rotated 120 degrees CCW'};

num_sessions = size(directory,2);

reginfo = importdata([directory{1} '\CellRegisterInfo.mat']);
sesh_last = size(reginfo,2);

%% Load sessions, unless already in the workspace
if ~exist('session') || size(session,2) ~= num_sessions
session = struct;
for j = 1:size(directory,2)
    temp = load([directory{j} '\PlaceMaps.mat'],'AdjMap');
    session(j).AdjMap = temp.AdjMap;
    temp1 = load([directory{j} '\FinalTraces.mat'],'IC');
    session(j).IC = temp1.IC;
    temp2 = load([directory{j} '\FinalTraces.mat'],'ICnz');
    session(j).ICnz = temp2.ICnz;
end
else
end

%% Scroll through place fields

% start_cell = 196;
% end_cell = size(reginfo.cell_map,1);
% rand_indices = randperm(length(196:size(reginfo.cell_map,1)),183);

% Get Size of AdjMap
xmax = size(AdjMap{1},1);
ymax = size(AdjMap{1},2);
xlims = 1:1:xmax;
ylims = ymax:-1:1; % This plots everthing the right way! Imagesc likes to flip stuff upside down.

for k = 1:size(reginfo(sesh_last).cell_map,1)
        disp(['Now displaying cell number ' num2str(k)])
    cell_map = reginfo(sesh_last).cell_map(k,:);
    
    for j = 1:num_sessions
        figure(1)
        if ~isempty(cell_map{j+1})
            subplot(2,num_sessions,j)
            imagesc(xlims,ylims,session(j).AdjMap{cell_map{j+1}})
            title(header{j});
            subplot(2,num_sessions,num_sessions+j)
            imagesc(xlims,ylims,session(j).IC{cell_map{j+1}})
        else
            subplot(2,num_sessions,j)
            imagesc(zeros(size(session(j).AdjMap{1})))
            subplot(2,num_sessions,num_sessions+j)
            imagesc(zeros(size(session(j).IC{1})))
        end
        
%         subplot(2,4,2)
%         imagesc(session(2).AdjMap{cell_map{3}})
%         subplot(2,4,5)
%         imagesc(session(2).IC{cell_map{3}})
%         subplot(2,4,3)
%         imagesc(session(3).AdjMap{cell_map{4}})
%         subplot(2,4,6)
%         imagesc(session(3).IC{cell_map{4}})
    end
%     day1stable = input('Is day 1 stable (y/n)? ','s');
%     day1_2stable = input('Is day 1 to 2 stable (y/n)? ' ,'s');
%     day2stable = input('Is day 2 stable (y/n)? ','s');
%     day2_14stable= input('Is day 2 to 14 stable (y/n)? ' ,'s');
    
%     stability_tracking(k,1) = strcmpi(day1stable,'y');
%     stability_tracking(k,2) = strcmpi(day1_2stable,'y');
%     stability_tracking(k,3) = strcmpi(day2stable,'y');
%     stability_tracking(k,4) = strcmpi(day2_14stable,'y');
    
    waitforbuttonpress;

end

%% Manually scroll through place fields

k = 1
button = 1;

while button ~= 113
    switch button
        case 30 % up
            k = k + 1
            
        case 31 % down
            k = k - 1
%         case 99 % c
%             stable(k
%         case 115 % s
%         case 114 % r
        
        otherwise
            display('Hit up or down!')
    end
    
    figure(1)
    for j = 1:num_sessions
        if ~isempty(cell_map{j+1})
            subplot(2,num_sessions,j)
            imagesc(session(j).AdjMap{cell_map{j+1}})
            title(header{j});
            subplot(2,num_sessions,num_sessions+j)
            imagesc(session(j).IC{cell_map{j+1}})
        else
            subplot(2,num_sessions,j)
            imagesc(zeros(size(session(j).AdjMap{1})))
            subplot(2,num_sessions,num_sessions+j)
            imagesc(zeros(size(session(j).IC{1})))
        end
    end
        day1stable = input('Is day 1 stable (y/n)? ','s');
        day2stable = input('Is day 2 stable (y/n)? ','s');
        day2_14stable= input('Is day 2 to 14 stable (y/n)? ' ,'s');
        [x y button] = ginput(1);
    
end
