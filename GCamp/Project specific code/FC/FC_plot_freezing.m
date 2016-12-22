function [ ] = FC_plot_freezing( MD_ctrl_env, MD_shock_env, speed_thresh, h)
% FC_plot_freezing( MD_ctrl_env, MD_shock_env, speed_thresh, h)
%   Plots a bar graph for % time freezing with speed threshold specified
%   for control and shock environment.  If either env is omitted, it plots
%   it only for the specified one. Default speed thresh is 1 cm/s

if nargin == 3
    figure; h = gca;
end

Pix2Cm = 0.15; % Default for room 201b

sesh{1} = MD_ctrl_env;
sesh{2} = MD_shock_env;

plot_label = {'Ctrl' 'Shock Env'};
freeze_ratio = nan(1,2);
for j = 1:2
    if isempty(sesh{j})
        continue
    else
        freeze_ratio(j) = calc_freezing(sesh{j},Pix2Cm, speed_thresh);
        if isnan(freeze_ratio(j))
            plot_label{j} = [plot_label{j} ' - NaN'];
        end
        
    end
end

axes(h)
bar([1,2], freeze_ratio);
ylim([0 1])
xlim([0 3])
set(gca,'XTickLabel',plot_label);
ylabel('Freezing Ratio');
xlabel(['Speed Threshold = ' num2str(speed_thresh) ' cm/s'])

end

function [freeze_ratio,freeze_log] = calc_freezing(sesh_use, Pix2Cm, speed_thresh)
%% Calculate Speed
SR = 20;
dirstr = ChangeDirectory(sesh_use.Animal,sesh_use.Date,sesh_use.Session,0);
try
    load(fullfile(dirstr,'Pos.mat'),'xpos_interp','ypos_interp')
    x = xpos_interp; y = ypos_interp;
    x = x.*Pix2Cm;
    y = y.*Pix2Cm;
    dx = diff(x);
    dy = diff(y);
    speed = hypot(dx,dy)*SR;
    smspeed = convtrim(speed,ones(1,2*SR))./(2*SR); % Attempt to smooth a bit
    freeze_log = smspeed < speed_thresh;
    freeze_ratio = sum(freeze_log)/length(freeze_log);
catch
    freeze_ratio = nan;
end


end

