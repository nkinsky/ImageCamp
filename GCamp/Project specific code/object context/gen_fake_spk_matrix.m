% Script to generate fake sample matrix from alternation data in a good
% mouse to compare to Shoai's data from the object-context task

% Number of sample and neurons to use in creating fake matrix
num_samples = 50;
num_neurons = size(FT,1);

SR = 20;
sample_duration = 1; % seconds
sample_start = 600; % start of first sample to take in frames
gap = 400;  % gap between samples in frames
samples_use = sample_start:sample_start+sample_duration*SR; % random start for samples
for j = 1:num_samples % For each sample epoch, get calcium activity of each neuron
    index_use = samples_use + j*gap; 
    fake_activity(:,j) = sum(FT(:,index_use),2); 
    fake_activity_bin(:,j) = fake_activity(:,j) > 0; 
end

% Grab x random neurons (x specified above)
temp = randperm(size(FT,1)); 
rand_cells_use = temp(1:num_neurons);

% Generate fake spike matrices
fake_spk_mat = fake_activity(rand_cells_use,:)';
fake_spk_mat_bin = fake_activity_bin(rand_cells_use,:)';

figure(20)
subplot(1,2,1)
imagesc(fake_spk_mat)
subplot(1,2,2)
imagesc(fake_spk_mat_bin)


