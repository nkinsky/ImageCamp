% Run Stats after freezing levels have been established

clear all
close all

%% Parameters

siglevel = 0.1; % Level of significance to note
CI = 95; % Confidence interval (percentage) to plot on the bar graphs
CI_factor = abs(norminv((1-CI/100)/2,0,1));

%% GET FILES FOR FC GROUP AND CONTROL GROUP
[FCfile, FCpath] = uigetfile('*.mat','Choose Analyzed Data file for FC group');
FC_fullpath = [ FCpath FCfile];
FCgroup = importdata(FC_fullpath);
display([FCfile ' loaded.'])

[controlfile, controlpath] = uigetfile('*.mat','Choose Analyzed Data file for Control group',FC_fullpath);
control_fullpath = [ controlpath controlfile];
controlgroup = importdata(control_fullpath);
display([controlfile ' loaded.'])

% Plot order information
% plot_order_FC = {'habituation' 'baseline' 'coyote' '1hour' '4hours' '24hours' '48hours' '72hours' '192hours'};
plot_order_FC = {'habituation' 'baseline' 'shock' '6hours' '24hours' '7days'};
plot_bars_FC = {'FCcontext' ; 'neutral'};

% plot_order_control = {'habituation' 'baseline' 'water' '1hour' '4hours' '24hours' '48hours' '72hours' '192hours'};
plot_order_control = {'habituation' 'baseline' 'shock' '6hours' '24hours' '7days'};
plot_bars_control = {'FCcontext' ; 'neutral'};


%% GROUP STATS

% Consolidate data from different days for each group

%%% FC GROUP
% Consolidate 3 and 5 hour data into 4 hour group.
FC_4hours_fratio = []; neutral_4hours_fratio = [];
FC_4hours_speed = []; neutral_4hours_speed = [];
for j = 1:size(FCgroup,2)
    for k = 1:size(FCgroup(j).group_session,2)
        if (strcmp(FCgroup(j).group_session(k).name,'5hours') || strcmp(FCgroup(j).group_session(k).name,'3hours')) && ...
               strcmp(FCgroup(j).group_session(k).context_name,'FCcontext')
           
           FC_4hours_fratio = [FC_4hours_fratio FCgroup(j).group_session(k).freeze_ratio_all];
           FC_4hours_speed = [FC_4hours_speed FCgroup(j).group_session(k).speed_all];
           
        elseif (strcmp(FCgroup(j).group_session(k).name,'5hours') || strcmp(FCgroup(j).group_session(k).name,'3hours')) && ...
               strcmp(FCgroup(j).group_session(k).context_name,'neutral')
           
           neutral_4hours_fratio = [neutral_4hours_fratio FCgroup(j).group_session(k).freeze_ratio_all];
           neutral_4hours_speed = [neutral_4hours_speed FCgroup(j).group_session(k).speed_all];
           
        end
    end

end

%%% CONTROL GROUP
% Consolidate 360  and 144 hour data into 192 hour data
ctrl_FC_192hours_fratio = []; ctrl_neutral_192hours_fratio = [];
ctrl_FC_192hours_speed = []; ctrl_neutral_192hours_speed = [];
for j = 1:size(controlgroup,2)
    for k = 1:size(controlgroup(j).group_session,2)
        if (strcmp(controlgroup(j).group_session(k).name,'360hours') || strcmp(controlgroup(j).group_session(k).name,'192hours')...
                || strcmp(controlgroup(j).group_session(k).name,'144hours')) && strcmp(controlgroup(j).group_session(k).context_name,'FCcontext')
            
            ctrl_FC_192hours_fratio = [ctrl_FC_192hours_fratio controlgroup(j).group_session(k).freeze_ratio_all];
            ctrl_FC_192hours_speed = [ctrl_FC_192hours_speed controlgroup(j).group_session(k).speed_all];
            
        elseif (strcmp(controlgroup(j).group_session(k).name,'360hours') || strcmp(controlgroup(j).group_session(k).name,'192hours')...
                || strcmp(controlgroup(j).group_session(k).name,'144hours')) && strcmp(controlgroup(j).group_session(k).context_name,'neutral')
            
            ctrl_neutral_192hours_fratio = [ctrl_neutral_192hours_fratio controlgroup(j).group_session(k).freeze_ratio_all];
            ctrl_neutral_192hours_speed = [ctrl_neutral_192hours_speed controlgroup(j).group_session(k).speed_all];
            
        end
    end
end
     


