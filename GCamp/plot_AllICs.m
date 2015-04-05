function [AllIC] = plot_AllICs( GoodICf, plotflag )
%plot_AllICs Plot all the independent components for a given session on the
%same field of view
%  
% INPUTS:
% GoodICf:  cell array containing all the good ICs
% plotflag: 1 = plot, 0 or no argument = noplot

AllIC = zeros(size(GoodICf{1})); % Create AllIC array
for j = 1:size(GoodICf) 
    AllIC = AllIC + GoodICf{j}; 
end

if nargin == 1
elseif nargin == 2 && plotflag == 1
    figure
    imagesc(AllIC); title('All Independent Component Masks');
end

end

