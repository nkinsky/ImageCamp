% Script to get aligned data center arm location

sesh_use = MD(ref.G30_scalefix);
figure; 
xall = [];
yall = [];
subplot(3,2,1:4)
for j = 1:length(sesh_use)   
    load(fullfile(sesh_use(j).Location,'Placefields_cm1.mat'),'x','y');
    hold on
    plot(x,y)
    xall = [xall x];
    yall = [yall y]; 
end
pause(0.1)
disp('draw rectangle over center stem on plot')
rect = getrect;
hold on;
hr = rectangle('Position', rect); 
set(hr, 'LineStyle', '--', 'EdgeColor', 'r')
disp('Now draw rectangle around all valid data')
data_lim = getrect;
hr2 = rectangle('Position', data_lim);
set(hr2, 'LineStyle', '-.', 'EdgeColor', 'k')
subplot(3,2,5)
edges = floor(min(xall)):2:ceil(max(xall));
histogram(xall,edges);
xlabel('x position')
% zoom in and identify first and last peak of histogram and enter those
% numbers below as bot_arm and top_arm
subplot(3,2,6)
histogram(yall)
xlabel('y position')
% Zoom in and ID center stem location, note below.

%% Adjust
center_prop = 0.70; % proportion of the maze length that is considered center stem
LRoffset = 5; % half of effective arm width
bot_arm = 9; % Located on left of x pos graph
top_arm = 61; % Right of x pos graph
left_arm = 17; % Bottom of y pos graph
right_arm = 34; % Top of y pos graph
center_loc = 25.5;

w = ceil(rect(4));
l = (top_arm - bot_arm)*center_prop;
offset = (1-center_prop)/2;
rect_manual = [bot_arm + offset*(top_arm - bot_arm), center_loc - w/2, l, w];
data_lim2 = [bot_arm - LRoffset, left_arm - LRoffset, ...
    top_arm - bot_arm + 2*LRoffset, right_arm - left_arm + 2*LRoffset];
% subplot(3,2,1:4)
% hold on; rectangle('Position',rect_manual)

for k = 1:ceil(length(sesh_use)/15)
    sesh_use2 = sesh_use(((k-1)*15+1):min([k*15,length(sesh_use)]));
    hf = figure;
    for j = 1:length(sesh_use2)
        subplot(5,3,j);
        load(fullfile(sesh_use2(j).Location,'Placefields_cm1.mat'),'x','y');
        plot(x,y);
        hold on;
        hr = rectangle('Position',rect_manual);
        set(hr, 'LineStyle', '--', 'EdgeColor', 'r')
        hr2 = rectangle('Position', data_lim2);
        set(hr2, 'LineStyle', '-.', 'EdgeColor', 'k')
        title(sesh_to_text(sesh_use2(j)))
    end
    printNK([sesh_use(j).Animal ' center stem on trajectories'], 'alt',...
        'hfig', hf, 'append', true)
end

%% If good, save it all
center.x = [rect_manual(1), rect_manual(1)+rect_manual(3), ...
    rect_manual(1)+rect_manual(3), rect_manual(1)];
center.y = [rect_manual(2), rect_manual(2), rect_manual(2) + rect_manual(4), ...
    rect_manual(2) + rect_manual(4)];
xmin = data_lim2(1); xmax = data_lim2(1) + data_lim2(3);
ymin = data_lim2(2); ymax = data_lim2(2) + data_lim2(4);
for j = 1:length(sesh_use)
    save(fullfile(sesh_use(j).Location,'centerarm_manual.mat'), 'center',...
        'xmin', 'xmax', 'ymin', 'ymax')
end

%% After doing this, save and rename all files with _archive appended so that we can
% re-run all the splitter batch functions again
recycle('on') % Make sure files are being recycled and not permanently deleted!
for j = 1:length(sesh_use)
    ChangeDirectory_NK(sesh_use(j));
    try
        copyfile Alternation.mat Alternation_archive.mat
        copyfile splittersByTrialType.mat splittersByTrialType_archive.mat
        copyfile sigSplitters.mat sigSplitters_archive.mat
        copyfile splitters.mat splitters_archive.mat
        delete Alternation.mat splittersByTrialType.mat sigSplitters.mat splitters.mat
    catch
       disp(['Archive failure for session ' num2str(j) '. Check manually!']) 
    end
end




