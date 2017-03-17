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
   PF_temp = importdata(fullfile(dirstr,'Placefields_half.mat'),'Placefields_halves');
   pos_data{j} = load(fullfile(dirstr,'Pos_align_rot0.mat'),'x_adj_cm','y_adj_cm','PSAbool');
   for k = 1:2
      TMap{k,j} = fix_nan_TMap(PF_temp.Placefields_halves{k}.TMap_gauss,...
          PF_temp.Placefields_halves{k}.RunOccMap);
      pval{k,j} = PF_temp.Placefields_halves{k}.pval;
   end
   
end
Placefields_halves = PF_temp.Placefields_halves;

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
            imagesc_nan(rot90(TMap{k,ll}{j},1),'jet');
            title(['Neuron ' num2str(j) ' - Half # ' num2str(k)])
            xlabel(['p = ' num2str(pval{k,ll}(j))])
        end
    end
        
    %%
    for k = 1:2
        subplot(2,4,4*(k-1)+[3 4])

        % Perhaps this is better?
        active = Placefields_halves{k}.PSAbool(j,:);
        plot(Placefields_halves{k}.x,Placefields_halves{k}.y, 'k',...
            Placefields_halves{k}.x(active), Placefields_halves{k}.y(active),'r*')
        axis tight
        axis off
        title([mouse_name_title(sessions(1).Animal) ' - ' mouse_name_title(sessions(1).Date)])
    end
    [ j, stay_in] = LR_cycle( j,[1 num_PFs]);
    %%
end

