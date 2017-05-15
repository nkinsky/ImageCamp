%% Cell recruitment vetting
% Goal = prove that the cell/PF recruitement curves I see in PSAbool are
% NOT an artifact of Tenaspis
% 1) Plot sorted PSAbool by recruitment time along with the raw traces
% sorted the same way - then, prove that we get more legitimate transients
% afterward (problem is that in dense preps with lots of overlapping cells
% it may not look that convincing due to buddy neuron firing corrupting the
% trace)
%  - may need to quantify by looking at rate of threshold crossing and/or
%  average trace maginitude/time above threshold before/after recruitment
%  time
%
% 2) Do the above with a very sparse session (e.g. G48)

[MD, ref] = MakeMouseSessionList('Natlaptop');
[MD, ref] = MakeMouseSessionListNK('Natlaptop');
%% 1 ) Plot sorted PSAbool along with sorted Traces
% Specify session to use
twoenv_reference;
sesh_use = G48_square(5);

% Load relevant variables
dirstr = ChangeDirectory_NK(sesh_use);
load(fullfile(dirstr,'FinalOutput.mat'),'PSAbool','NeuronTraces');
[PSAbool_sort, sort_ind] = sortPSA(PSAbool);
LPtrace_sort = NeuronTraces.LPtrace(sort_ind,:);
num_neurons = size(LPtrace_sort,1);

% plot it
figure(20)
subplot(2,2,1)
imagesc(PSAbool_sort)
title([mouse_name_title(sesh_use.Animal) ': PSAbool - sorted'])

subplot(2,2,3)
imagesc(LPtrace_sort > 0.025)
title([mouse_name_title(sesh_use.Animal) ': LPtrace - sorted'])
% colorbar

htrace = subplot(2,2,4);
neuron_incr = round(num_neurons/30);
neurons_plot = 1:neuron_incr:num_neurons;
plot_neuron_traces(flip(LPtrace_sort(neurons_plot,:)),nan,htrace);
% set(gca,'YDir','reverse')

%% 1a) Calculate before v after firing
num_neurons = size(PSAbool,1);
num_frames = size(PSAbool,2);
recruit_frame = nan(num_frames,1);

offset = 20; %number of frames before/after cell recruitment to exclude from the analysis
ba_sum = nan(num_neurons,2);
for j = 1:num_neurons
   recruit_frame(j) = find(PSAbool_sort(j,:), 1, 'first'); % Get time of recruitment
   before_temp = sum(LPtrace_sort(j,1:max([recruit_frame(j)-offset, 1])))/...
       max([recruit_frame(j)-offset,1]);
   after_temp = sum(LPtrace_sort(j,recruit_frame(j)+offset:end))/...
       (num_frames - recruit_frame(j));
   ba_sum(j,:) = [before_temp, after_temp];
end

ztrace = (LPtrace_sort-mean(LPtrace_sort,2))./std(LPtrace_sort,0,2);

% Sum up number of epochs above threhold (max z score of trace divided by
% some arbitrary number bigger than 1).


