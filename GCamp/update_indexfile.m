function [ ] = update_indexfile( infilename, outfilename )
%update_indexfile( infilename, outfilename) Updates Index/Object variables 
% in h5 reference file so that you can open easily in Mosaic
 
% Get infilename and outfilename without extension
if isempty(regexp(infilename,'\.', 'once'))
    infilename_short = infilename;
else
    infilename_short = infilename(1:regexp(infilename,'\.')-1);
end

if isempty(regexp(outfilename,'\.', 'once'))
    outfilename_short = outfilename;
else
    outfilename_short = outfilename(1:regexp(outfilename,'\.')-1);
end

% Load variable
load([infilename_short '.mat'])

Index.H5File = [outfilename_short '.h5'];
Index.ObjFile = [outfilename_short '.mat'];
Index.ListText = outfilename_short;
Object.ListText = outfilename_short;

save([outfilename_short '.mat'],'Index','Object')


end

