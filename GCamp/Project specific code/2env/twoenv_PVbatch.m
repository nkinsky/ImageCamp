function [ PVcorrs, PVshuf_corrs, pthresh, ntrans_thresh, PVcell, filtcell ] = ...
    twoenv_PVbatch(ref_struct, best_angle, same_arena, num_shuffles, ...
    silent_thresh, pthresh, ntrans_thresh, local_aligned, cmperbin )
% [ PVcorrs, PVshuf_corrs, pthresh, ntrans_thresh, PVcell, filtcell ] = ...
%     twoenv_PVbatch(ref_struct, best_angle, same_arena, num_shuffles, ...
%     silent_thresh, pthresh, ntrans_thresh, local_aligned, cmperbin )

%%% NRK Notes: QC this by comparing direct pairwise (run overnight) with
%%% batch_session_map, then do with silent_thresh = 0 vs 1 vs nan.

if nargin < 9
    cmperbin = 4;
    if nargin < 8
        local_aligned = false;
        if nargin < 7
            ntrans_thresh = 5;
            if nargin < 6
                pthresh = 0.05;
                if nargin < 5
                    silent_thresh = nan;
                    if nargin < 4
                        num_shuffles = 100;
                    end
                end
            end
        end
    end
end


num_sessions = length(ref_struct);

if local_aligned
    best_angle = zeros(1,num_sessions);
end
if same_arena
    load(fullfile(ChangeDirectory_NK(ref_struct(1)),'batch_session_map.mat'));
    PFname_append = arrayfun(@(a) ['_cm' num2str(cmperbin) '_rot' num2str(a)], ...
        best_angle, 'UniformOutput', false);
elseif ~same_arena
    load(fullfile(ChangeDirectory_NK(ref_struct(1)),'batch_session_map_trans.mat'));
    PFname_append = arrayfun(@(a) ['_cm' num2str(cmperbin) '_trans_rot' num2str(a)], ...
        best_angle, 'UniformOutput', false);
end
batch_session_map = fix_batch_session_map(batch_session_map);

PVcell = cell(num_sessions, num_sessions);
disp(['Running PV batch analysis for ' ref_struct(1).Animal])
if same_arena
    PVcorrs = nan(num_sessions);
    PVshuf_corrs = nan(num_sessions, num_sessions, num_shuffles);
    p = ProgressBar(num_sessions*(num_sessions-1)/2);
    for j = 1:num_sessions-1
        MD1 = ref_struct(j);
        for k = j+1:num_sessions
            MD2 = ref_struct(k);
            PFnames_use = PFname_append([j k]);
            [corrs_temp, PV1, PV2, final_filt] = pairwise_PVcorr(MD1, MD2, 'silent_thresh',...
                silent_thresh, 'PFname_append', PFnames_use, 'pval_thresh',...
                pthresh, 'ntrans_thresh', ntrans_thresh, 'batch_map', ...
                batch_session_map);
            PVcorrs(j,k) = nanmean(corrs_temp(:));
            shuf_temp = shuffle_PVcorrs(PV1, PV2, num_shuffles, 'bin');
            PVshuf_corrs(j,k,:) = squeeze(nanmean(nanmean(shuf_temp,1),2));
            p.progress;
            PVcell{j,k} = shiftdim(cat(4,PV1,PV2),3);
            filtcell{j,k} = final_filt;
        end
    end
elseif ~same_arena
    square_sesh = [1 2 7 8 9 12 13 14];
    circ_sesh = [3 4 5 6 10 11 15 16];
    PVcorrs = nan(num_sessions/2);
    PVshuf_corrs = nan(num_sessions/2, num_sessions/2, num_shuffles);
    p = ProgressBar(num_sessions^2);
    for j = 1:num_sessions/2
        square_ind = square_sesh(j);
        MD1 = ref_struct(square_ind);
        for k = 1:num_sessions/2
            circ_ind = circ_sesh(k);
            MD2 = ref_struct(circ_ind);
            PFnames_use = PFname_append([square_ind circ_ind]);
            [corrs_temp, PV1, PV2, final_filt] = pairwise_PVcorr(MD1, MD2, 'silent_thresh',...
                silent_thresh,'PFname_append', PFnames_use, 'pval_thresh',...
                pthresh, 'ntrans_thresh', ntrans_thresh, 'batch_map', ...
                batch_session_map);
            PVcorrs(j,k) = nanmean(corrs_temp(:));
            shuf_temp = shuffle_PVcorrs(PV1, PV2, num_shuffles, 'bin');
            PVshuf_corrs(j,k,:) = squeeze(nanmean(nanmean(shuf_temp,1),2));
            p.progress;
            PVcell{j,k} = shiftdim(cat(4,PV1,PV2),3);
            filtcell{j,k} = final_filt;
        end
    end
end
p.stop;

end

