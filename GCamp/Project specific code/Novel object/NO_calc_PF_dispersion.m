% NO_calc_PF_dispersion
% Calculates place field spread via spread of calcium transient firing

% Perform habituation v 1, 1 v 2, 2 v 3 comparison for each session, and
% then saline v cpp for each mouse

clear all

% Load up sessions
[MD, ref] = MakeMouseSessionList('natlaptop');
Mouse{1}.sesh = MD(ref.Bellatrix(1):ref.Bellatrix(2));
Mouse{2}.sesh = MD(ref.Polaris(1):ref.Polaris(2));

num_animals = length(Mouse);

%% Calculate the dispersion of firing for each
comps = [ 2 6; 3 6; 4 6; 7 6]; % session comparisons to make - all to cpp session % other sessions [2 3; 2 4; 2 7; 2 8; 3 4; 3 7; 3 8; 7 8];
for j = 1:num_animals
    Mouse{j}.kstest.h = nan(1,size(comps,1));
    Mouse{j}.kstest.p = nan(1,size(comps,1));
    for k = 1:size(comps,1)
        dd_mean = cell(1,2);  dd_std = cell(1,2); % pre-allocate/clear
        for ll = 1:2
            dirstr = ChangeDirectory_NK(Mouse{j}.sesh(comps(k,ll)),0);
            load(fullfile(dirstr,'Placefields.mat'),'PSAbool','x','y')
            [dd_mean{ll}, dd_std{ll}] = calc_trans_spread(PSAbool,x,y);
            Mouse{j}.dd_mean{k,ll} = dd_mean{ll};
        end
        [Mouse{j}.kstest.h(k), Mouse{j}.kstest.p(k)] = kstest2(dd_mean{1}, dd_mean{2}, ...
            'alpha', 0.05/size(comps,1),'tail','unequal'); % tail larger for Bellatrix tests alt hypothesis that CPP sesh is more dispersed than others, vice-versa for Polaris
    end
end

% synopsis is that Bellatrix has significantly larger fields under CPP
% whereas Polaris has significantly smaller fields under CPP.  Hypothesis
% is that NMDA receptors are critical to providing good spatial
% information, and that smearing that information during testing corrupts
% the memory...

%% Plot
bins = 0:1:35;

row_use = find(comps(:,1) == 2 & comps(:,2) == 6); % Get comparison to use
figure(10)
for j = 1:2
    subplot(2,2,j)
    for k = 1:2
        histogram(Mouse{j}.dd_mean{row_use,k},bins,'normalization','probability')
        hold on
    end
    xlabel('Mean distance between firing events (cm)')
    ylabel('Probability')
    legend('Saline','CPP')
    title(Mouse{j}.sesh(1).Animal(1:(regexpi(Mouse{j}.sesh(1).Animal,'_')-1)))
    hold off
end