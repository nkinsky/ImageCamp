function [ ] = splitters_batch( MD )
% splitters_batch( MD )
%   Runs Will's splitter functions on all the sessions listed in MD
sesh = add_workdir(MD);

for j = 1:length(sesh)
   cd(sesh(j).dirstr);
   load(fullfile(sesh(j).dirstr,'Placefields.mat'),'PSAbool','x','y',...
       'xEdges','yEdges')
   in_arena = (y > min(yEdges) & y < max(yEdges) & x > min(xEdges) & ...
       x < max(xEdges));
   x = x(in_arena); y = y(in_arena);
   PSAbool = PSAbool(:,in_arena);
   sigtuningAllCells(x,y,PSAbool)
end


end

