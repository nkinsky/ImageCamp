%rvp_grouped2_wrapper

start_time_batch = tic;
task = '2env';
type = {'square' 'square' 'octagon' 'octagon'};
rot_array = [0 1 0 1];

for kk = 1:4
    rot_overwrite_batch = rot_array(kk);
    disp(['BATCH RUN OF ' type{kk} ' SESSIONS WITH rot_overwrite = ' num2str(rot_overwrite)])
    ind_use = 1:7; % Indices
    for jj = 1: length(ind_use)
        clearvars -except jj kk ind_use type rot_array rot_overwrite_batch start_time_batch task
        close all
        
        
        %Definintions of analysis days and sessions to use...
        analysis_days_octagon = ...
            [ 2 2 3 3 5 8 8 ; ...
            2 3 3 5 6 6 8];
        analysis_sesh_octagon = ...
            [ 1 2 1 2 2 1 1 ; ...
            2 1 2 2 2 2 2];
        
        analysis_days_square = ...
            [1 1 4 4 5 7 7; ...
            1 4 4 5 6 6 7];
        analysis_sesh_square = ...
            [1 2 1 2 1 1 1; ...
            2 1 2 1 1 1 2];
        
        k = ind_use(jj);
        for m = 1:2
            if strcmpi(type{kk},'octagon')
                analysis_day(m) = analysis_days_octagon(m,k);
                analysis_session(m) = analysis_sesh_octagon(m,k);
            elseif strcmpi(type{kk},'square')
                analysis_day(m) = analysis_days_square(m,k);
                analysis_session(m) = analysis_sesh_square(m,k);
            end
            
        end
        batch_run = 1;
        reverse_placefield_grouped2
        
    end
end
disp(['Batch session completed in ' num2str(toc(start_time_batch)) ' seconds.'])