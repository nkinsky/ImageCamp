% Stats for SO_Schema_Pilot

%%% Stuff to incorporate
% 1) Check for number top/bottom in a row
% 2) Check for performance at different lags
% 3) Check for ordinal position of 10 item list (ABCDELMNOP or LMNOPABCDE)
% 4) Check for ...
% 5) Get heat maps for original task...
% 6)  #trials/block
% 7) ratio right by ordinal position (overall, b/w probes, within probes)
% 8) breakdown of letters chosen, position chosen (overall, b/w probes, within probes)
% 9) for b/w probes, how many pick earlier list over later list
% 10) Dig latency breakdown, also latency versus accuracy per animal?
% 11) Side selected (top versus bottom) overall and for each animal

%%%%% NOTE THAT xlsread appears to do different things on PCs and Macs!!!
%%%%% WTF!!!!

clear all
close all

% Enter odor lists here
list{1} = 'ABCDE';
list{2} = 'LMNOP';
if size(list{1},2) == size(list{2},2)
    list_size = size(list{1},2);
else
    error('Lists must be the same size!')
end

if ismac
    filename = '/Users/nkinsky/Dropbox-BU/Dropbox/Imaging Project/Sequential Order Schema Pilot/Sequential Order Schema Spreadsheet.xlsx';
    corr_col = 5; % Get column number for correct/incorrect
    pos_col = 8;
    top_col = 2;
    bott_col = 3;
    SC_col = 7;
elseif ispc
    filename = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Sequential Order Schema Pilot\Sequential Order Schema Spreadsheet.xlsx';
    corr_col = 7;
    pos_col = 10; % NRK - check this on PC!!!
    top_col = 4;
    bott_col = 5;
    SC_col = 9;
end

sheets = {'SO1','SO2','SO3','SO4'};
range = 'B5:K124';
position_str_default = 'TB';

% Import Data from Excel
for k = 1:size(sheets,2)
   [SO{k}.NUM SO{k}.TXT SO{k}.RAW] = xlsread(filename,sheets{k},range);
end

% Count numerical values (not NaNs) in last column, if greater than 20
% (10?), calculate performance...

calc_threshold = 20; % # of trials after which we calculate performance

