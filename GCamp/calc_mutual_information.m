function [ mut_info ] = calc_mutual_information( TMap, OccMap )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% For each neurons:
% TMap = p(x,spike = 1) - NOTE MUST BE UNSMOOTHED TMAP!!!
% 1 - TMap = p(x,spike = 0) 
% p(x) = OccMap/TotalTime
% p(x & s = 1) = TMap.*p(x);
% p(x & s = 0) = (1 - TMap).*p(x);
% p(s = 1) = num_spikes/TotalTime;
% p(s = 0) = 1 - p(s = 1);
% 

% keyboard

%%
num_pos = length(TMap(:));

px = OccMap/sum(OccMap(:));
px_s1 = TMap.*px;
px_s0 = (1-TMap).*px;
ps_1 = sum(px_s1(:));
ps_0 = 1 - ps_1;

s = [0 1];
x = 1:num_pos;
xvalid = find(px > 0);

%% Calculate mutual information
mut_info = 0;
for i = 1:length(s)
    for j = 1:length(xvalid)
        if s(i) == 1
            if px_s1(xvalid(j)) ~= 0
                temp = px_s1(xvalid(j))*log(px_s1(xvalid(j))/(px(xvalid(j))*ps_1));
            else
                temp = 0;
            end
        elseif s(i) == 0
            if px_s0(xvalid(j)) ~= 0
                temp = px_s0(xvalid(j))*log(px_s0(xvalid(j))/(px(xvalid(j))*ps_0));
            else
                temp = 0;
            end
        end
        
        if isnan(temp) || ~isreal(temp) % Error catching
            disp('Calculated mutual information value is Nan or complex! Error-catching started!')
%             keyboard
        end
        mut_info = mut_info + temp;
    end
end



end

