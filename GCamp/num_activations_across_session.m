function [ r2 ] = num_activations_across_session( FT1,FT2,cell_reg_map,index1,index2 )
%UNTITLED2 Plot number of activations for a cell across sessions, get r^2
%value
%   Detailed explanation goes here

close all

%% Initialize values
sesh(1).FT = FT1;
sesh(2).FT = FT2;
sesh(1).index = index1;
sesh(2).index = index2;

% sesh(1).FT = sesh1.FT;
% sesh(2).FT = sesh2.FT;
% cell_reg_map = CellRegisterInfo(2).cell_map;
% sesh(1).index = 1;
% sesh(2).index = 3;

num_cells = size(cell_reg_map,1);
num_activations = zeros(num_cells,2);
total_length_activations = zeros(num_cells,2);

%% Get number activations and length of activations

for j = 1:num_cells
    for k = 1:2
        if isempty(cell_reg_map{j,sesh(k).index})
            num_activations(j,k) = 0;
            length_activations(j,k) = 0;
        else
        trace = sesh(k).FT(cell_reg_map{j,sesh(k).index},:); % Assign appropriate trace to each cell
        
        temp = find(trace > 0); % Threshold traces to find values above 0 (activations)
        
        num_activations(j,k) = sum(diff(temp) > 1) + 1; % Get number activations
        length_activations(j,k) = length(temp);
        end
   
    end
       
end

% Perform a linear regression on the points to get p-values and r-squared
% values
lm_num = fitlm(num_activations(:,1),num_activations(:,2));
lm_len = fitlm(length_activations(:,1),length_activations(:,2));



%% PLOTS


% Actually plot everything
figure(50)
subplot(1,2,1)
plot(num_activations(:,1),num_activations(:,2),'b.')
xlabel('Number Activations Session 1'); 
ylabel('Number Activations Session 2');
xlim_num = get(gca,'XLim'); ylim_num = get(gca,'YLim');
num_max = max(xlim_num(2), ylim_num(2));
hold on
plot([0 num_max], [0 num_max],'r') % 1:1 line
plot([0 xlim_num(2)], [lm_num.Coefficients.Estimate(1) 
    lm_num.Coefficients.Estimate(1) + ...
    lm_num.Coefficients.Estimate(2)*xlim_num(2)],'g-.');
legend('Data','1:1','Linear Regression','Location','Best')
title(['m = ' num2str(lm_num.Coefficients.Estimate(2)) '. r^2 = ' ...
    num2str(lm_num.Rsquared.Adjusted) '. p = ' ...
    num2str(lm_num.Coefficients.pValue(2))]);

subplot(1,2,2)
plot(length_activations(:,1),length_activations(:,2),'b.')
xlabel('Length Activations Session 1'); 
ylabel('Length Activations Session 2');
xlim_len = get(gca,'XLim'); ylim_len = get(gca,'YLim');
len_max = max(xlim_len(2), ylim_len(2));
hold on
plot([0 len_max], [0 len_max],'r') % 1:1 line
plot([0 xlim_len(2)], [lm_len.Coefficients.Estimate(1) 
    lm_len.Coefficients.Estimate(1) + ...
    lm_len.Coefficients.Estimate(2)*xlim_len(2)],'g-.');
legend('Data','1:1','Linear Regression','Location','Best')
title(['m = ' num2str(lm_len.Coefficients.Estimate(2)) '. r^2 = ' ...
    num2str(lm_len.Rsquared.Adjusted) '. p = ' ...
    num2str(lm_len.Coefficients.pValue(2))]);

% Plot 1:1 and linear model lines

keyboard



end

