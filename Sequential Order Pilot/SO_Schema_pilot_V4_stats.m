
% Stats for SO_Schema_Pilot
%%% priority
% 1) do lag analysis - see if they are performing better at diff lags
% 2) Look at CRs...do they occur preferentially for certain odors?

%%% Stuff to incorporate - if there is time
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
    filename = '/Users/nkinsky/Dropbox-BU/Dropbox/Imaging Project/Sequential Order Schema Pilot/Sequential Order Schema Spreadsheet V4.xlsx';
    corr_col = 5; % Get column number for correct/incorrect
    pos_col = 8;
    top_col = 2;
    bott_col = 3;
    SC_col = 7;
elseif ispc
    filename = 'C:\Users\kinsky.AD\Dropbox\Imaging Project\Sequential Order Schema Pilot\Sequential Order Schema Spreadsheet V4.xlsx';
    corr_col = 7;
    pos_col = 10; % NRK - check this on PC!!!
    top_col = 4;
    bott_col = 5;
    SC_col = 9;
end

sheets = {'SO1','SO2','SO3','SO4'};
range = 'B5:K164';
position_str_default = 'TB';

% Import Data from Excel
for k = 1:size(sheets,2)
   [SO{k}.NUM SO{k}.TXT SO{k}.RAW] = xlsread(filename,sheets{k},range);
end


calc_threshold = 10; % # of trials after which we calculate performance

% Pull stats from data structure and organize by animal.
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
    
    num_cr_total = sum(cellfun(@(a) strcmp(a,'CR'),SO{k}.TXT(:,corr_col)));
    
    num_within_correct_total = sum(cellfun(@(a,b) strcmp(a,'''W/IN''')&(strcmp(b,'C')|...
        strcmp(b,'CR')),SO{k}.TXT(:,probe_col),SO{k}.TXT(:,corr_col)));
    num_bw_correct_total = sum(cellfun(@(a,b) strcmp(a,'''B/W''')&(strcmp(b,'C')|...
        strcmp(b,'CR')),SO{k}.TXT(:,probe_col),SO{k}.TXT(:,corr_col)));
    num_correct_total = num_within_correct_total + num_bw_correct_total;
    num_CR = sum(cellfun(@(a) strcmp(a,'CR'),SO{k}.TXT(:,corr_col)));
    SO{k}.stats.within_ratio_total = num_within_correct_total/num_within_total;
    SO{k}.stats.bw_ratio_total = num_bw_correct_total/num_bw_total;
    % Get spatial position where reward occurs
    clear position_str position_chosen position_index ordinal_pos_chosen lags
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
    lags = abs(ordinal_pos_top - ordinal_pos_bott) - 1;
    % insert code here to aggregate how many times each position was chosen
    for j = 1:num_trials_total
        ordinal_pos_chosen(j,1) = ordinal_pos_comb(j,position_chosen(j)); 
    end
    SO{k}.stats.ordinal_pos_chosen = ordinal_pos_chosen;
    SO{k}.stats.lags = lags;
    SO{k}.stats.lags_corr = lags(correct_index(1:num_trials_total)); % Get lag values for correct and incorrect probes
    SO{k}.stats.lags_ic = lags(~correct_index(1:num_trials_total));
    n_temp = hist(ordinal_pos_comb,1:list_size);
    n_ord_presented = sum(n_temp,2);
    % copy below to look at it by block... maybe rework some of this into a
    % function so I don't have to keep on reworking it for blocks each time???
    SO{k}.stats.n_ordinal_pos_presented = n_ord_presented; % Number of times each ordinal position was presented
    
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
    COV2 = cellfun(@(a) strcmp('COV2',a),SO{k}.TXT(:,SC_col));
    COV3 = cellfun(@(a) strcmp('COV3',a),SO{k}.TXT(:,SC_col));
    SO{k}.SC_trials = find(SC); % Get trials for which we allowed self-correction
    SO{k}.COV2_trials = find(COV2); % Get trials where we ran the sequences normally but covered poth pots in the probe trials
    SO{k}.COV3_trials = find(COV3); % Get trials where we ran the sequences in the AM, then covered probe trials only in the PM
    
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
        lags_block_corr = lags(correct_index(range_block));
        lags_block_ic = lags(~correct_index(range_block));
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
        n_temp2 = hist(ordinal_pos_comb(range_block,:),1:list_size);
        SO{k}.stats.block{j}.n_ordinal_pos_presented = sum(n_temp2,2);
        SO{k}.stats.block{j}.lags_corr = lags_block_corr;
        SO{k}.stats.block{j}.lags_ic = lags_block_ic;
        SO{k}.stats.block{j}.trials = [min(range_block) max(range_block)];
        
        
    end
    max_num_blocks = max(max_num_blocks, num_blocks);
