%rvp_grouped2_wrapper

ind_use = [6 7];
for j = 1: length(ind_use)
    clearvars -except j ind_use
    close all
    
    analysis_days_octagon = [ 2 2 3 3 5 8 8 ; ...
        2 3 3 5 6 6 8];
    analysis_sesh_octagon = [ 1 2 1 2 2 2 1 ; ...
        2 1 2 2 2 2 2];
    
    analysis_day(1) = 3; analysis_session(1) = 1;
    analysis_day(2) = 3; analysis_session(2) = 2;
    
    k = ind_use(j);
    analysis_day(1) = analysis_days_octagon(1,k);
    analysis_session(1) = analysis_sesh_octagon(1,k);
    analysis_day(2) = analysis_days_octagon(2,k);
    analysis_session(2) = analysis_sesh_octagon(2,k);
    reverse_placefield_grouped2
   
end