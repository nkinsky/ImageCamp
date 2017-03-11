function [] = twoenv_conn_plots( sessions)
% twoenv_conn_plots( session,... )
%   Scrolls through plots from each connected session. sessions variable
%   must contain info for 1st session then 2nd session in connected
%   recording.

% First need to go through each mouse and run Placefields_half using
% specific indices as the halfway point

% Then, just go through and plot each!

%% Load up relevant files
disp('Loading files')
for j = 1:2
   dirstr = ChangeDirectory_NK(sessions(j),0);
   PF_temp = importdata(fullfile(dirstr,'Placefields_half.mat'));
   pos_data{j} = load(fullfile(dirstr,'Pos_align_rot0.mat'),'x_adj_cm','y_adj_cm','PSAbool');
   for k = 1:2
      TMap{k,j} = PF_temp{k}.TMap_gauss;
      pval{k,j} = PF_temp{k}.pval;
   end
   
end

num_PFs = length(TMap{1,1});

clear PF_temp

%% Scroll through and plot
figure
cm = colormap('jet');
j = 1;
stay_in = true;
while stay_in
    for k = 1:2
        for ll = 1:2
            subplot(2,4,4*(k-1)+ll)
            imagesc_nan(rot90(TMap{k,ll}{j},1),cm,[1 1 1]);
            title(['Neuron ' num2str(j) ' - Half # ' num2str(k)])
            xlabel(['p = ' num2str(pval{k,ll}(j))])
        end
    end
    
%     subplot(3,2,5:6)
%     active = pos_data{1}.PSAbool(j,:);
%     plot(pos_data{1}.x_adj_cm, pos_data{1}.y_adj_cm, 'k',...
%         pos_data{1}.x_adj_cm(active), pos_data{1}.y_adj_cm(active),'r*');
%     axis tight
%     axis off
    
% This is a hack - need to plot actual spiking data from Placefields_half
    num_frames = size(pos_data{1}.PSAbool,2);
    half{1} = false(1,num_frames); half{2} = false(1,num_frames);
    half{1}(1:round(num_frames/2)) = true;
    half{2}((round(num_frames/2))+1:end) = true;
    %%
    for k = 1:2
        subplot(2,4,4*(k-1)+[3 4])
        active = pos_data{1}.PSAbool(j,:) & half{k};
        plot(pos_data{1}.x_adj_cm, pos_data{1}.y_adj_cm, 'k',...
            pos_data{1}.x_adj_cm(active), pos_data{1}.y_adj_cm(active),'r*');
        axis tight
        axis off
    end
    [ j, stay_in] = LR_cycle( j,[1 num_PFs]);
    %%
end

