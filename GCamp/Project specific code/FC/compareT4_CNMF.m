% Compare Tenaspis and CNMF_E performance for a single session.
dir_use = 'e:\CNMF_E demos';
cnmf_filename = 'data_1p_results.mat';
SR = 10;

curr_dir = pwd;

cd(dir_use);
load('FinalOutput.mat','NeuronImage','NeuronTraces','PSAbool');
load(cnmf_filename)

% Make variable names nicer
ROI_T4 = NeuronImage;
rawtrace_T4 = NeuronTraces.RawTrace;
strace_T4 = NeuronTraces.LPtrace;
PSA_T4 = PSAbool;
n_T4 = size(PSA_T4,1);
rawtrace_cn = results.C_raw;
strace_cn = results.C;
PSA_cn = results.S > 0;
n_cn = size(rawtrace_cn,1);
times = (1:size(PSAbool,2))/SR;

% Make rough ROIs from CNMF data
[bigROI_cn, bigROIw_cn] = cnmf_makeROIs(results.A,results.Cn);

% Get rough centroids - ok for now, seems a bit off since some of these
% don't really plot on top of the appropriate place on the Cn matrix, but
% whatever.
[cent_cn, wcent_cn] = get_ROI_centroids(bigROI_cn, bigROIw_cn);
cent_T4 = get_ROI_centroids(NeuronImage);

% Get distances between all neurons
cm_dist = get_cm_dist(cent_T4, wcent_cn);
[mindist, ncn_min] = min(cm_dist,[],2);

%%
figure(25); 
h1 = subplot(3,2,1); hold off; 
h2 = subplot(3,2,2); hold off; 
h3 = subplot(3,2,3:4); hold off;
h4 = subplot(3,2,5:6); hold off;
n_out = 1; stay_in = true;
while stay_in
    
    % Get trace and centroid for T4, and neuron outline
    T4trace_use = rawtrace_T4(n_out,:);
    T4strace_use = strace_T4(n_out,:);
    T4max = max(T4trace_use);
    T4smax = max(T4strace_use);
    T4PSA_use = PSA_T4(n_out,:);
    centT4_use = cent_T4(n_out,:);
    b = bwboundaries(ROI_T4{n_out},'noholes');
    
    % Get trace and centroid for closes neuron in cnmf
    ncn = ncn_min(n_out);
    cntrace_use = rawtrace_cn(ncn,:);
    cnstrace_use = strace_cn(ncn,:);
    cnmax = max(cntrace_use);
    cnsmax = max(cnstrace_use);
    cnPSA_use = PSA_cn(ncn,:);
    centcn_use = wcent_cn(ncn,:);
    cntrace_use = cntrace_use*T4max/cnmax; % Scale traces to each other
    cnstrace_use = cnstrace_use*T4smax/cnsmax;
    
    subplot(h1);
    imagesc(results.Cn); hold on;
    hcn = plot(centcn_use(1), centcn_use(2),'r*');
    hT4 = plot(centT4_use(1), centT4_use(2),'b*');
    axis equal off
    legend(cat(1,hcn,hT4),{'CNMF\_E','T4'});
    title('CNMF Cn image with centroids on top')
    hold off
    
    subplot(h2);
    plot_neuron_outlines(results.Cn,ROI_T4{n_out},h2);
    colormap(gca,'parula'); colorbar('off');
    xlim([centT4_use(1) - 15, centT4_use(1) + 15])
    ylim([centT4_use(2) - 15, centT4_use(2) + 15])
    title('CNMF Cn image with T4 ROI outline on top')
    hold off
    
    subplot(h3);
    hT4 = plot(times, T4trace_use,'k-', ...
        times(T4PSA_use), T4trace_use(T4PSA_use),'ro');
    hold on
    hcn = plot(times, cntrace_use,'c--', ...
        times(cnPSA_use), cntrace_use(cnPSA_use),'g*');
    legend(cat(1,hT4,hcn),{'T4','T4','CNMF\_E','CNMF\_E'})
    title(['T4 Neuron ' num2str(n_out) ' - CNMF\_E neuron ' num2str(ncn)])
    hold off
    
    subplot(h4);
    hT4 = plot(times, T4strace_use,'k-', ...
        times(T4PSA_use), T4strace_use(T4PSA_use),'ro');
    hold on
    hcn = plot(times, cnstrace_use,'c--', ...
        times(cnPSA_use), cnstrace_use(cnPSA_use),'g*');
    legend(cat(1,hT4,hcn),{'T4','T4','CNMF\_E','CNMF|_E'})
    title(['T4 Neuron ' num2str(n_out) ' - CNMF\_E neuron ' num2str(ncn)])
    hold off
    
    
    [n_out, stay_in] = LR_cycle(n_out, [1 n_T4]);
    
end

%% 
figure(26); set(gcf,'Position', [2340 360 660 500]);
plot(get_num_trans(PSA_T4), get_num_trans(PSA_cn(ncn_min,:)),'r*');
xmax = max(get(gca,'XLim')); ymax = max(get(gca,'YLim'));
ntmax = max([xmax ymax]);
xlim([0 ntmax+5]); ylim([0 ntmax+5]);
hold on; plot([0 ntmax+5],[0 ntmax+5],'k--')

xlabel('# Transients T4'); ylabel('# Transients CNMF\_E')