end


% Plots
%% PLOT LEARNING CURVES FOR INDIVIDUAL ANIMALS
figure

for k = 1: num_animals
    within_corr_vec{k} = []; bw_corr_vec{k} = []; within_num_vec{k} = []; bw_num_vec{k} = [];
    % Get blocks for which we allow self-corrections
    SC_blocks{k} = []; COV2_blocks = []; COV3_blocks = [];
    SC_blocks{k} = SO{k}.SC_trials/calc_threshold;
    COV2_blocks{k} = SO{k}.COV2_trials/calc_threshold;
    COV3_blocks{k} = SO{k}.COV3_trials/calc_threshold;
    subplot(2,2,k); % Optimize this for any number of guys?
    within_plot{k} = cellfun(@(a) a.within_ratio, SO{k}.stats.block);
    within_corr_vec{k} = [within_corr_vec{k} ...
        cellfun(@(a) a.within_correct, SO{k}.stats.block)];
    within_num_vec{k} = [within_num_vec{k} ....
        cellfun(@(a) a.num_within, SO{k}.stats.block)];
    bw_corr_vec{k} = [bw_corr_vec{k} ...
        cellfun(@(a) a.bw_correct, SO{k}.stats.block)];
    bw_num_vec{k} = [bw_num_vec{k} ....
        cellfun(@(a) a.num_bw, SO{k}.stats.block)];
    bw_plot{k} = cellfun(@(a) a.bw_ratio, SO{k}.stats.block);
    plot(1:length(within_plot{k}),within_plot{k},'bo-',1:length(bw_plot{k}),bw_plot{k},'r*-.',...
        [0 max_num_blocks + 1], [0.5 0.5],'g:',...
        SC_blocks{k},0.05*ones(size(SC_blocks{k})),'k.',...
        COV2_blocks{k},0.05*ones(size(COV2_blocks{k})),'md',...
        COV3_blocks{k},0.05*ones(size(COV3_blocks{k})),'cs');

    xlabel('Block Number'); ylabel('Ratio Correct'); 
    title(['Learning Curves for Probe Trials for Animal ',sheets{k}])
    xlim([0 max_num_blocks + 1]); ylim([0 1]);
    if k == 1
        legend('Within','Between','Chance','Self-Correct','Covered','Covered - Separate Probes','Location','Best');
    else
    end
    
end

within_corr_overall = sum(within_corr_vec{k})/sum(within_num_vec{k});
bw_corr_overall = sum(bw_corr_vec{k})/sum(bw_num_vec{k});

%% Exclude any animals here
exclude = []; % If you want to exclude any animals from total analysis, list them here
if isempty(exclude)
    for j = 1:num_animals
        temp{j} = 1;
    end
else
    temp = arrayfun(@(a) 1:num_animals ~= a, exclude,'UniformOutput',0);
end
k_range = 1:1:num_animals;
a = ones(1,num_animals);
for j = 1: size(temp,2)
    a = a & temp{j};
    
end
k_range = k_range(a);

%% AGGREGATE INDIVIDUAL ANIMAL STATS INTO ONE GROUP FOR GROUP ANALYSIS
for j = 1:max_num_blocks
    num_within_all = 0; num_bw_all = 0;
    corr_within_all = 0; corr_bw_all = 0;
    ordinal_pos_chosen_all = [];
    n_ordinal_pos_presented_all = 0;
    lags_corr = []; lags_ic = [];
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
        n_ordinal_pos_presented_all = n_ordinal_pos_presented_all + ...
            SO{k}.stats.block{j}.n_ordinal_pos_presented;
        lags_corr = [lags_corr ; SO{k}.stats.block{j}.lags_corr];
        lags_ic = [lags_ic ; SO{k}.stats.block{j}.lags_ic];
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
  All_Animals.block{j}.n_ordinal_pos_presented = n_ordinal_pos_presented_all;