num_animals = size(sheets,2);
max_num_blocks = 0;
for k = 1:num_animals 
    probe_col = corr_col - 1;% Get column number for probe type
    
    num_trials_total = sum(~isnan(SO{k}.NUM(:,size(SO{k}.NUM,2))));
    
    num_within_total = sum(cellfun(@(a,b) strcmp(a,'''W/IN''')&~isempty(b),...
        SO{k}.TXT(:,probe_col),SO{k}.TXT(:,corr_col)));
    num_bw_total = sum(cellfun(@(a,b) strcmp(a,'''B/W''')&~isempty(b),...
        SO{k}.TXT(:,probe_col),SO{k}.TXT(:,corr_col)));
    
    correct_index = cellfun(@(a) strcmp(a,'C')||strcmp(a,'CR'),SO{k}.TXT(:,corr_col));
    
    num_within_correct_total = sum(cellfun(@(a,b) strcmp(a,'''W/IN''')&(strcmp(b,'C')|...
        strcmp(b,'CR')),SO{k}.TXT(:,probe_col),SO{k}.TXT(:,corr_col)));
    num_bw_correct_total = sum(cellfun(@(a,b) strcmp(a,'''B/W''')&(strcmp(b,'C')|...
        strcmp(b,'CR')),SO{k}.TXT(:,probe_col),SO{k}.TXT(:,corr_col)));
    num_correct_total = num_within_correct_total + num_bw_correct_total;
    num_CR = sum(cellfun(@(a) strcmp(a,'CR'),SO{k}.TXT(:,corr_col)));
    SO{k}.stats.within_ratio_total = num_within_correct_total/num_within_total;
    SO{k}.stats.bw_ratio_total = num_bw_correct_total/num_bw_total;
    % Get spatial position where reward occurs
    clear position_str position_chosen position_index ordinal_pos_chosen
    position_index_corr = (cellfun(@(a) (~isempty(regexp(a,'\*'))+1),SO{k}.TXT(1:num_trials_total,bott_col))); % index for position of correct cup
    position_index_ic = (cellfun(@(a) (~isempty(regexp(a,'\*'))+1),SO{k}.TXT(1:num_trials_total,top_col))); % index for position of correct cup
    for m = 1:num_trials_total
       if size(SO{k}.TXT,2) > pos_col - 1
           if isempty(SO{k}.TXT{m,pos_col})
               position_str{m,:} = position_str_default;
           elseif ~isempty(SO{k}.TXT{m,pos_col})
               position_str{m,:} = [SO{k}.TXT{m,pos_col}(1) SO{k}.TXT{m,pos_col}(3)];
           end
       else
           position_str{m,:} = position_str_default;
       end
       position = position_str{m,:}(position_index_corr(m));
       SO{k}.stats.position{m,:} = position;
    end
    % Get spatial position chosen
    
    for p = 1:num_trials_total
       
        if correct_index(p) == 1
            position_chosen(p,1) = position_index_corr(p,1);
        elseif correct_index(p) == 0
            position_chosen(p,1) = position_index_ic(p,1);
        end
        
    end
    SO{k}.stats.position_chosen = position_chosen;
    
    % Get ordinal position of odor
    top_odor = cellfun(@(a) a(regexp(a,'\w')),SO{k}.TXT(1:num_trials_total,top_col));
    bott_odor = cellfun(@(a) a(regexp(a,'\w')),SO{k}.TXT(1:num_trials_total,bott_col));
    list_full = [list{1} list{2}];
    ordinal_pos_top = arrayfun(@(a) strfind(list_full,a),top_odor);
    ordinal_pos_top(ordinal_pos_top > list_size) = ordinal_pos_top(ordinal_pos_top > list_size) - list_size;
    ordinal_pos_bott = arrayfun(@(a) strfind(list_full,a),bott_odor);
    ordinal_pos_bott(ordinal_pos_bott > list_size) = ordinal_pos_bott(ordinal_pos_bott > list_size) - list_size;
    ordinal_pos_comb = [ordinal_pos_top ordinal_pos_bott];
    % insert code here to aggregate how many times each position was chosen
    for j = 1:num_trials_total
        ordinal_pos_chosen(j,1) = ordinal_pos_comb(j,position_chosen(j)); 
    end
    SO{k}.stats.ordinal_pos_chosen = ordinal_pos_chosen;
    % copy below to look at it by block... maybe rework some of this into a
    % function so I don't have to keep on reworking it for blocks each time???
    
    
    num_corr_top = sum(cellfun(@(a,b) (strcmp(a,'C')|strcmp(a,'CR'))&strcmp(b,'T'),...
        SO{k}.TXT(1:num_trials_total,corr_col),position_str));
    num_corr_bott = sum(cellfun(@(a,b) (strcmp(a,'C')|strcmp(a,'CR'))&strcmp(b,'B'),...
        SO{k}.TXT(1:num_trials_total,corr_col),position_str));
    num_top_total = sum(position == 'T');
    num_bott_total = sum(position == 'B');
    SO{k}.stats.top_corr_ratio = num_corr_top/num_top_total;
    SO{k}.stats.bottom_corr_ratio = num_corr_bott/num_bott_total;
    
    % Get Self-correct trials
    SC = cellfun(@(a) strcmp('Y',a),SO{k}.TXT(:,SC_col));
    SO{k}.SC_trials = find(SC); % Get trials for which we allowed self-correction
    
    num_blocks = round(num_trials_total/calc_threshold);
    
    % Dump all stats into blocks the size of calc_threshold
    for j = 1:num_blocks
        if calc_threshold*j < num_trials_total
            range_block = calc_threshold*(j-1)+1:calc_threshold*j;
        else
            range_block = calc_threshold*(j-1)+1:num_trials_total;
        end
        num_trials = sum(~isnan(SO{k}.NUM(range_block,size(SO{k}.NUM,2))));
        num_within = sum(cellfun(@(a,b) strcmp(a,'''W/IN''')&~isempty(b),...
            SO{k}.TXT(range_block,probe_col),SO{k}.TXT(range_block,corr_col)));
        num_bw = sum(cellfun(@(a,b) strcmp(a,'''B/W''')&~isempty(b),...
            SO{k}.TXT(range_block,probe_col),SO{k}.TXT(range_block,corr_col)));
        num_within_correct = sum(cellfun(@(a,b) strcmp(a,'''W/IN''')&(strcmp(b,'C')|...
            strcmp(b,'CR')),SO{k}.TXT(range_block,probe_col),SO{k}.TXT(range_block,corr_col)));
        num_bw_correct = sum(cellfun(@(a,b) strcmp(a,'''B/W''')&(strcmp(b,'C')|...
            strcmp(b,'CR')),SO{k}.TXT(range_block,probe_col),SO{k}.TXT(range_block,corr_col)));
        num_CR = sum(cellfun(@(a) strcmp(a,'CR'),SO{k}.TXT(range_block,corr_col)));
        num_correct = num_bw_correct + num_within_correct;
        SO{k}.stats.block{j}.within_ratio = num_within_correct/num_within;
        SO{k}.stats.block{j}.bw_ratio = num_bw_correct/num_bw;
        SO{k}.stats.block{j}.within_correct = num_within_correct;
        SO{k}.stats.block{j}.bw_correct = num_bw_correct;
        SO{k}.stats.block{j}.CR_IC_ratio = num_CR/(num_trials - num_correct); % #CRs / number incorrect trials
        SO{k}.stats.block{j}.CR = num_CR;
        SO{k}.stats.block{j}.num_within = num_within;
        SO{k}.stats.block{j}.num_bw = num_bw;    
        SO{k}.stats.block{j}.correct = num_bw_correct + num_within_correct;
        SO{k}.stats.block{j}.ordinal_pos_chosen = ...
            SO{k}.stats.ordinal_pos_chosen(range_block);
       
        
        SO{k}.stats.block{j}.trials = [min(range_block) max(range_block)];
        
    end
    max_num_blocks = max(max_num_blocks, num_blocks);