%% Fill in data to match plot order information above
%%% FC Group
for i = 1:size(plot_bars_FC,1)
    for j = 1:size(plot_order_FC,2)
       index_match =  find(arrayfun(@(a) strcmp(a.name,plot_order_FC{j}),FCgroup.group_session) ...
           & arrayfun(@(a) strcmp(a.context_name,plot_bars_FC{i}),FCgroup.group_session)); % Get group session matching each context and session type
       if ~isempty(index_match) % Skip this step if nothing match the session and context
           fratio_mean(i,j) = FCgroup.group_session(index_match).freeze_ratio_mean;
           fratio_std(i,j) = FCgroup.group_session(index_match).freeze_ratio_std;
           fratio_all{i,j} = FCgroup.group_session(index_match).freeze_ratio_all;
           fratio_sem(i,j) = fratio_std(i,j)/sqrt(size(fratio_all{i,j},2));
           speed_mean(i,j) = FCgroup.group_session(index_match).speed_mean;
           speed_std(i,j) = FCgroup.group_session(index_match).speed_std;
           speed_all{i,j} = FCgroup.group_session(index_match).speed_all;
       elseif strcmp(plot_order_FC{j},'4hours')
           
           if strcmp(plot_bars_FC{i},'FCcontext')
               fratio_mean(i,j) = mean(FC_4hours_fratio);
               fratio_std(i,j) = std(FC_4hours_fratio);
               fratio_all{i,j} = FC_4hours_fratio;
               fratio_sem(i,j) = fratio_std(i,j)/sqrt(size(fratio_all{i,j},2));
               speed_mean(i,j) = mean(FC_4hours_speed);
               speed_std(i,j) = std(FC_4hours_speed);
               speed_all{i,j} = FC_4hours_speed;
           elseif strcmp(plot_bars_FC{i},'neutral')
               fratio_mean(i,j) = mean(neutral_4hours_fratio);
               fratio_std(i,j) = std(neutral_4hours_fratio);
               fratio_all{i,j} = neutral_4hours_fratio;
               fratio_sem(i,j) = fratio_std(i,j)/sqrt(size(fratio_all{i,j},2));
               speed_mean(i,j) = mean(neutral_4hours_speed);
               speed_std(i,j) = std(neutral_4hours_speed);
               speed_all{i,j} = neutral_4hours_speed;
           end
       end
    end
end

%%% Control group
for i = 1:size(plot_bars_control,1)
    for j = 1:size(plot_order_control,2)
       index_match =  find(arrayfun(@(a) strcmp(a.name,plot_order_control{j}),controlgroup.group_session) ...
           & arrayfun(@(a) strcmp(a.context_name,plot_bars_control{i}),controlgroup.group_session)); % Get group session matching each context and session type
       if ~isempty(index_match) % Skip this step if nothing matches the session and context
           ctrl_fratio_mean(i,j) = controlgroup.group_session(index_match).freeze_ratio_mean;
           ctrl_fratio_std(i,j) = controlgroup.group_session(index_match).freeze_ratio_std;
           ctrl_fratio_all{i,j} = controlgroup.group_session(index_match).freeze_ratio_all;
           ctrl_fratio_sem(i,j) = ctrl_fratio_std(i,j)/sqrt(size(ctrl_fratio_all{i,j},2));
           ctrl_speed_mean(i,j) = controlgroup.group_session(index_match).speed_mean;
           ctrl_speed_std(i,j) = controlgroup.group_session(index_match).speed_std;
           ctrl_speed_all{i,j} = controlgroup.group_session(index_match).speed_all;
           % Overwrite 192hours data
           if strcmp(plot_order_control{j},'192hours')
               if strcmp(plot_bars_control{i},'FCcontext')
               ctrl_fratio_mean(i,j) = mean(ctrl_FC_192hours_fratio);
               ctrl_fratio_std(i,j) = std(ctrl_FC_192hours_fratio);
               ctrl_fratio_all{i,j} = ctrl_FC_192hours_fratio;
               ctrl_fratio_sem(i,j) = ctrl_fratio_std(i,j)/sqrt(size(ctrl_fratio_all{i,j},2));
               ctrl_speed_mean(i,j) = mean(ctrl_FC_192hours_speed);
               ctrl_speed_std(i,j) = std(ctrl_FC_192hours_speed);
               ctrl_speed_all{i,j} = ctrl_FC_192hours_speed;
               elseif strcmp(plot_bars_control{i},'neutral')
               ctrl_fratio_mean(i,j) = mean(ctrl_neutral_192hours_fratio);
               ctrl_fratio_std(i,j) = std(ctrl_neutral_192hours_fratio);
               ctrl_fratio_all{i,j} = ctrl_neutral_192hours_fratio;
               ctrl_fratio_sem(i,j) = ctrl_fratio_std(i,j)/sqrt(size(ctrl_fratio_all{i,j},2));
               ctrl_speed_mean(i,j) = mean(ctrl_neutral_192hours_speed);
               ctrl_speed_std(i,j) = std(ctrl_neutral_192hours_speed);
               ctrl_speed_all{i,j} = ctrl_neutral_192hours_speed; 
               end
           end
       end
    end
end

%% Get baseline freezing rates for all groups 
% (combine data from ALL days to get a sense of what average activity
% levels should look like for all but the FC group in the FC context)
% 1st row is FC group neutral context, 2nd is control group FC context, 34d
% group is control group neutral context, 4th row is all combined

combratio{1} = []; combratio{2} = []; combratio{3} = [];
for j = 1:size(plot_order_FC,2)
    combratio{1} = [combratio{1} fratio_all{2,j}];
    combratio{2} = [combratio{2} ctrl_fratio_all{1,j}]; 
    combratio{3} = [combratio{3} ctrl_fratio_all{2,j}]; 

end 
combratio{4} = [combratio{1} combratio{2} combratio{3}];

for j = 1:4
    fratio_mean_all_comb(j,1) = mean(combratio{j});
    fratio_sem_all_comb(j,1) = std(combratio{j})/sqrt(size(combratio{j},2));
end

%% Plot Group freezing across days (Figures 1-4)

