function [  ] = sig_on_confmat( ha, confmat, hmat, pmat )
% sig_on_confmat( ha, confmat, hmat, pmat )
%   Plots significance in hmat on top of confusion matrix confmat into axes
%   ha. hmat must be logical or zeros/ones/nans. 1 = *, 2 = n.s., 3 = not
%   plotted. Entering in a pmat the same size as the hmat plots pvalues at
%   all locations with a 1 in hmat.

pplot = true;
if nargin < 4
    pplot = false;
end

axes(ha);
imagesc_nan(confmat);
hold on
[ii,jj] = find(hmat == 1 & ~isnan(hmat));
if pplot
    kk = sub2ind(size(pmat),ii,jj);
    ptext = arrayfun(@(a) num2str(a,'%0.3g'), pmat,'UniformOutput',false);
    ht = text(jj,ii,ptext(kk));
    [ht(:).HorizontalAlignment] = deal('Center');
elseif ~pplot
    plot(jj,ii,'k*')
end

[ii,jj] = find(hmat == 0 & ~isnan(hmat));
ht = text(jj,ii,'n.s');
[ht(:).HorizontalAlignment] = deal('Center');
hold off

end

