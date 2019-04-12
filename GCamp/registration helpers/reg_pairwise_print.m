function [] = reg_pairwise_print(sessions, print_dir, sesh_inds)
% reg_pairwise_print(sessions, print_dir, sesh_inds)
%  Prints out pairwise regisrations with ROIs from each session overlaid to
%  a PDF in print_dir, or to sessions(1).Location if left blank. Specify
%  sesh_inds (nx2 array) if you only want to look at certain sessions.

if nargin < 2
   print_dir = sessions(1).Location; 
   if nargin < 3
       sesh_inds = nan;
   end
end

n_sesh = length(sessions);
ncomps = n_sesh*(n_sesh)/2;
Animal_name = sessions(1).Animal;

hw = waitbar(0, ['Plotting pairwise registrations to PDF for ' ...
    mouse_name_title(Animal_name)]);
n = 1;
if isnan(sesh_inds)
    
    for j = 1:(n_sesh-1)
        for k = (j+1):n_sesh
            plot_registration(sessions(j), sessions(k));
            printNK([ Animal_name ' - all registrations'], print_dir,'append',true);
            close(gcf)
            waitbar(n/ncomps, hw);
            n = n+1;
        end
        
    end
else
    ncomps = size(sesh_inds,1);
    for j = 1:ncomps
        ind_use1 = sesh_inds(j,1);
        ind_use2 = sesh_inds(j,2);
        plot_registration(sessions(ind_use1), sessions(ind_use2));
        printNK([ Animal_name ' - all registrations'], print_dir,'append',true);
        close(gcf)
        waitbar(n/ncomps, hw);
        n = n+1;
    end


close(hw)

end

