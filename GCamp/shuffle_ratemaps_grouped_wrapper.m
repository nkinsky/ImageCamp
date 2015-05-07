%rvp_grouped2_wrapper

start_time_batch = tic;
task = '2env';
type = {'square' 'square' 'octagon' 'octagon'};
rot_array = [0 1 0 1];

for kk = 1:4
    rot_overwrite = rot_array(kk);
    disp(['BATCH RUN OF ' type{kk} ' SESSIONS WITH rot_overwrite = ' num2str(rot_overwrite)])
    ind_use = 1:8; % Indices
    for jj = 1: length(ind_use)-1
        for mm = jj+1:length(ind_use)
        clearvars -except jj kk mm ind_use type rot_array rot_overwrite start_time_batch task
        close all
        
        
        %Definintions of analysis days and sessions to use...
        analysis_days_octagon = [2 2 3 3 5 6 8 8];
        analysis_sesh_octagon = [1 2 1 2 2 2 1 2];
        analysis_days_square = [1 1 4 4 5 6 7 7];
        analysis_sesh_square = [1 2 1 2 1 1 1 2];
        
        k = ind_use(jj);
        for m = 1:2
            if strcmpi(type{kk},'octagon')
                analysis_day(1) = analysis_days_octagon(jj);
                analysis_session(1) = analysis_sesh_octagon(jj);
                analysis_day(2) = analysis_days_octagon(mm);
                analysis_session(2) = analysis_sesh_octagon(mm);
            elseif strcmpi(type{kk},'square')
                analysis_day(1) = analysis_days_square(jj);
                analysis_session(1) = analysis_sesh_square(jj);
                analysis_day(2) = analysis_days_square(mm);
                analysis_session(2) = analysis_sesh_square(mm);
            end
            
        end
        batch_run = 1;
        shuffle_ratemaps_grouped2
        end
    end
end
disp(['Batch session completed in ' num2str(toc(start_time_batch)) ' seconds.'])