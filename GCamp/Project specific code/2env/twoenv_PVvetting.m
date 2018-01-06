% New v old PV calculation vetting

%% Load variables

ChangeDirectory_NK(G30_square(1));
load('2env_PV_1shuffles-2017-12-03.mat', 'Mouse')
Mouseold = Mouse;
load('2env_PVsilent_cm4_local0-1shuffles-2017-01-12-G30only.mat')
Mousenew = Mouse;
load('2env_PVsilent_cm4_local0-1shuffles-2018-01-03.mat');
Mousenew2 = Mouse;

%%
fix_caterr = true; % fixes problem in PV concatenation - temporary
pval_thresh = 0.05;
ntrans_thresh = 5;

mouse_use = 1;
sesh_comp = [1 7]; % sessions to compare

% Get cells active in both sessions in old PV
PVold = Mouseold(mouse_use).PV.square(sesh_comp,:,:,:);
PVoldmean = shiftdim(squeeze(nanmean(nanmean(PVold,2),3)),1);
active_old_bool = all(PVoldmean,2) & all(~isnan(PVoldmean),2);
corrs_old = corr3d(PVold);

% Ditto for new PV 
if fix_caterr
   PVtemp1 = Mousenew(mouse_use).PVcorrs.square.PV{sesh_comp(1), ...
       sesh_comp(2)}(:,1:9,:);
   PVtemp2 = Mousenew(mouse_use).PVcorrs.square.PV{sesh_comp(1), ...
       sesh_comp(2)}(:,10:18,:);
   PVnew = shiftdim(cat(4,PVtemp1,PVtemp2),3);
else
    PVnew = Mousenew(mouse_use).PVcorrs.square.PV{sesh_comp(1), ...
        sesh_comp(2)};
end

PVnewmean = shiftdim(squeeze(nanmean(nanmean(PVnew,2),3)),1);
active_new_bool = all(PVnewmean,2) & all(~isnan(PVnewmean),2);
corrs_new = corr3d(PVnew);

%%% NRK note is that the difference between the two was due to a bug in
%%% filtering cells. Be careful and ALWAYS use parentheses to group terms
%%% when using booleans in the future!!!