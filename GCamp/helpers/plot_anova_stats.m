function [ h ] = plot_anova_stats( panova, c, alpha, h )
% h  = plot_anova_stats( panova, c, alpha, h )
%   Writes anova stats into the axes specified in h (optional) at
%   significance level alpha (default = 0.05);

if nargin < 4
    figure; h = gca;
    if nargin < 3
        alpha = 0.05;
    end
end

sig_comps = find(c(:,end) < alpha);
num_sig_comps = length(sig_comps);
axes(h);

rows = 0.1:(0.8/(num_sig_comps+1)):0.9;

text(0.1,0.1,['pANOVA = ' num2str(panova, '%0.2g')])
for j = 1:num_sig_comps
    ptext = ['p' num2str(c(sig_comps(j),1)) '_' ...
        num2str(c(sig_comps(j),2)) ' = ' num2str(c(sig_comps(j),end), '%0.2g')];
    text(0.1,rows(j+1),mouse_name_title(ptext))
end

text(0.1,0.9,['All other comparisons n.s. at alpha = ' num2str(alpha)])
axis off

end

