% Two-env control comparison 

% Inclusion criteria - pass p-value thresh on WHOLE session

%% Session information
[MD, ref] = MakeMouseSessionList('Nat');

clear session
[~, session(1)] = ChangeDirectory('GCamp6f_45','08_05_2015',3,0); %session(1) = MD(114);
[~, session(2)] = ChangeDirectory('GCamp6f_45','08_05_2015',4,0); %session(2) = MD(115);
[~, session(3)] = ChangeDirectory('GCamp6f_45','08_11_2015',1,0); %session(3) = MD(119);

%% Run through stuff

% Plot histogram of correlations with mean value
figure(35)
for j = 1:length(session)
   
    % Load and deal out variables
    load(fullfile(session(j).Location,'PlaceMapsv2.mat'),'TMap_half','pval','pval_half','FT');
    session(j).TMap_half = TMap_half;
    session(j).pval = pval;
    session(j).pval_half = pval_half;
    session(j).numframes = size(FT,2);
    load(fullfile(session(j).Location,'PlaceMapsv2_oddeven.mat'),'TMap_half','pval','pval_half');
    session(j).TMap_half_oe = TMap_half;
    session(j).pval_oe = pval;
    session(j).pval_half_oe = pval_half;
    
    % Calculate correlations
    corrs_half = cellfun(@(a,b) corr(a(:),b(:),'type','Spearman'),...
        session(j).TMap_half(1).TMap_gauss, session(j).TMap_half(2).TMap_gauss);
    session(j).corrs_half = corrs_half;
    corrs_oe = cellfun(@(a,b) corr(a(:),b(:),'type','Spearman'),...
        session(j).TMap_half_oe(1).TMap_gauss, session(j).TMap_half_oe(2).TMap_gauss);
    session(j).corrs_oe = corrs_oe;
    
    % Unfiltered Plots
    subplot(3,3,3*(j-1)+1)
    mean_plot = nanmean(corrs_half);
    hist(corrs_half,-1:0.05:1)
    hold on
    plot([mean_plot mean_plot], get(gca,'YLim'),'r--')
    title(['1st v 2nd half (Unfiltered) for ' mouse_name_title(session(j).Animal) ,...
        ' - ' mouse_name_title(num2str(session(j).Date)),...
        ' Session ' num2str(session(j).Session)])
    xlabel('Spearman Correlation')
    ylabel('Count')
    hold off
    legend('Correlations','Mean')
    
    % Filtered Plots - 1st v 2nd half
    pass_thresh_logical = session(j).pval > 0.95;
    session(j).pass_thresh_logical = pass_thresh_logical;
    corrs_half = corrs_half(pass_thresh_logical);
    subplot(3,3,3*(j-1)+2)
    mean_plot = nanmean(corrs_half);
    hist(corrs_half,-1:0.05:1)
    hold on
    plot([mean_plot mean_plot], get(gca,'YLim'),'r--')
    title(['1st v 2nd half (Filtered) for ' mouse_name_title(session(j).Animal) ,...
        ' - ' mouse_name_title(num2str(session(j).Date)),...
        ' Session ' num2str(session(j).Session)])
    xlabel('Spearman Correlation')
    ylabel('Count')
    hold off
    legend('Correlations','Mean')
    
    % Filtered Plots - odd v even minutes
    pass_thresh_logical = session(j).pval_oe > 0.95;
    session(j).pass_thresh_logical_oe = pass_thresh_logical;
    corrs_oe = corrs_oe(pass_thresh_logical);
    subplot(3,3,3*(j-1)+3)
    mean_plot = nanmean(corrs_oe);
    hist(corrs_oe,-1:0.05:1)
    hold on
    plot([mean_plot mean_plot], get(gca,'YLim'),'r--')
    title(['Odd v Even Minutes (Filtered) for ' mouse_name_title(session(j).Animal) ,...
        ' - ' mouse_name_title(num2str(session(j).Date)),...
        ' Session ' num2str(session(j).Session)])
    xlabel('Spearman Correlation')
    ylabel('Count')
    hold off
    legend('Correlations','Mean')
    
    
end

%% Do the same for population vectors

disp('Calculating PV corrs')
for j = 1:length(session)
    [PVtemp, ~] = get_PV_and_corr(session(j),0,'calc_half',...
        {1:floor(session(j).numframes/2) floor(session(j).numframes/2)+1:session(j).numframes},...
        'alt_file_use','PlaceMapsv2.mat','PlaceMapsv2.mat');
    session(j).PVhalf = PVtemp;
    for k = 1:size(PVtemp,2)
        for ll = 1:size(PVtemp,3)
            PVcorr_temp(k,ll) = corr(squeeze(PVtemp(1,k,ll,session(j).pass_thresh_logical)),...
                squeeze(PVtemp(2,k,ll,session(j).pass_thresh_logical)));
        end
    end
    session(j).PVcorr = PVcorr_temp;

end

%% Save stuff
ChangeDirectory_NK(session(1));
save control_time_data session