% Alternation scratchpad


%% Run Tenaspis
% sesh_use = cat(2,G30_alt(1),G31_alt(1),G45_alt(1),G48_alt(1));
% pause(3600)
alternation_reference;
sesh_use = cat(2,G30_alt(1:end), G31_alt(1:end), G45_alt(1:end), G48_alt(1:end));

success_bool = [];
for j = 1:length(sesh_use)
   try
       [~, sesh_run] = ChangeDirectory_NK(sesh_use(j));
       if exist(fullfile(pwd,'FinalOutput.mat'),'file')
           disp(['Sesiion #' num2str(j) ' - already run'])
           success_bool(j) = true;
       else
           Tenaspis4(sesh_run)
           success_bool(j) = true;
       end
   catch
       success_bool(j) = false;
   end
    
end

%% Check above

success_bool = [];
for j = 1:length(sesh_use)
    try
        [~, sesh_run] = ChangeDirectory_NK(sesh_use(j));
        success_bool(j) = exist(fullfile(pwd,'FinalOutput.mat'),'file');
    catch
        success_bool(j) = false;
    end
    
end

%% Run placefields on a bunch of data

%% Make Example splitting plots for ontogeny diagram
figure; set(gcf,'Position',[34 200 1020 425]);
curve = 0.02*randn(2,50);
for j = 1:5
    if j == 2 || j == 3
        curve(1,20:30) = curve(1,20:30) + 0.2;
    elseif j == 4 || j == 5
        curve(1,20:30) = curve(1,20:30) - 0.2;
    end
%     curve = curve + 0.05*rand(2,50);
    ha = subplot(3,5,j);
    plot_smooth_curve(curve,ha);
end

for j = 1:5
    if j == 3
        curve(1,20:30) = curve(1,20:30) + 0.4;
    elseif j == 4 
        curve(1,20:30) = curve(1,20:30) - 0.4;
    end
%     curve = curve + 0.05*rand(2,50);
    ha = subplot(3,5,5+j);
    plot_smooth_curve(curve,ha);
end

for j = 1:5
    if j == 3
        curve(1,20:30) = curve(1,20:30) + 0.4;
    end
    curve(2,:) = circshift(curve(2,:),10);
%     curve = curve + 0.05*rand(2,50);
    ha = subplot(3,5,10+j);
    plot_smooth_curve(curve,ha);
end