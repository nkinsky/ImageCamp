function [] = bar_w_err( x, err_bars )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if size(x,1) == 1 || size(x,2) == 1
    num_groups = 1;
else
    num_groups = size(x,2);
end

h = bar(x);
hold on

if num_groups == 1
    errorbar(h.XData + h.XOffset, x, err_bars,'k.'); 
elseif num_groups > 1
    for j = 1:num_groups
        errorbar(h(j).XData + h(j).XOffset, x(:,j), err_bars(:,j),'k.');
    end
end


end

