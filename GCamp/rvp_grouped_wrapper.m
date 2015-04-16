%rvp_grouped2_wrapper

type = 'octagon'
ind_use = 1:7; % Indices
for jj = 1: length(ind_use)
    clearvars -except jj ind_use type
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
        if strcmpi(type,'octagon')
            analysis_day(m) = analysis_days_octagon(m,k);
            analysis_session(m) = analysis_sesh_octagon(m,k);
        elseif strcmpi(type,'square')
            analysis_day(m) = analysis_days_square(m,k);
            analysis_session(m) = analysis_sesh_square(m,k);
        end
            
    end
    batch_run = 1;
    reverse_placefield_grouped2
   
end