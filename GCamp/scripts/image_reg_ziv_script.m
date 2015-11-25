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