%%% FC Group (Figure 1)
figure(1)
gca1 = gca;
hbar1 = bar(fratio_mean','grouped'); hold on;
legend({'FC context','neutral context'})
for k = 1:size(plot_bars_FC,1)
    temp = get(get(hbar1(k),'children'),'xdata');
    xpos1(k,:) = mean(temp([1 3],:),1);
    errorbar(xpos1(k,:),fratio_mean(k,:),CI_factor*fratio_sem(k,:),'.');
end
set(gca,'XTickLabel',plot_order_FC')
hold off
legend
title('FC Group freezing levels'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(FCgroup.animal(1).session(1).threshold) ' cm/s']);
ylim1 = get(gca,'YLim');

%%% Control group
figure(2)
gca2 = gca;
hbar2 = bar(ctrl_fratio_mean','grouped'); hold on;
legend({'FC context','neutral context'})
for k = 1:size(plot_bars_control,1)
    temp = get(get(hbar2(k),'children'),'xdata');
    xpos2(k,:) = mean(temp([1 3],:),1);
    errorbar(xpos2(k,:),ctrl_fratio_mean(k,:),CI_factor*ctrl_fratio_sem(k,:),'.');
end
set(gca,'XTickLabel',plot_order_FC')
hold off
legend
title('Control Group freezing levels'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(controlgroup.animal(1).session(1).threshold) ' cm/s']);
ylim2 = get(gca,'YLim');

% Set axes the same
if max(ylim1 > ylim2)
    set(gca2,'YLim',ylim1)
else
    set(gca1,'YLim',ylim2)
end

%%% FC group with control group in neutral context

figure(3)
gca3 = gca;
comb_fratio_mean = [fratio_mean ; ctrl_fratio_mean(2,:)];
comb_fratio_sem = [fratio_sem ; ctrl_fratio_sem(2,:)];
hbar3 = bar(comb_fratio_mean','grouped'); hold on; 
for k = 1:size(hbar3,2)
    temp = get(get(hbar3(k),'children'),'xdata');
    xpos3(k,:) = mean(temp([1 3],:),1);
    errorbar(xpos3(k,:),comb_fratio_mean(k,:),CI_factor*comb_fratio_sem(k,:),'.');
end
set(gca,'XTickLabel',plot_order_FC')
hold off
legend({'FC Group FC context','FC Group neutral context','Control group neutral context'})
title('Freezing levels'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(FCgroup.animal(1).session(1).threshold) ' cm/s']);

%%% FC group with control group in FC context
figure(4)
gca4 = gca;
comb4_fratio_mean = [fratio_mean(1,:) ; ctrl_fratio_mean(1,:)];
comb4_fratio_sem = [fratio_sem(1,:) ; ctrl_fratio_sem(1,:)];
hbar4 = bar(comb4_fratio_mean','grouped'); hold on; 
for k = 1:size(hbar4,2)
    temp = get(get(hbar4(k),'children'),'xdata');
    xpos4(k,:) = mean(temp([1 3],:),1);
    errorbar(xpos4(k,:),comb4_fratio_mean(k,:),CI_factor*comb4_fratio_sem(k,:),'.');
end
set(gca,'XTickLabel',plot_order_FC')
hold off
legend({'FC Group FC context','Control group FC context'})
title('Freezing levels'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(FCgroup.animal(1).session(1).threshold) ' cm/s']);


%% Run statistics on above

%%%% 1) Between contexts in FC group
for j = 1:size(plot_order_FC,2)
    if isempty(fratio_all{1,j}) || isempty(fratio_all{2,j}) 
    else
       [hFC_bw_ctxt{j} pFC_bw_ctxt{j}] = ttest2(fratio_all{1,j},fratio_all{2,j},'tail','right'); 
    end
end
sigflags_FC_bw_ctxt = cellfun(@(a) ~isempty(a) && a <= siglevel,pFC_bw_ctxt);

%%% 1) Compared to baseline - FC group
base_index_FC = find(strcmp(plot_order_FC,'baseline'));
for j = base_index_FC+1:size(plot_order_FC,2)
    % First row is FC context compared to baseline
    if isempty(fratio_all{1,j})
    else
        [hFC_baseline{1,j} pFC_baseline{1,j}] = ttest2(fratio_all{1,base_index_FC},fratio_all{1,j},'tail','left'); 
    end
    % Second row is neutral context compared to baseline
    if isempty(fratio_all{2,j})
    else
        [hFC_baseline{2,j} pFC_baseline{2,j}] = ttest2(fratio_all{2,base_index_FC},fratio_all{2,j},'tail','left');
    end 
end
sigflags_FC_baseline = cellfun(@(a) ~isempty(a) && a <= siglevel,pFC_baseline);

%%%% 2) Between contexts in control group
for j = 1:size(plot_order_control,2)
    if isempty(ctrl_fratio_all{1,j}) || isempty(ctrl_fratio_all{2,j}) 
    else
       [hctrl_bw_ctxt{j} pctrl_bw_ctxt{j}] = ttest2(ctrl_fratio_all{1,j},ctrl_fratio_all{2,j},'tail','right'); 
    end
end
sigflags_ctrl_bw_ctxt = cellfun(@(a) ~isempty(a) && a <= 0.05,pctrl_bw_ctxt);

%%% 2) Compared to baseline - control group
base_index_ctrl = find(strcmp(plot_order_control,'baseline'));
for j = base_index_ctrl+1:size(plot_order_control,2)
    % First row is FC context compared to baseline
    if isempty(ctrl_fratio_all{1,j})
    else
        [hctrl_baseline{1,j} pctrl_baseline{1,j}] = ttest2(ctrl_fratio_all{1,base_index_ctrl},ctrl_fratio_all{1,j},'tail','left'); 
    end
    % Second row is neutral context compared to baseline
    if isempty(ctrl_fratio_all{2,j})
    else
        [hctrl_baseline{2,j} pctrl_baseline{2,j}] = ttest2(ctrl_fratio_all{2,base_index_ctrl},ctrl_fratio_all{2,j},'tail','left');
    end 
