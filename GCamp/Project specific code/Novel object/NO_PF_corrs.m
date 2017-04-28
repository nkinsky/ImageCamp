% NO_PF_corrs - calculate PF correlations across all sessions

clear all

% Load up sessions
[MD, ref] = MakeMouseSessionList('natlaptop');
Mouse{1}.sesh = MD(ref.Bellatrix(1):ref.Bellatrix(2));
Mouse{2}.sesh = MD(ref.Polaris(1):ref.Polaris(2));

num_animals = length(Mouse);

num_shuffles = 100;

%% Calculate correlations
comps{1} = [1 2; 2 3; 3 4; 2 4]; % Saline week session comparisons
comps{2} = [5 6; 6 7; 7 8; 6 8]; % CPP week session comparisons

num_shuffles = 100;

for j = 1:num_animals
    num_comps = size(comps{j},1);
    Mouse{j}.corrs = cell(num_comps,2);
    for k = 1:2
        for ll = 1:num_comps
            comp_sesh = Mouse{j}.sesh(comps{k}(ll,:)); % Grab sessions to compare
            
            % Get batch_session_map
            if ll == 1
                dirstr = ChangeDirectory_NK(comp_sesh(1),0);
                load(fullfile(dirstr,'batch_session_map.mat'));
            end
            [Mouse{j}.corrs{ll,k}, Mouse{j}.corrs_shuf{ll,k}] = corr_bw_sesh(comp_sesh(1), comp_sesh(2),...
                batch_session_map, num_shuffles);
        end

    end
end

%% Plot it out

figure(11)
week = {'1(Sal)', '1(CPP)'};
for j= 1:num_animals
    for k = 1:2
        corrs_plot = cellfun(@nanmean, Mouse{j}.corrs); % Get mean correlation between sessions
        subplot(2,2,(j-1)*2+k)
        % Calculate shuffled values
        shuf_plot = nan(num_comps,2);
        for ll = 1:num_comps
%             shuf_plot(ll) = mean(cellfun(@nanmean, Mouse{j}.corrs_shuf{ll,k}));
                temp = cellfun(@nanmean, Mouse{j}.corrs_shuf{ll,k});
                try
                    [f, x] = ecdf(temp);
                    shuf_plot(ll,1) = x(findclosest(f,0.025)); % Get 95% CI on shuffled data
                    shuf_plot(ll,2) = x(findclosest(f,0.975));
                catch
                    shuf_plot(ll,:) = nan(1,2);
                end
        end
        plot((1:num_comps)', corrs_plot(:,k),'b-o');
        hold on
        plot((1:num_comps)', shuf_plot, 'k--')
        hold off
        title(Mouse{j}.sesh(1).Animal(1:(regexpi(Mouse{j}.sesh(1).Animal,'_')-1)))
        xlim([0.5 4.5])
        set(gca,'XTick',[1 2 3 4],'XTickLabel',{['0 - ' week{k}] [week{k} ' - 2'] '2 - 3', [week{k} ' - 3']})
        xlabel('Days Compared')
        ylabel('Mean PF Correlation')
        ylim([-0.6 1])
        legend('Data','Shuffled')
    end
end

%% Do for within session comparisons
corr_mean = cell(1,2);
corr_shuf = cell(1,2);
for j = 1:num_animals
    sesh_use = Mouse{j}.sesh;
    
    for k = 1:length(sesh_use)
        dirstr = ChangeDirectory_NK(sesh_use(k),0);
        load(fullfile(dirstr,'Placefields_half.mat'));
        tmap1 = Placefields_halves{1}.TMap_gauss;
        tmap2 = Placefields_halves{2}.TMap_gauss;
        num_neurons = length(tmap1);
        map_use = 1:num_neurons; % Map neurons to themselves
        temp = corr_bw_TMap(tmap1, tmap2, map_use);
        corr_mean{j}(k) = nanmean(temp);
        
        if j == 2 && k == 6; disp('Keyboard active in NO_PF_corrs script'); keyboard; end % Check out certain sessions
        
        for ll = 1:num_shuffles
            map_shuf = randperm(length(tmap2)); % shuffle cell mapping
            temp = corr_bw_TMap(tmap1, tmap2, map_shuf);
            corr_shuf{j}(k,ll) = nanmean(temp);
        end
    end
end

%% Plot

figure(40)
for j = 1:num_animals
    subplot(2,2,j)
       plot(ones(1,8), corr_mean{j}, 'o', 2*ones(1,8), (mean(corr_shuf{j},2))' ,'o'); 
       set(gca,'XTick',[1 2], 'XTickLabel',{'Actual','Shuffled'})
       ylabel('Within day PF corrs');
       title(Mouse{j}.sesh(1).Animal(1:(regexpi(Mouse{j}.sesh(1).Animal,'_')-1)))
       xlim([0.5 2.5])

end

figure(12)
week = {'Saline Week - Day #', 'CPP Week - Day #'};
plot_sesh = [1 2 3 4; 5 6 7 8];
for j= 1:num_animals
    for k = 1:2
        corrs_plot = corr_mean{j}(plot_sesh(k,:)); % Get mean correlation between sessions
        subplot(2,2,(j-1)*2+k)
        % Calculate shuffled values
        num_comps = 4;
        shuf_plot = nan(num_comps,2);
        for ll = 1:num_comps
                temp = corr_shuf{j}(plot_sesh(k,ll),:);
                try
                    [f, x] = ecdf(temp);
                    shuf_plot(ll,1) = x(findclosest(f,0.025)); % Get 95% CI on shuffled data
                    shuf_plot(ll,2) = x(findclosest(f,0.975));
                catch
                    shuf_plot(ll,:) = nan(1,2);
                end
        end
        plot((1:num_comps)', corrs_plot,'b-o');
        hold on
        plot((1:num_comps)', shuf_plot, 'kx--')
        hold off
        title(Mouse{j}.sesh(1).Animal(1:(regexpi(Mouse{j}.sesh(1).Animal,'_')-1)))
        xlim([0.5 4.5])
        set(gca,'XTick',[1 2 3 4], 'XTickLabel', {'0' '1' '2' '3'})
        xlabel(week{k})
        ylabel('Mean PF Correlation')
        ylim([-0.6 1])
        legend('Data','Shuffled')
    end
end

%% Get #s of PFs
sig_level = 0.05;

for j = 1:2
    for k = 1:8
        dirstr = ChangeDirectory_NK(Mouse{j}.sesh(k),0);
        load(fullfile(dirstr,'Placefields.mat'),'pval')
        num_PFs(j,k) = sum(pval < sig_level);
    end
end