end
   
%% PLOT LEARNING CURVE FOR ALL ANIMALS COMBINED (MINUS ANY EXCLUDED ABOVE)
figure
within_corr_vec_all = []; bw_corr_vec_all = []; within_num_vec_all = []; bw_num_vec_all = [];
within_plot_all = cellfun(@(a) a.within_ratio, All_Animals.block);
within_corr_vec_all = [within_corr_vec_all ...
    cellfun(@(a) a.within_correct, All_Animals.block)];
within_num_vec_all = [within_num_vec_all ....
    cellfun(@(a) a.num_within, All_Animals.block)];
bw_corr_vec_all = [bw_corr_vec_all ...
    cellfun(@(a) a.bw_correct, All_Animals.block)];
bw_num_vec_all = [bw_num_vec_all ....
    cellfun(@(a) a.num_bw, All_Animals.block)];
bw_plot_all = cellfun(@(a) a.bw_ratio, All_Animals.block);
plot(1:length(within_plot_all),within_plot_all,'bo-',1:length(bw_plot_all),bw_plot_all,'r*-.',...
    [0 max_num_blocks + 1], [0.5 0.5],'g:');
xlabel('Block Number'); ylabel('Ratio Correct'); 
legend('Within','Between','Location','NorthWest');
title('Learning Curves for Probe Trials for All Animals ')
xlim([0 max_num_blocks + 1]); ylim([0 1]);

%% ORDINAL POSITION PLOTS %%%
% ALL ANIMALS, ALL BLOCKS COMBINED
figure
ord_pos_all = []; n_ord_pos_pres_all = 0;
for j = 1:max_num_blocks
    ord_pos_all = [ord_pos_all ; All_Animals.block{j}.ordinal_pos_chosen];
    n_ord_pos_pres_all = n_ord_pos_pres_all + All_Animals.block{j}.n_ordinal_pos_presented;
