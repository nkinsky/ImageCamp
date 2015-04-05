% Plot traces

close all;

NumICA = 200;

for i = 1:NumICA % load the ICA .mat file, put it in a data structure
    filename = ['Obj_',int2str(i),'_2 - IC trace ',int2str(i),'.mat'];
    load(filename); % loads two things, Index and Object
    IC{i} = Object(1).Data;
end

figure(1)
num_traces = 10;
for j = 1:num_traces
    subplot(num_traces,1,j);
    plot(IC{j})
end