end


% Plots
figure
within_corr_vec = []; bw_corr_vec = []; within_num_vec = []; bw_num_vec = [];
for k = 1: num_animals
    % Get blocks for which we allow self-corrections
    SC_blocks = [];
    SC_blocks = SO{k}.SC_trials/calc_threshold;
    subplot(2,2,k); % Optimize this for any number of guys?
    within_plot = cellfun(@(a) a.within_ratio, SO{k}.stats.block);
    within_corr_vec = [within_corr_vec ...
        cellfun(@(a) a.within_correct, SO{k}.stats.block)];
    within_num_vec = [within_num_vec ....
        cellfun(@(a) a.num_within, SO{k}.stats.block)];
    bw_corr_vec = [bw_corr_vec ...
        cellfun(@(a) a.bw_correct, SO{k}.stats.block)];
    bw_num_vec = [bw_num_vec ....
        cellfun(@(a) a.num_bw, SO{k}.stats.block)];
    bw_plot = cellfun(@(a) a.bw_ratio, SO{k}.stats.block);
    plot(1:length(within_plot),within_plot,'bo-',1:length(bw_plot),bw_plot,'r*-.',...
        [0 max_num_blocks + 1], [0.5 0.5],'g:',...
        SC_blocks,0.05*ones(size(SC_blocks)),'k.');

    xlabel('Block Number'); ylabel('Ratio Correct'); 
    title(['Learning Curves for Probe Trials for Animal ',sheets{k}])
    xlim([0 max_num_blocks + 1]); ylim([0 1]);
    if k == 1
        legend('Within','Between','Chance','Self-Correct','Location','Best');
    else
    end
    
end

within_corr_overall = sum(within_corr_vec)/sum(within_num_vec);
bw_corr_overall = sum(bw_corr_vec)/sum(bw_num_vec);

% Exclude any animals here
exclude = 4; % If you want to exclude any animals from total analysis, list them here
temp = arrayfun(@(a) 1:num_animals ~= a, exclude,'UniformOutput',0);
k_range = 1:1:num_animals;
a = ones(1,num_animals);
for j = 1: size(temp,2)
    a = a & temp{j};
    
end
k_range = k_range(a);

