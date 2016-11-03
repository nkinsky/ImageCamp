% Implement Ziv (2013) style neuron registration to ensure you are doing
% things correctly

session{1} = MD(ref.G30.two_env(1));
session{2} = MD(ref.G30.two_env(1)+2);

%% Paramaters
num_trans_thresh = 5; % Only use neurons whose activity is above this level...

%% Step 1: Plot out and ID neurons in 1st and 2nd session with high levels of activity

figure(60)
for j = 1:length(session)
    ChangeDirectory_NK(session{j});
    load('ProcOut.mat','NeuronImage','NumTransients')
    load('MeanBlobs.mat','BinBlobs');
    session{j}.high_active_NeuronImage = NeuronImage(NumTransients > num_trans_thresh);
    session{j}.high_active_BinBlobs = BinBlobs(NumTransients > num_trans_thresh);
    session{j}.high_active_AllNeurons = create_AllICmask(...
        session{j}.high_active_NeuronImage);
    session{j}.high_active_AllBinBlobs = create_AllICmask(...
        session{j}.high_active_BinBlobs);
    subplot(2,2,2*(j-1)+1)
    imagesc(session{j}.high_active_AllNeurons)
    title(['Session ' num2str(j) ' All_NeuronImage for minimum ' num2str(num_trans_thresh) ' transients'])
    subplot(2,2,2*(j-1)+2)
    imagesc(session{j}.high_active_AllBinBlobs)
    title(['Session ' num2str(j) ' All_BinBlobs for minimum ' num2str(num_trans_thresh) ' transients'])
end


%% QC
actual_tformfile = 'RegistrationInfo-GCamp6f_30-11_26_2014-session2.mat'; %'RegistrationInfo-GCamp6f_30-11_19_2014-session2_actual.mat';
basename = 'RegistrationInfo-GCamp6f_30-11_26_2014-session2_ziv_reg'; % 'RegistrationInfo-GCamp6f_30-11_19_2014-session2_ziv_reg';

reg_actual = importdata(actual_tformfile);
phi_actual = acosd(reg_actual.tform.T(1,1));

phi_diff = nan(1000,1);
dist_diff = nan(1000,1);
p = ProgressBar(1000);
for j = 1:1000
    
    % Load each file
    file_load = [basename num2str(j) '.mat'];
    reg_ziv = importdata(file_load);
    phi_diff(j) = acosd(reg_ziv.tform.T(1,1)) - phi_actual;
    tform_diff = reg_actual.tform.T - reg_ziv.tform.T;
    dist_diff(j) = sqrt(tform_diff(3,1)^2 + tform_diff(3,2)^2);
    
    p.progress;
    
end

p.stop;

%%
ddist_all = [dist_diff_near, dist_diff_far1, dist_diff_far2];
dphi_all = abs([phi_diff_near, phi_diff_far1, phi_diff_far2]);
titles_use = {'Near Session', 'Far Session', 'Far Session2'};


for j = 1:3
    figure(20)
    subplot(2,3,j)
    histogram(ddist_all(:,j),30);
    xlabel('Translation Difference (pixels)');
    ylabel('Count')
    title(titles_use{j})
    
    subplot(2,3,3+j)
    histogram(dphi_all(:,j),30);
    xlabel('Rotation Difference (degrees)');
    ylabel('Count')
    title(titles_use{j})
    
    figure(21)
    subplot(2,1,1)
    histogram(ddist_all(:,j),0:4:120);
    xlabel('Translation Difference (pixels)');
    ylabel('Count')
    hold on
    
    subplot(2,1,2)
    histogram(dphi_all(:,j),0:0.25:7);
    xlabel('Rotation Difference (degrees)');
    ylabel('Count')
    hold on
    
    figure(22)
    subplot(2,1,1)
    ecdf(ddist_all(:,j))
    xlabel('Translation Difference (pixels)');
    hold on
    
    subplot(2,1,2)
    ecdf(dphi_all(:,j));
    xlabel('Rotation Difference (degrees)');
    hold on
    
end

figure(21)
subplot(2,1,1)
legend(titles_use);
hold off
subplot(2,1,2)
legend(titles_use);
hold off

figure(22)
subplot(2,1,1)
legend(titles_use);
hold off
subplot(2,1,2)
legend(titles_use);
hold off