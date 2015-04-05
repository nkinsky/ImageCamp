% Analysis ideas after cell registration

close all
clear all

%% Look at how many cells are active each day
load CellRegisterInfo.mat

sesh_use = size(CellRegisterInfo,2);

num_sessions = size(CellRegisterInfo(sesh_use).cell_map,2)-1;

cell_map = CellRegisterInfo(sesh_use).cell_map;
GoodICf = CellRegisterInfo(sesh_use).GoodICf_comb;

active = ~cellfun(@(a) isempty(a),cell_map(:,2:num_sessions+1)); % Get cells that are active or not
active_days = sum(active,2);

for k = 1:max(active_days)
   active_index{k} = find(active_days == k); 
end

figure(100)
for m = 1:max(active_days)
   All_ICmask_days{m} = create_AllICmask(base_data.GoodICf_comb(active_index{m})); 
   subplot(2,3,m)
   imagesc(All_ICmask_days{m}*m); title(['Active ' num2str(m) ' Session(s) '])
end



n = hist(active_days,1:num_sessions);
figure 
subplot(1,2,1); plot(1:num_sessions,n); 
xlabel('Number sessions active'); ylabel('Count')
subplot(1,2,2); semilogy(1:num_sessions,n);
xlabel('Number sessions active'); ylabel('Count')

figure
All_active_ICs_comb = zeros(size(GoodICf{1}));
YTickLabel{1} = '0 sessions';
for j = 1:num_sessions
   active_index = find(active_days == j);
   All_active_ICs{j} = zeros(size(GoodICf{1}));
   for k = 1:size(active_index,1)
       All_active_ICs{j} = All_active_ICs{j} | GoodICf{active_index(k)};
   end
   subplot(2,3,j)
   imagesc(All_active_ICs{j})
   title(['Cells active in ' num2str(j) ' of ' num2str(num_sessions) 'sessions.']);
   
   All_active_ICs_comb = All_active_ICs_comb + All_active_ICs{j}*j;
   
   YTickLabel{j+1} = [num2str(j) ' sessions'];
   
end

figure; imagesc(All_active_ICs_comb); colorbar('YTick',0:num_sessions,...
    'YTickLabel',YTickLabel)
title('Number of Sessions cells are active')

%% Look at which day cells are active on

figure

for j = 1:num_sessions
    active_sesh{j} = find(active(:,j));
    
    All_active_ICs_byday{j} = zeros(size(GoodICf{1}));
    for k = 1:size(active_sesh{j},1)
       All_active_ICs_byday{j} = All_active_ICs_byday{j} | GoodICf{active_sesh{j}(k)};
    end
    subplot(2,3,j)
    imagesc(All_active_ICs_byday{j})
    title(['Cells active in session ' num2str(j) ' of ' num2str(num_sessions) '.']);
    
end


% Find cells that are active ONLY in a given session and not others
All_active_byday_comb = zeros(size(GoodICf{1}));


for j = 1:num_sessions
    loop = find(j ~= 1:num_sessions);
    active_sesh_only{j} = active(:,j);
    for m = 1:length(loop)
        active_sesh_only{j} = active_sesh_only{j} & ~active(:,loop(m));
    end
    active_sesh_only{j} = find(active_sesh_only{j});
    
    All_active_ICs_byday_only{j} = zeros(size(GoodICf{1}));
    for k = 1:size(active_sesh_only{j},1)
       All_active_ICs_byday_only{j} = (All_active_ICs_byday_only{j} + GoodICf{active_sesh_only{j}(k)}) - ...
           (All_active_ICs_byday_only{j} & GoodICf{active_sesh_only{j}(k)});
    end
    
    subplot(2,3,j)
    
    imagesc(All_active_ICs_byday{j})
    title(['Cells active in session ' num2str(j) ' of ' num2str(num_sessions) '.']);
    
    All_active_byday_comb = All_active_byday_comb + All_active_ICs_byday_only{j}*j...
        - (All_active_byday_comb & All_active_ICs_byday_only{j})*(1+j);
    
    YTickLabel{j+1} = ['Active Session ' num2str(j) ' only.'];
    
end


figure
imagesc(All_active_byday_comb); colorbar('YTick',0:num_sessions,...
    'YTickLabel',YTickLabel)
title('Active Cells by session')

%% Look at cell activations by day