end
sigflags_ctrl_baseline = cellfun(@(a) ~isempty(a) && a <= siglevel,pctrl_baseline);

%%%% 4) Between FC group and control group in FC context
for j = 1:size(plot_order_control,2)
    if isempty(ctrl_fratio_all{1,j}) || isempty(fratio_all{1,j})
    else
        [h_bwgroups_FCctxt{j} p_bwgroups_FCctxt{j}] = ttest2(ctrl_fratio_all{1,j},fratio_all{1,j},'tail','left');
    end
end
sigflags_bwgroups_FCctxt = cellfun(@(a) ~isempty(a) && a <= siglevel,p_bwgroups_FCctxt);

%%%% 10) Between FC group and combined groups
for j = 1:size(plot_order_FC,2)
    if isempty(fratio_all{1,j})
    else
        [hFC_all_comb{1,j} pFC_all_comb{1,j}] = ttest2(combratio{4},fratio_all{1,j},'tail','left');
    end
    if isempty(fratio_all{2,j})
    else
        [hFC_all_comb{2,j} pFC_all_comb{2,j}] = ttest2([combratio{2} combratio{3}], fratio_all{2,j},'tail','left');
%         [hFC_all_comb{2,j} pFC_all_comb{2,j}] = ttest2(combratio{4},fratio_all{2,j},'tail','left');
    end
    
end
hFC_all_comb_array = cellfun(@(a) ~isempty(a) && a, hFC_all_comb);
sigflags_FC_all_comb = cellfun(@(a) ~isempty(a) && a <= siglevel, pFC_all_comb);

%%%% 10) Between (FC group neutral context, control group FC context,
%%%% control group neutral context) AND combined group freezing

for j = 1:size(plot_order_FC,2)
    if isempty(ctrl_fratio_all{1,j})
    else
        [hctrl_all_comb{1,j} pctrl_all_comb{1,j}] = ttest2([combratio{1} combratio{3}], ctrl_fratio_all{1,j},'tail','left');
%         [hctrl_all_comb{1,j} pctrl_all_comb{1,j}] = ttest2(combratio{4},ctrl_fratio_all{1,j},'tail','left');
    end
    if isempty(ctrl_fratio_all{2,j})
    else
        [hctrl_all_comb{2,j} pctrl_all_comb{2,j}] = ttest2([combratio{1} combratio{2}],ctrl_fratio_all{2,j},'tail','left');
%         [hctrl_all_comb{2,j} pctrl_all_comb{2,j}] = ttest2(combratio{4},ctrl_fratio_all{2,j},'tail','left');
    end
    
end
hctrl_all_comb_array = cellfun(@(a) ~isempty(a) && a ,hctrl_all_comb);
sigflags_ctrl_all_comb = cellfun(@(a) ~isempty(a) && a <= siglevel,pctrl_all_comb);

%% Add in significance notation to each of the above plots

%%% Between contexts in FC group
for k = 1:size(hbar1,2)
    tempx = get(get(hbar1(k),'children'),'xdata');
    tempy = get(get(hbar1(k),'children'),'ydata');
    xpos1s(k,:) = mean(tempx([1 3],:),1);
    ypos1s(k,:) = tempy(2,:);
end
figure(1)
hold on
plot(xpos1s(2,sigflags_FC_bw_ctxt),ypos1s(2,sigflags_FC_bw_ctxt)+0.01,'*');
hold off

%%%% Compared to baseline in FC group
figure(1)
hold on
for k = 1:2
    plot(xpos1s(k,sigflags_FC_baseline(k,:)),ypos1s(k,sigflags_FC_baseline(k,:))+0.01,'d');
end
hold off

%%% Between contexts in control group
for k = 1:size(hbar2,2)
    tempx = get(get(hbar2(k),'children'),'xdata');
    tempy = get(get(hbar2(k),'children'),'ydata');
    xpos2s(k,:) = mean(tempx([1 3],:),1);
    ypos2s(k,:) = tempy(2,:);
end
figure(2)
hold on
plot(xpos2s(2,sigflags_ctrl_bw_ctxt),ypos2s(2,sigflags_ctrl_bw_ctxt)+0.05,'*');
hold off

%%% FC context between group comparison
for k = 1:size(hbar4,2)
    tempx = get(get(hbar4(k),'children'),'xdata');
    tempy = get(get(hbar4(k),'children'),'ydata');
    xpos4s(k,:) = mean(tempx([1 3],:),1);
    ypos4s(k,:) = tempy(2,:);
end
figure(4)
hold on
plot(xpos4s(1,sigflags_bwgroups_FCctxt),ypos4s(1,sigflags_bwgroups_FCctxt)+0.01,'*')
hold off


%% 
% Restrict above to certain animals only?  Would have to create separate
% database group... - might want to put into animal folder names to do
% this...

% Separate out early animals who weren't in triangle for neutral context

%% Plot the above but for each animal...