for j = 1:max_num_blocks
    num_within_all = 0; num_bw_all = 0;
    corr_within_all = 0; corr_bw_all = 0;
    ordinal_pos_chosen_all = [];
    for n = 1:length(k_range)
        k = k_range(n);
        num_trials_total = sum(~isnan(SO{k}.NUM(:,size(SO{k}.NUM,2))));
        if calc_threshold*j < num_trials_total
            range_block = calc_threshold*(j-1)+1:calc_threshold*j;
        else
            range_block = calc_threshold*(j-1)+1:num_trials_total;
        end
        if j <= size(SO{k}.stats.block,2)
        num_within_all = num_within_all + SO{k}.stats.block{j}.num_within;
        num_bw_all = num_bw_all + SO{k}.stats.block{j}.num_bw;
        corr_within_all = corr_within_all + SO{k}.stats.block{j}.within_correct;
        corr_bw_all = corr_bw_all + SO{k}.stats.block{j}.bw_correct;
        ordinal_pos_chosen_all = [ordinal_pos_chosen_all; ...
            SO{k}.stats.block{j}.ordinal_pos_chosen];
        elseif j > size(SO{k}.stats.block,2)
        end 
            
    end
  % Sum up total bw and within correct and num trials for ALL animals here
  % in two vectors...
  All_Animals.block{j}.num_within = num_within_all;
  All_Animals.block{j}.num_bw = num_bw_all;
  All_Animals.block{j}.within_correct = corr_within_all;
  All_Animals.block{j}.bw_correct = corr_bw_all;
  All_Animals.block{j}.within_ratio = corr_within_all/num_within_all;
  All_Animals.block{j}.bw_ratio = corr_bw_all/num_bw_all;
  All_Animals.block{j}.ordinal_pos_chosen = ordinal_pos_chosen_all;
end
   
% Plots
figure
within_corr_vec = []; bw_corr_vec = []; within_num_vec = []; bw_num_vec = [];

within_plot = cellfun(@(a) a.within_ratio, All_Animals.block);
within_corr_vec = [within_corr_vec ...
    cellfun(@(a) a.within_correct, All_Animals.block)];
within_num_vec = [within_num_vec ....
    cellfun(@(a) a.num_within, All_Animals.block)];
bw_corr_vec = [bw_corr_vec ...
    cellfun(@(a) a.bw_correct, All_Animals.block)];
bw_num_vec = [bw_num_vec ....
    cellfun(@(a) a.num_bw, All_Animals.block)];
bw_plot = cellfun(@(a) a.bw_ratio, All_Animals.block);
plot(1:length(within_plot),within_plot,'bo-',1:length(bw_plot),bw_plot,'r*-.',...
    [0 max_num_blocks + 1], [0.5 0.5],'g:');
xlabel('Block Number'); ylabel('Ratio Correct'); 
legend('Within','Between','Location','NorthWest');
title('Learning Curves for Probe Trials for All Animals ')
xlim([0 max_num_blocks + 1]); ylim([0 1]);

% Ordinal Position Breakdown
%%% NRK - combine for ALL ANIMALS to see if there is any progress!
figure
ord_pos_all = [];
for j = 1:max_num_blocks
    ord_pos_all = [ord_pos_all ; All_Animals.block{j}.ordinal_pos_chosen];
end
n_ord_all = hist(ord_pos_all,1:list_size);
bar(1:list_size,n_ord_all,'hist')
xlabel('Ordinal Position Chosen'); ylabel('Count')
title('Ordinal Position Histogram for All Animals');


figure
for j = 1:max_num_blocks
    subplot(1,max_num_blocks,j)
    n_ord_block_all = hist(All_Animals.block{j}.ordinal_pos_chosen,1:list_size);
    bar(1:list_size,n_ord_block_all,'hist')
    xlabel('Ordinal Position Chosen'); ylabel('Count')
    title(['Ordinal Position, All Animals, Block ' num2str(j)]);
end

figure
for k = 1:num_animals
    
   subplot(2,2,k) 
   n_ordinal = hist(SO{k}.stats.ordinal_pos_chosen,1:list_size);
   bar(1:list_size,n_ordinal,'hist')
   xlabel('Ordinal Position Chosen'); ylabel('Count')
   title(['Ordinal Position Histogram for Animal ',sheets{k}])
end

% Ordinal Position by Block Breakdown
figure
for k = 1:num_animals
    num_blocks = size(SO{k}.stats.block,2);
    for j = 1:num_blocks
        subplot(num_animals,num_blocks,j) %% NRK Adjust to get all in one plot!
        n_ordinal = hist(SO{k}.stats.block{j}.ordinal_pos_chosen,1:list_size);
        bar(1:list_size,n_ordinal,'hist')
        xlabel('Ordinal Position Chosen'); ylabel('Count')
        title(['Ordinal Position Histogram for Animal ',sheets{k} ' for Block '...
            num2str(j)])

    end
    
end


% Spatial Position Breakdown
figure
for k = 1:num_animals
    subplot(2,2,k)
    n_spatial = hist(SO{k}.stats.position_chosen,1:2);
    bar(1:2,n_spatial,'hist')
    xlabel('Spatial Position Chosen'); ylabel('Count')
    title(['Spatial Position Histogram for Animal ',sheets{k}])
end



