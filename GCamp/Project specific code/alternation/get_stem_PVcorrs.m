function [ stemPVcorrs, stemPVcorrsz ] = get_stem_PVcorrs( MD )
% [ stemPVcorrs, stemPVcorrsz ] = get_stem_PVcorrs( MD )
%   Geta population vector correlations on the stem for L v R trials

dirstr = ChangeDirectory_NK(MD,0);
load(fullfile(dirstr,'Placefields.mat'),'PSAbool','x','y','xEdges','yEdges');
load(fullfile(dirstr,'Alternation.mat'),'Alt'); % Do some error catching here!

[PV, PVz] = get_stemPV(x,y,PSAbool,Alt);

nbins = size(PV,3);
stemPVcorrs = nan(1,nbins);
stemPVcorrsz = nan(1,nbins);
for j = 1:nbins
    stemPVcorrs(j) = corr(squeeze(PV(1,:,j))',squeeze(PV(2,:,j))',...
        'type','Spearman','rows','complete');
    stemPVcorrsz(j) = corr(squeeze(PVz(1,:,j))',squeeze(PVz(2,:,j))',...
        'type','Spearman','rows','complete');
end

%%% NRK Next step is to do this for Lodd v Leven trials and Rodd v Reven
%%% trials

end

