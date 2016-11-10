%DNMP PV analysis script

%% Create arrays of frames to include for each type of trial
load('ICout_hack.mat','FT');
load('Pos.mat');

num_frames = length(xpos_interp);

half1 = false(1,num_frames); half1(1:floor(num_frames/2)) = true;
half2 = false(1,num_frames); half2(floor(num_frames/2)+1:end) = true;

in_center_log = false(1,num_frames);
load('in_zones.mat','in_center');
in_center_ind = find(in_center) + FToffset - 2;
in_center_log(in_center_ind) = true;

free_l_include1_log = false(1,num_frames); free_l_include2_log = false(1,num_frames);
forced_l_include1_log = false(1,num_frames); forced_l_include2_log = false(1,num_frames);
forced_l_include_log = exc_to_inc(forced_l_exclude,num_frames);
free_l_include_log = exc_to_inc(free_l_exclude,num_frames);

forced_l_include1_log = half1 & forced_l_include_log;
forced_l_include2_log = half2 & forced_l_include_log;
free_l_include1_log = half1 & free_l_include_log;
free_l_include2_log = half2 & free_l_include_log;

load('good_cells.mat','good');
FT_use = FT(logical(good),:);


%% Compare forced v free by halves of session for everywhere

[ ~, PV_l_forced1 ] = DNMP_PVrough( FT_use, forced_l_include1_log , 2);
[ ~, PV_l_free1 ] = DNMP_PVrough( FT_use, free_l_include1_log , 2);
figure(20)
subplot(2,2,1)
plot(PV_l_forced1, PV_l_free1,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('1st Half Left Forced'); 
ylabel('1st Half Left Free')

[ ~, PV_l_forced2 ] = DNMP_PVrough( FT_use, forced_l_include2_log , 2);
[ ~, PV_l_free2 ] = DNMP_PVrough( FT_use, free_l_include2_log , 2);
subplot(2,2,2)
plot(PV_l_forced2, PV_l_free2,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('2nd Half Left Forced'); 
ylabel('2nd Half Left Free');

subplot(2,2,3)
plot(PV_l_forced1, PV_l_forced2,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('1st Half Left Forced'); 
ylabel('2nd Half Left Forced');

subplot(2,2,4)
plot(PV_l_free1, PV_l_free2,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('1st Half Left Free'); 
ylabel('2nd Half Left Free');

%% Compare 1st half free/forced to 2nd half free/forced for center only
[ ~, PV_l_forced1_center ] = DNMP_PVrough( FT_use, forced_l_include1_log & in_center_log , 2);
[ ~, PV_l_free1_center ] = DNMP_PVrough( FT_use, free_l_include1_log & in_center_log, 2);
figure(21)
subplot(2,2,1)
plot(PV_l_forced1_center, PV_l_free1_center,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('1st Half Left Forced - Center'); 
ylabel('1st Half Left Free - Center')

[ ~, PV_l_forced2_center ] = DNMP_PVrough( FT_use, forced_l_include2_log & in_center_log, 2);
[ ~, PV_l_free2_center ] = DNMP_PVrough( FT_use, free_l_include2_log & in_center_log, 2);
subplot(2,2,2)
plot(PV_l_forced2_center, PV_l_free2_center,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('2nd Half Left Forced - Center'); 
ylabel('2nd Half Left Free - Center');

subplot(2,2,3)
plot(PV_l_forced1_center, PV_l_forced2_center,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('1st Half Left Forced - Center'); 
ylabel('2nd Half Left Forced - Center');

subplot(2,2,4)
plot(PV_l_free1_center, PV_l_free2_center,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('1st Half Left Free - Center'); 
ylabel('2nd Half Left Free - Center');

%% Compare free L v forced L
[ ~, PV_l_forced_center ] = DNMP_PVrough( FT_use, forced_l_include & in_center_log , 2);
[ ~, PV_l_free_center ] = DNMP_PVrough( FT_use, free_l_include & in_center_log, 2);
figure(22)
subplot(2,2,1);
plot(PV_l_forced_center, PV_l_free_center,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('Left Forced - Center'); 

[ ~, PV_l_forced ] = DNMP_PVrough( FT_use, forced_l_include , 2);
[ ~, PV_l_free ] = DNMP_PVrough( FT_use, free_l_include, 2);
figure(22)
subplot(2,2,2);
plot(PV_l_forced, PV_l_free,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('Left Forced - Everywhere'); 
ylabel('Left Free - Everywhere')

[ ~, PV_forced ] = DNMP_PVrough( FT_use, forced_exclude , 1);
[ ~, PV_free ] = DNMP_PVrough( FT_use, free_exclude, 1);
subplot(2,2,3);
plot(PV_forced, PV_free,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('Forced - Everywhere'); 
ylabel('Free - Everywhere')

[ ~, PV_forced_center ] = DNMP_PVrough( FT_use, exc_to_inc(forced_exclude,num_frames) & in_center_log , 2);
[ ~, PV_free_center ] = DNMP_PVrough( FT_use, exc_to_inc(free_exclude,num_frames) & in_center_log, 2);
subplot(2,2,4);
plot(PV_forced_center, PV_free_center,'*')
title('Z-scored Neuron Transient Probability'); 
xlabel('Forced - Center'); 
ylabel('Free - Center')

%% Plot odd v even free v forced
[ forced_odd_include, forced_even_include, ~, ~] = get_odd_even_epochs( exc_to_inc(forced_exclude, size(FT_use,2)));
[ ~, PV_forced_odd ] = DNMP_PVrough( FT_use, forced_odd_include , 2);
[ ~, PV_forced_even ] = DNMP_PVrough( FT_use, forced_even_include, 2);
figure(23)
subplot(2,2,1)
plot(PV_forced_odd,PV_forced_even,'*')
title('Forced Even v Forced Odd epochs')

[ free_odd_include, free_even_include, ~, ~] = get_odd_even_epochs( exc_to_inc(free_exclude, size(FT_use,2)));
[ ~, PV_free_odd ] = DNMP_PVrough( FT_use, free_odd_include , 2);
[ ~, PV_free_even ] = DNMP_PVrough( FT_use, free_even_include, 2);
figure(23)
subplot(2,2,2)
plot(PV_free_odd,PV_free_even,'*')
title('Free Even v Free Odd epochs')

%% Try another tactice - make TP density maps for each condition
cm = colormap('jet');

figure(32)
load('PlaceMapsv2_forced_left.mat')
PFdens_map_forced_l = make_PFdens_map(TMap_gauss(good_ind),RunOccMap);
subplot(2,2,1)
imagesc_nan(PFdens_map_forced_l,cm,[1 1 1])
title('Transient Density - Left Forced')
colorbar

load('PlaceMapsv2_free_left.mat')
PFdens_map_free_l = make_PFdens_map(TMap_gauss(good_ind),RunOccMap);
subplot(2,2,3)
imagesc_nan(PFdens_map_free_l,cm,[1 1 1])
title('Transient Density - Left Free')
colorbar

load('PlaceMapsv2_forced_right.mat')
PFdens_map_forced_r = make_PFdens_map(TMap_gauss(good_ind),RunOccMap);
subplot(2,2,2)
imagesc_nan(PFdens_map_forced_r,cm,[1 1 1])
title('Transient Density - Right Forced')
colorbar

load('PlaceMapsv2_free_right.mat')
PFdens_map_free_r = make_PFdens_map(TMap_gauss(good_ind),RunOccMap);
subplot(2,2,4)
imagesc_nan(PFdens_map_free_r,cm,[1 1 1])
title('Transient Density - Right Free')
colorbar

figure(33)
subplot(1,2,1)
load('PlaceMapsv2_forced.mat')
PFdens_map_forced = make_PFdens_map(TMap_gauss(good_ind),RunOccMap);
imagesc_nan(PFdens_map_forced,cm,[1 1 1]);
h = colorbar;
set(h,'Limits',[0 0.8])
title('Transient Density - Forced')

load('PlaceMapsv2_free.mat')
subplot(1,2,2)
PFdens_map_free = make_PFdens_map(TMap_gauss(good_ind),RunOccMap);
imagesc_nan(PFdens_map_free,cm,[1 1 1]);
h = colorbar;
set(h,'Limits',[0 0.8])
title('Transient Density - Free')