end
n_ord_all = hist(ord_pos_all,1:list_size);
bar(1:list_size,n_ord_all./n_ord_pos_pres_all','hist')
xlabel('Ordinal Position Chosen'); ylabel('Ratio')
ylim([0 1])
title('Ordinal Position Histogram for All Animals');

% ALL ANIMALS, BY BLOCK
figure
for j = 1:max_num_blocks
    subplot(1,max_num_blocks,j)
    n_ord_block_all = hist(All_Animals.block{j}.ordinal_pos_chosen,1:list_size);
    bar(1:list_size,n_ord_block_all./All_Animals.block{j}.n_ordinal_pos_presented','hist')
    xlabel('Ordinal Position Chosen'); ylabel('Ratio')
    title(['Ordinal Position, All Animals, Block ' num2str(j)]);
    ylim([0 1])
end

% INDIVIDUAL ANIMALS, ALL BLOCKS COMBINED
figure
for k = 1:num_animals
    
   subplot(2,2,k) 
   n_ordinal{k} = hist(SO{k}.stats.ordinal_pos_chosen,1:list_size);
   bar(1:list_size,n_ordinal{k}./SO{k}.stats.n_ordinal_pos_presented','hist')
   xlabel('Ordinal Position Chosen'); ylabel('Ratio')
   title(['Ordinal Position Histogram for Animal ',sheets{k}])
   ylim([0 1])
end

% INDIVIDUAL ANIMAL BY BLOCK
figure
for k = 1:num_animals
    num_blocks = size(SO{k}.stats.block,2);
    for j = 1:num_blocks
        subplot(num_animals,max_num_blocks,(k-1)*max_num_blocks+j) %% NRK Adjust to get all in one plot!
        n_ordinal_all = hist(SO{k}.stats.block{j}.ordinal_pos_chosen,1:list_size);
        bar(1:list_size,n_ordinal_all./SO{k}.stats.block{j}.n_ordinal_pos_presented','hist')
        xlabel('Ordinal Position Chosen'); ylabel('Ratio')
        title(['Ordinal Position Histogram for Animal ',sheets{k} ' for Block '...
            num2str(j)])
        ylim([0 1])
    end
    
end


%% SPATIAL POSITION BREAKDOWN BY ANIMAL
 % less useful when positions are being moved around, only a good metric if
 % probe cups are always presented in a consistent position
figure
for k = 1:num_animals
    subplot(2,2,k)
    n_spatial = hist(SO{k}.stats.position_chosen,1:2);
    bar(1:2,n_spatial,'hist')
    xlabel('Spatial Position Chosen'); ylabel('Count')
    title(['Spatial Position Histogram for Animal ',sheets{k}])
end

%% LAGS BY ANIMAL - PLOT
figure
for k = 1:num_animals
    subplot(2,2,k)
    nlag_corr{k} = hist(SO{k}.stats.lags_corr,0:1:max(SO{k}.stats.lags));
    nlag_tot{k} = hist(SO{k}.stats.lags,0:1:max(SO{k}.stats.lags));
    bar(0:1:max(SO{k}.stats.lags),nlag_corr{k}./nlag_tot{k});
    xlabel('Lag'); ylabel('Ratio Correct')
    title(['Lag Histogram for Animal ',sheets{k}])
    xlim([-1 max(SO{k}.stats.lags) + 1]);
    ylim([0 1]);
    
end

%% CORRECT REJECTS BY ANIMAL
figure
for k = 1:num_animals
    subplot(2,2,k)
    num_blocks(k) = size(SO{k}.stats.block,2);
    CR{k} = [];
    x_CR{k} = 1:1:num_blocks(k);
    for j = 1:num_blocks(k)
        num_tr_in_block{k} = SO{k}.stats.block{j}.trials(2)-SO{k}.stats.block{j}.trials(1) + 1;
        CR{k}(j) = SO{k}.stats.block{j}.CR;
    
    end
    plot(x_CR{k},CR{k},'bo-')
    xlabel('Block'); ylabel('# CR');
    title(['Correct Rejects for Animal ',sheets{k}])
    ylim([0 calc_threshold]);
    
end

%% PLOT EVERYTHING FOR EACH ANIMAL
for k = 1:num_animals
    figure
    % Learning Curves
    subplot(2,2,1)
    plot(1:length(within_plot{k}),within_plot{k},'bo-',1:length(bw_plot{k}),bw_plot{k},'r*-.',...
        [0 max_num_blocks + 1], [0.5 0.5],'g:',...
        SC_blocks{k},0.05*ones(size(SC_blocks{k})),'k.')
    xlabel('Block Number'); ylabel('Ratio Correct'); 
    title(['Learning Curves for Probe Trials for Animal ',sheets{k}])
    xlim([0 max_num_blocks + 1]); ylim([0 1]);
    legend('Within','Between','Chance','Self-Correct','Location','Best');
    
    % Ordinal Position
    subplot(2,2,2)
    bar(1:list_size,n_ordinal{k}./SO{k}.stats.n_ordinal_pos_presented','hist')
    xlabel('Ordinal Position Chosen'); ylabel('Ratio')
    title(['Ordinal Position Histogram for Animal ',sheets{k}])
    
    % Lags
    subplot(2,2,4)
    bar(0:1:max(SO{k}.stats.lags),nlag_corr{k}./nlag_tot{k});
    xlabel('Lag'); ylabel('Ratio Correct')
    title(['Lag Histogram for Animal ',sheets{k}])
    xlim([-1 max(SO{k}.stats.lags) + 1]);
    ylim([0 1]);
    
    % Correct Rejects
    subplot(2,2,3)
    plot(x_CR{k},CR{k},'bo-')
    xlabel('Block'); ylabel('# CR');
    title(['Correct Rejects for Animal ',sheets{k}])
    ylim([0 calc_threshold]);xlim([0 max_num_blocks + 1]);
    
end
