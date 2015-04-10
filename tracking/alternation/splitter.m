function stem_cells = splitter(x,y,FT,numtrials,plotme)
%function stem_cells = splitter(x,y,FT,numtrials,plotme)
%
%   This function takes the position data of the mouse plus FinalTraces.mat
%   and splits trials up into left and right (correct trials only). It
%   looks at cell activity when the mouse is traversing the center stem and
%   plots a place field for both left and right trials. 
%
%   INPUTS: 
%       X & Y: Position vectors after passing through
%       PreProcessMousePosition. 
%       
%       FT: FinalTraces.mat.
%       
%       numtrials: Number of laps the mouse ran. 
%
%       plotme: A vector specifying which cells you want this function
%       to plot place maps for. 
%
%   OUTPUT: 
%       stem_cells: Struct with the following fields:
%           left = Cell array with each (MATLAB) cell being the
%           occupancy-normalized activity of each (hippocampal) cell at the
%           center stem preceding left turns. 
%           right = Same but for right turns. 
%

%% Split sesssion into trials. 
    data = postrials(x,y,0,numtrials); 
    
%% Find section borders. 
    bounds = sections(x,y);
    
%% Find center stem occupancy for left and right trials (correct only).  
    %Get section #s for entire session. 
    sect = getsection(x,y);  
    sect = sect';
   
    %Separate left vs. right trials and find center stem occupancy. 
    left = data.frames(data.choice == 1 & data.alt == 1 & sect(2,:) == 2); 
    right = data.frames(data.choice == 2 & data.alt == 1 & sect(2,:) == 2); 
    
%% Occupancy histogram.
    %Define boundaries. 
    num_pix = 15;
    xmin = min(bounds.center.x); xmax = max(bounds.center.x); 
    ymin = min(bounds.center.y); ymax = max(bounds.center.y); 
    xedges = linspace(xmin, xmax, num_pix); 
    yedges = linspace(ymin, ymax, num_pix); 
    
    %Occupancy. 
    left_occ = hist2(x(left), y(left), xedges, yedges); 
    right_occ = hist2(x(right), y(right), xedges, yedges); 
    
    %Smoothing kernel. 
    krnl = gausswin(5)*gausswin(5)';
    krnl = krnl./sum(sum(krnl));   
    
    %Smooth. 
    left_occ = conv2(left_occ,krnl,'same'); 
    right_occ = conv2(right_occ,krnl,'same'); 
    
%% Extract traces. 
    %Check if oopsi was already run. 
    num_cells = size(FT,1); 
    try 
        load('WM_spiketrain.mat');
    catch
        
        %If not, prepare oopsi. 
        SR = 20;
        V.Ncells = 1;
        V.T = size(FT,2);
        V.dt = 1/SR;
        P.gam = 0.988;  %0.941 no idea what this is. 
        V.fast_poiss = 1;
        spiketrain = zeros(size(FT));

        %Run oopsi. 
        for i = 1:num_cells
            if(sum(FT(i,:)) > 0)
                spiketrain(i,:) = DWS_oopsi(FT(i,:),V,P);
                spiketrain(i,find(spiketrain(i,:) <= 0.05)) = 0; %Takes care of a case where oopsi gives funky results for mostly 0 traces
            else
                spiketrain(i,:) = 0;
            end
        end
        
        %Save traces. 
        save WM_spiketrain.mat;
        
    end
    
%% Create occupancy-normalized "fluorescence rate" maps.
    %Threshold for spiking. Is zero a good threshold? I don't know...
    thresh = 0; 
    
    %Preallocate. 
    left_spk_posx = cell(1,num_cells); 
    left_spk_posy = cell(1,num_cells); 
    right_spk_posx = cell(1,num_cells); 
    right_spk_posy = cell(1,num_cells); 
    left_place = cell(1,num_cells);
    right_place = cell(1,num_cells); 
    
    %Subset of X and Y locations. This set contains only center stem
    %occupancies. 
    xleft = x(left); yleft = y(left); 
    xright = x(right); yright = y(right); 
    close all;      %Clear figures. 
    
    for this_cell = 1:num_cells
        %Get spike positions. 
        left_spk_posx{this_cell} = xleft(spiketrain(this_cell,left) > thresh);
        left_spk_posy{this_cell} = yleft(spiketrain(this_cell,left) > thresh); 

        right_spk_posx{this_cell} = xright(spiketrain(this_cell,right) > thresh);
        right_spk_posy{this_cell} = yright(spiketrain(this_cell,right) > thresh);
        
        %Histogram of spike positions. 
        left_spk_pos = hist2(left_spk_posx{this_cell}, left_spk_posy{this_cell}, xedges, yedges); 
        right_spk_pos = hist2(right_spk_posx{this_cell}, right_spk_posy{this_cell}, xedges, yedges); 
        
        %Place fields. 
        left_place{this_cell} = left_spk_pos ./ left_occ;
        right_place{this_cell} = right_spk_pos ./ right_occ;
        
        %Smooth. 
        left_place{this_cell} = conv2(left_place{this_cell},krnl,'same'); 
        right_place{this_cell} = conv2(right_place{this_cell},krnl,'same');  
        left_place{this_cell} = interp2(left_place{this_cell},3); 
        right_place{this_cell} = interp2(right_place{this_cell},3); 
        
        %Plot the cells specified by argument plotme. 
        if ismember(this_cell,plotme)
            %Normalize color axes. 
            color_range = [ min([min(left_place{this_cell}(:)), min(right_place{this_cell}(:))]),...
                max([max(left_place{this_cell}(:)), max(right_place{this_cell}(:))]) ]; 
            
            figure;
            ha = tight_subplot(2,1,[.1 0.1],[.1 .1],[.1 .1]); 
            axes(ha(1)); 
                pcolor(left_place{this_cell});
                shading flat; 
                axis equal; axis tight;
                set(gca,'XTick',[]);set(gca,'YTick',[]);
                title(['Cell ', num2str(this_cell)], 'fontsize', 12); 
                colorbar;
                caxis(color_range); 
  
            axes(ha(2)); 
                pcolor(right_place{this_cell});
                shading flat; 
                axis equal; axis tight;
                set(gca,'XTick',[]);set(gca,'YTick',[]);
                title(['Cell ', num2str(this_cell)], 'fontsize', 12);
                colorbar;
                caxis(color_range);          
        end
    end

%% Build the struct. 
    stem_cells.left = left_place;
    stem_cells.right = right_place; 
end