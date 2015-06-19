function [cell_ind,PF_ind] = FindStemPFs(session,skip_rot_check)
%stem_cells = FindStemPFs(session)
%   
%   Looks for the cells that have PFs in the center stem. This function
%   uses the PFcentroid output from PFstats (which is already thresholded)
%   to find stem PFs that fall in the boundaries of the stem. 
%
%   INPUT: 
%       session: Directory containing Placemaps.mat and PFstats.mat. 
%
%       skip_rot_check: Logical indicating whether or not you want to skip
%       the check for animal trajectory rotation. 
%
%   OUTPUT:
%       cell_ind: Nx1 vector (where N is the number of PFs on the stem)
%       containing the indices of cells active on the arm above a threshold
%       specified in PFstats.m.
%
%       PF_ind: Nx1 vector indexing the PFs (second column) of the
%       variablse in PFstats. 
%

%% Load place fields. 
    load(fullfile(session,'Placemaps.mat'), 'x','y','TMap','Xedges','Yedges'); 
    load(fullfile(session,'PFstats.mat'), 'PFcentroid');
        
%% Useful parameters.
    cell_ind = []; 
    PF_ind = []; 
    
%% Obtain cells that have a PF in the center stem. 
    bounds = sections(x,y,skip_rot_check); 
    
    %Get boundaries around the center stem. 
    XStemBounds = [findclosest(bounds.center.x(1),Xedges), findclosest(bounds.center.x(2),Xedges)];
    YStemBounds = [findclosest(bounds.center.y(1),Yedges), findclosest(bounds.center.y(3),Yedges)]; 
    
    %Get all the PFs for each cell that have a good centroid.
    [good_cells,good_PFs] = find(~cellfun(@isempty, PFcentroid)); 
    num_good_PFs = length(good_PFs); 
   
    %Get the PFs whose centroids lie within the bounds of the center stem. 
    for this_PF = 1:num_good_PFs
        
        if PFcentroid{good_cells(this_PF),good_PFs(this_PF)}(1) >= YStemBounds(1) &&...     %Centroids are rotated...
                PFcentroid{good_cells(this_PF),good_PFs(this_PF)}(1) <= YStemBounds(2) &&...
                PFcentroid{good_cells(this_PF),good_PFs(this_PF)}(2) >= XStemBounds(1) &&...
                PFcentroid{good_cells(this_PF),good_PFs(this_PF)}(2) <= XStemBounds(2)
            cell_ind = [cell_ind; good_cells(this_PF)]; 
            PF_ind = [PF_ind; good_PFs(this_PF)]; 
        end
    end
    
    save StemCells.mat cell_ind PF_ind;
end