%%% FC group
figure(5)
for j = 1:size(FCgroup.animal,2)
    tempa = []; tempb = [];
    subplot(size(FCgroup.animal,2),1,j)
    % Get stats, session, and context
    freeze_indiv = arrayfun(@(a) a.freeze_ratio_k, FCgroup.animal(j).session);
    session_indiv = arrayfun(@(a) a.session_name, FCgroup.animal(j).session,'UniformOutput',0);
    context_indiv = arrayfun(@(a) a.context, FCgroup.animal(j).session,'UniformOutput',0);
    % Order it correctly
    for k = 1:size(plot_order_FC,2)
        if ~isempty(find(strcmp(session_indiv,plot_order_FC{k}) & strcmp(context_indiv,'FCcontext')))
            tempa(k) = find(strcmp(session_indiv,plot_order_FC{k}) & strcmp(context_indiv,'FCcontext'));
            tempa_x(k) = k;
            
        end
        
        if strcmp(plot_order_FC{k},'4hours') &&...
                ~isempty(find(strcmp(session_indiv,'3hours') & strcmp(context_indiv,'FCcontext')))
            
            tempa(k) = find(strcmp(session_indiv,'3hours') & strcmp(context_indiv,'FCcontext'));
            tempa_x(k) = k;
            
        elseif strcmp(plot_order_FC{k},'4hours') &&...
                ~isempty(find(strcmp(session_indiv,'5hours') & strcmp(context_indiv,'FCcontext')))
               
            tempa(k) = find(strcmp(session_indiv,'5hours') & strcmp(context_indiv,'FCcontext'));
            tempa_x(k) = k;
            
        end
        plot_order_FC_indiv = tempa(tempa ~= 0);
        plot_x_FC_indiv = tempa_x(tempa ~= 0);
        
        if ~isempty(find(strcmp(session_indiv,plot_order_FC{k}) & strcmp(context_indiv,'neutral')))
            tempb(k) = find(strcmp(session_indiv,plot_order_FC{k}) & strcmp(context_indiv,'neutral'));
            tempb_x(k) = k;
        end
        plot_order_neutral_indiv = tempb(tempb ~= 0);
        plot_x_neutral_indiv = tempb_x(tempb ~= 0);
        
    end
    
    plot(plot_x_FC_indiv,freeze_indiv(plot_order_FC_indiv),'b-o',plot_x_neutral_indiv,...
        freeze_indiv(plot_order_neutral_indiv),'r-.+');
    xlim([0.5 size(plot_order_FC,2)+0.5]); % ylim([0 1]);
    ylabel({['Animal ' FCgroup.animal(j).name]; 'Freeze Ratio'}); % xlabel('Session');
    set(gca,'XTickLabel',plot_order_FC')
    ylim_ind3 = get(gca,'YLim'); max_ylim3(j) = max(ylim_ind3);
    
    
end
legend({'FCcontext' 'neutral'})
xlabel({'Session'; ['thresh = ' num2str(controlgroup.animal(1).session(1).threshold) ' cm/s']})
subplot(size(FCgroup.animal,2),1,1); title('FC group');

%%% Control Group

figure(6)
for j = 1:size(controlgroup.animal,2)
    tempa = []; tempb = [];
    subplot(size(controlgroup.animal,2),1,j)
    % Get stats, session, and context
    freeze_indiv = arrayfun(@(a) a.freeze_ratio_k, controlgroup.animal(j).session);
    session_indiv = arrayfun(@(a) a.session_name, controlgroup.animal(j).session,'UniformOutput',0);
    context_indiv = arrayfun(@(a) a.context, controlgroup.animal(j).session,'UniformOutput',0);
    % Order it correctly
    for k = 1:size(plot_order_control,2)
        if ~isempty(find(strcmp(session_indiv,plot_order_control{k}) & strcmp(context_indiv,'FCcontext')))
            
            tempa(k) = find(strcmp(session_indiv,plot_order_control{k}) & strcmp(context_indiv,'FCcontext'));
            tempa_x(k) = k;
            
        end
        
        if strcmp(plot_order_control{k},'192hours') &&...
                ~isempty(find(strcmp(session_indiv,'144hours') & strcmp(context_indiv,'FCcontext')))
            
            tempa(k) = find(strcmp(session_indiv,'144hours') & strcmp(context_indiv,'FCcontext'));
            tempa_x(k) = k;
            
        elseif strcmp(plot_order_control{k},'192hours') &&...
                ~isempty(find(strcmp(session_indiv,'360hours') & strcmp(context_indiv,'FCcontext')))
               
            tempa(k) = find(strcmp(session_indiv,'360hours') & strcmp(context_indiv,'FCcontext'));
            tempa_x(k) = k;
            
        end
        plot_order_control_indiv = tempa(tempa ~= 0);
        plot_x_control_indiv = tempa_x(tempa ~= 0);
        
        if ~isempty(find(strcmp(session_indiv,plot_order_control{k}) & strcmp(context_indiv,'neutral')))
            
            tempb(k) = find(strcmp(session_indiv,plot_order_control{k}) & strcmp(context_indiv,'neutral'));
            tempb_x(k) = k;
            
        end
        
        if strcmp(plot_order_control{k},'192hours') &&...
                ~isempty(find(strcmp(session_indiv,'144hours') & strcmp(context_indiv,'neutral')))
            
            tempb(k) = find(strcmp(session_indiv,'144hours') & strcmp(context_indiv,'neutral'));
            tempb_x(k) = k;
            
        elseif strcmp(plot_order_control{k},'192hours') &&...
                ~isempty(find(strcmp(session_indiv,'360hours') & strcmp(context_indiv,'neutral')))
               
            tempb(k) = find(strcmp(session_indiv,'360hours') & strcmp(context_indiv,'neutral'));
            tempb_x(k) = k;
            
        end
        plot_order_neutral_indiv = tempb(tempb ~= 0);
        plot_x_neutral_indiv = tempb_x(tempb ~= 0);
        
    end
    
    plot(plot_x_control_indiv,freeze_indiv(plot_order_control_indiv),'b-o',plot_x_neutral_indiv,...
        freeze_indiv(plot_order_neutral_indiv),'r-.+');
    xlim([0.5 size(plot_order_control,2)+0.5]); % ylim([0 1]);
    ylabel({['Animal ' controlgroup.animal(j).name]; 'Freeze Ratio'}); % xlabel('Session');
    set(gca,'XTickLabel',plot_order_control')
    ylim_ind4 = get(gca,'YLim'); max_ylim4(j) = max(ylim_ind4);
    
    
end

legend({'FCcontext' 'neutral'})
xlabel({'Session'; ['thresh = ' num2str(controlgroup.animal(1).session(1).threshold) ' cm/s']});
subplot(size(controlgroup.animal,2),1,1); title('Control group');

% Set axes the same
max_ylim_ind = max([max_ylim3 max_ylim4]);
figure(5)
for j = 1:size(FCgroup.animal,2)
   subplot(size(FCgroup.animal,2),1,j);
   set(gca,'YLim',[0 max_ylim_ind]);
end

figure(6)
for j = 1:size(controlgroup.animal,2)
   subplot(size(controlgroup.animal,2),1,j);
   set(gca,'YLim',[0 max_ylim_ind]);
end


%% Plot freezing versus time of day for all sessions

tod_FC = []; freeze_FC = [];
for j = 1:size(FCgroup.animal,2)
    tod_FC = [tod_FC arrayfun(@(a) str2num(a.time),FCgroup.animal(j).session)];
    freeze_FC = [freeze_FC arrayfun(@(a) a.freeze_ratio_k,FCgroup.animal(j).session)];
end

tod_control = []; freeze_control = [];
for j = 1:size(controlgroup.animal,2)
    tod_control = [tod_control arrayfun(@(a) str2num(a.time),controlgroup.animal(j).session)];
    freeze_control = [freeze_control arrayfun(@(a) a.freeze_ratio_k,controlgroup.animal(j).session)];
end

figure(7)
plot(tod_FC,freeze_FC,'b.',tod_control,freeze_control,'r*');
xlabel('Time of Day'); ylabel('Freezing Ratio');
title({'Freezing vs. TOD' ; ['thresh = ' num2str(controlgroup.animal(1).session(1).threshold) ' cm/s']});
xlim_tod = get(gca,'XLim');
hold on
plot(xlim_tod, [mean(freeze_FC) mean(freeze_FC)], 'b--', xlim_tod, [mean(freeze_control) mean(freeze_control)], 'r-.');
legend('FC group','Control group');

%% Close all the figures I don't want popping up
h5 = figure(5); h6 = figure(6); h7 = figure(7);
% close(h5,h6,h7);

%% Money plot
%%% plot only baseline, 24 hours, maybe 48 hours, and 192 hours
%%% also try plot combining 24 and 48 hours and 72 hours, but including
% control group in the FC context?

fig8_plot_order = {'baseline' '24hours' '48hours' '192hours'};
for j = 1:size(fig8_plot_order,2)
    fig8_plot_index(j) = find(strcmp(fig8_plot_order{j},plot_order_FC));
end

figure(8)
gca8 = gca;
hbar8 = bar(fratio_mean(:,fig8_plot_index)','grouped'); hold on;
hleg8 = legend({'FC context','neutral context'});
leg8pos = get(hleg8,'Position');
text(leg8pos(1)*1.15, 1.03*leg8pos(2), ['* = p < ' num2str(siglevel)],'Units','normalized')
for k = 1:size(plot_bars_FC,1)
    temp = get(get(hbar8(k),'children'),'xdata');
    xpos8(k,:) = mean(temp([1 3],:),1);
    errorbar(xpos8(k,:),fratio_mean(k,fig8_plot_index),CI_factor*fratio_sem(k,fig8_plot_index),'.');
end
set(gca,'XTickLabel',fig8_plot_order')
hold off
legend
title('FC Group freezing levels'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(FCgroup.animal(1).session(1).threshold) ' cm/s']);
ylim8 = get(gca,'YLim');

%%% Between contexts in FC group
for k = 1:size(hbar8,2)
    tempx = get(get(hbar8(k),'children'),'xdata');
    tempy = get(get(hbar8(k),'children'),'ydata');
    xpos8s(k,:) = mean(tempx([1 3],:),1);
    ypos8s(k,:) = tempy(2,:);
end

ypos8max = ypos8s + CI_factor*fratio_sem(:,fig8_plot_index);
ypos8max2 = max(ypos8max,[],2);
figure(8)
ylim([0 1.2*max(ylim8)])
index_FC_bw_ctxt = find(sigflags_FC_bw_ctxt);
hold on
ymaxplot = [];
for j = 1:size(index_FC_bw_ctxt,2)
    index = index_FC_bw_ctxt(j) == fig8_plot_index;
    if sum(index) > 0
        plot([xpos8(1,index) xpos8(1,index) xpos8(2,index) xpos8(2,index)],...
            [1.05*ypos8max(1,index) 1.1*max(ypos8max2(:,1)) 1.1*max(ypos8max2(:,1)) 1.05*ypos8max(2,index)],...
            'k-',mean(xpos8(:,index)),1.12*max(ypos8max2(:,1)),'k*');
        ymaxplot = max([ymaxplot 1.12*max(ypos8max(:,index))]);
    else
    end
end
hold off

%%%% Compared to baseline in FC group
figure(8)
% hold on
% for k = 1:2
%     plot(xpos8s(k,sigflags_FC_baseline(k,fig8_plot_index)),ypos8s(k,sigflags_FC_baseline(k,fig8_plot_index))+0.01,'d');
% end
% hold off

index_FC_baseline = find(sigflags_FC_baseline(1,:));
f8_bi = find(strcmp('baseline',fig8_plot_order));
ystart = ymaxplot;
hold on
for j = 1:size(index_FC_baseline,2)
    index = index_FC_baseline(j) == fig8_plot_index;
    if sum(index) > 0
        
        plot([xpos8(1,f8_bi) xpos8(1,f8_bi) xpos8(1,index) xpos8(1,index)],...
            [ystart 1.02*ymaxplot 1.02*ymaxplot ymaxplot],...
            'k-',mean([xpos8(1,f8_bi) xpos8(1,index)]),1.04*ymaxplot,'k*');
        ymaxplot = 1.05*ymaxplot;
    else
    end
end
hold off
ylim([0 1.05*ymaxplot])


%% Money plot part 2 from above

figure(9)
gca9 = gca;
fratio9_mean_comb = [fratio_mean ; ctrl_fratio_mean(1,:)];
fratio9_sem_comb = [fratio_sem ; ctrl_fratio_sem(1,:)];
hbar9 = bar(fratio9_mean_comb(:,fig8_plot_index)','grouped'); hold on;
hleg9 = legend({'FC group FC context','FC group neutral context','Control group FC context'});
leg9pos = get(hleg9,'Position');
text(leg9pos(1)*1.15, 1.03*leg9pos(2), ['* = p < ' num2str(siglevel)],'Units','normalized')
for k = 1:size(hbar9,2)
    temp = get(get(hbar9(k),'children'),'xdata');
    xpos9(k,:) = mean(temp([1 3],:),1);
    errorbar(xpos9(k,:),fratio9_mean_comb(k,fig8_plot_index),CI_factor*fratio9_sem_comb(k,fig8_plot_index),'.');
end
set(gca,'XTickLabel',fig8_plot_order')
hold off
legend
title('FC Group freezing levels'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(FCgroup.animal(1).session(1).threshold) ' cm/s']);
ylim8 = get(gca,'YLim');


% plot overall freezing levels for combined groups
figure(9)
xlim8 = get(gca,'XLim');
hold on
plot(xlim8, [fratio_mean_all_comb(4) fratio_mean_all_comb(4)],'b--')% ,xlim8 ,...
    % [fratio_mean_all_comb(2) fratio_mean_all_comb(2)],'r--')
hold off

%%% Between contexts in FC group
for k = 1:size(hbar9,2)
    tempx = get(get(hbar9(k),'children'),'xdata');
    tempy = get(get(hbar9(k),'children'),'ydata');
    xpos9s(k,:) = mean(tempx([1 3],:),1);
    ypos9s(k,:) = tempy(2,:);
end

ypos9max = ypos9s + CI_factor*fratio9_sem_comb(:,fig8_plot_index);
ypos9max2 = max(ypos9max,[],2);
figure(9)
ylim([0 1.2*max(ylim8)])
index_FC_bw_ctxt = find(sigflags_FC_bw_ctxt);
hold on
ymaxplot = [];
for j = 1:size(index_FC_bw_ctxt,2)
    index = index_FC_bw_ctxt(j) == fig8_plot_index;
    if sum(index) > 0
        plot([xpos9s(1,index) xpos9s(1,index) xpos9s(2,index) xpos9s(2,index)],...
            [1.05*ypos9max(1,index) 1.1*max(ypos9max2(1:2,1)) 1.1*max(ypos9max2(1:2,1)) 1.05*ypos9max(2,index)],...
            'k-',mean(xpos9(1:2,index)),1.12*max(ypos9max2(1:2,1)),'k*');
        text(1.02*mean(xpos9s(1:2,index)),1.12*max(ypos9max2(1:2,1)),['(' num2str(pFC_bw_ctxt{index_FC_bw_ctxt(j)},'%0.3f') ')'])
        ymaxplot = max([ymaxplot 1.1*max(ypos9max(:,index))]);
    else
    end
end
hold off

%%%% Compared to baseline in FC group
figure(9)

index_FC_baseline = find(sigflags_FC_baseline(1,:));
f8_bi = find(strcmp('baseline',fig8_plot_order));
ystart = ymaxplot;
hold on
for j = 1:size(index_FC_baseline,2)
    index = index_FC_baseline(j) == fig8_plot_index;
    if sum(index) > 0
        
        plot([xpos9(1,f8_bi) xpos9(1,f8_bi) xpos9(1,index) xpos9(1,index)],...
            [ystart 1.04*ymaxplot 1.04*ymaxplot ymaxplot],...
            'k-',mean([xpos9(1,f8_bi) xpos9(1,index)]),1.06*ymaxplot,'k*');
        text(1.04*mean([xpos9(1,f8_bi) xpos9(1,index)]),1.06*ymaxplot,...
            ['(' num2str(pFC_baseline{1,index_FC_baseline(j)},'%0.3f') ')']);
        ymaxplot = 1.05*ymaxplot;
  
    else
    end
end
hold off
ylim([0 1.05*ymaxplot])

%% Overall freezing levels for days combined...

fig10_plot_index = 1:size(plot_order_FC,2);
fig10_plot_order = plot_order_FC;
figure(10)

% FC group FC context
h10_1 = subplot(2,1,1);
hbar10 = bar(fratio_mean(1,:)); hold on;
for k = 1:size(hbar10,2)
    tempx = get(get(hbar10(k),'children'),'xdata');
    tempy = get(get(hbar10(k),'children'),'ydata');
    xpos10(k,:) = mean(tempx([1 3],:),1);
    errorbar(xpos10(k,:),fratio_mean(k,fig10_plot_index),CI_factor*fratio_sem(k,fig10_plot_index),'.');
end
ypos10max = fratio_mean(1,fig10_plot_index) + CI_factor*fratio_sem(1,fig10_plot_index);
set(gca,'XTickLabel',fig10_plot_order')
hold off
legend
title('FC Group FC context freezing levels'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(FCgroup.animal(1).session(1).threshold) ' cm/s']);
ylim10 = get(gca,'YLim');

hold on
xlim10 = get(gca,'XLim');
index10plot = hFC_all_comb_array(1,:);
h10b = plot(xlim10, [mean(combratio{4}) mean(combratio{4})],'r--');
h10c = plot(xpos10(1,index10plot),1.05*ypos10max(1,index10plot),'*');
hold off
legend([h10b h10c],'non-FC group/FC context mean','p < 0.05','Location','NorthWest')


% FC group neutral context
h10_2 = subplot(2,1,2);

hbar10_2 = bar(fratio_mean(2,:)); hold on;

tempx = get(get(hbar10_2(k),'children'),'xdata');
tempy = get(get(hbar10_2(k),'children'),'ydata');
xpos10_2(1,:) = mean(tempx([1 3],:),1);
errorbar(xpos10_2(1,:),fratio_mean(2,fig10_plot_index),CI_factor*fratio_sem(2,fig10_plot_index),'.');
ypos10max = fratio_mean(2,fig10_plot_index) + CI_factor*fratio_sem(2,fig10_plot_index);

set(gca,'XTickLabel',fig10_plot_order')
hold off
legend
title('FC Group neutral context'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(FCgroup.animal(1).session(1).threshold) ' cm/s']);
ylim10_2 = get(gca,'YLim');

hold on
xlim10_2 = get(gca,'XLim');
index10plot = hFC_all_comb_array(2,:);
h10d = plot(xlim10_2, [mean(combratio{4}) mean(combratio{4})],'r--');
h10e = plot(xpos10_2(1,index10plot),1.05*ypos10max(1,index10plot),'*');
hold off
legend([h10d h10e],'non-FC group mean','p < 0.05','Location','NorthWest')

%%% Control group
fig11_plot_index = 1:size(plot_order_control,2);
fig11_plot_order = plot_order_control;

figure(11)

% ctrl group FC context
h11_1 = subplot(2,1,1);
hbar11 = bar(ctrl_fratio_mean(1,:)); hold on;
for k = 1:size(hbar11,2)
    tempx = get(get(hbar11(k),'children'),'xdata');
    tempy = get(get(hbar11(k),'children'),'ydata');
    xpos11(k,:) = mean(tempx([1 3],:),1);
    errorbar(xpos11(k,:),ctrl_fratio_mean(k,fig11_plot_index),CI_factor*ctrl_fratio_sem(k,fig11_plot_index),'.');
end
ypos11max = ctrl_fratio_mean(1,fig11_plot_index) + CI_factor*ctrl_fratio_sem(1,fig11_plot_index);
set(gca,'XTickLabel',fig11_plot_order')
hold off
legend
title('Control Group FC context freezing levels'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(FCgroup.animal(1).session(1).threshold) ' cm/s']);
ylim11 = get(gca,'YLim');

hold on
xlim11 = get(gca,'XLim');
index11plot = hctrl_all_comb_array(1,:);
h11b = plot(xlim11, [mean(combratio{4}) mean(combratio{4})],'r--');
h11c = plot(xpos11(1,index11plot),1.05*ypos11max(1,index11plot),'*');
hold off
legend([h11b h11c],'neutral context mean','p < 0.05','Location','NorthWest')



% ctrl group neutral context
h11_2 = subplot(2,1,2);

hbar11_2 = bar(ctrl_fratio_mean(2,:)); hold on;

tempx = get(get(hbar11_2(k),'children'),'xdata');
tempy = get(get(hbar11_2(k),'children'),'ydata');
xpos11_2(1,:) = mean(tempx([1 3],:),1);
errorbar(xpos11_2(1,:),ctrl_fratio_mean(2,fig11_plot_index),CI_factor*ctrl_fratio_sem(2,fig11_plot_index),'.');
ypos11max = ctrl_fratio_mean(2,fig11_plot_index) + CI_factor*ctrl_fratio_sem(2,fig11_plot_index);

set(gca,'XTickLabel',fig11_plot_order')
hold off
legend
title('Control Group neutral context'); xlabel('Session');
ylabel(['Freezing Ratio for threshold = ' num2str(FCgroup.animal(1).session(1).threshold) ' cm/s']);
ylim11_2 = get(gca,'YLim');

hold on
xlim11_2 = get(gca,'XLim');
index11plot = hctrl_all_comb_array(2,:);
h11d = plot(xlim11_2, [mean(combratio{4}) mean(combratio{4})],'r--');
h11e = plot(xpos11_2(1,index11plot),1.05*ypos11max(1,index11plot),'*');
legend([h11d h11e],'Control Group FC context/FC group neutral context mean','p < 0.05','Location','NorthWest')
hold off

%%% Set same ylim for all four plots
ylim1011_max = max([ylim10 ylim10_2 ylim11 ylim11_2]);
set(h10_1,'YLim',[0 ylim1011_max]);
set(h10_2,'YLim',[0 ylim1011_max]);
set(h11_1,'YLim',[0 ylim1011_max]);
set(h11_2,'YLim',[0 ylim1011_max]);



