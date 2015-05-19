% Alternation behavior script
mouse(2).name = 'G30';
mouse(2).dates = {'10/16/2014' '10/17/2014' '10/21/2014' '10/23/2014' ...
    '10/28/2014' '10/30/2014' '10/31/2014' '11/4/2014' '11/6/2014' ...
    '11/7/2014' '11/10/2014' '11/11/2014' '11/12/2014' '11/13/2014' ...
    '12/5/2014' '12/9/2014'};
mouse(2).success_approx = [nan nan nan nan 0.5 0.5 34/40 34/44 32/40 33/40 33/40 ...
    36/40 43/50 53/60 30/40 35/42];

mouse(3).name = 'G31';
mouse(3).dates = {'11/24/2014' '11/25/2014' '11/26/2014' '12/2/2014' '12/3/2014' ...
    '12/4/2014' '12/5/2014' '12/8/2014' '12/9/2014' '12/10/2014' '12/11/2014' ...
    '12/12/2014' '12/23/2014'};
mouse(3).success_approx = [nan nan nan 31/40 27/40 28/40 34/40 31/40 30/40 28/40 ...
    34/40 27/40];

mouse(1).name = 'G27';
mouse(1).success_approx = [nan nan nan 33/40 0.5 0.5 35/40 37/50 39/50 35/40 55/58 ...
    43/50 43/50 28/42];

max_length = max(arrayfun(@(a) length(a.success_approx),mouse));

% hack to align trials to last trial
success_combined = nan(length(mouse),max_length);
for j = 1:length(mouse)
   success_combined(j,(max_length-length(mouse(j).success_approx)+1:end)) = ...
       mouse(j).success_approx;
end

comb_mean = nanmean(success_combined,1);
comb_sem = nanstd(success_combined,1)./sqrt(nansum(~isnan(success_combined),1));

%%
figure;
plot(1:length(comb_mean),comb_mean,'b*-',[1 length(comb_mean)],[0.5 0.5],'r--',...
    [1 length(comb_mean)],[0.75 0.75],'g--');
hold on
errorbar(1:length(comb_mean),comb_mean,comb_sem)
ylim([0 1]);