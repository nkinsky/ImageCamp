clear all
close all

% file1 = im2double(imread('I:\GCamp Mice\G30\image registration debugging\9_23_2014 - sesh 1\ICmovie_min_proj.tif'));
% file2 = im2double(imread('I:\GCamp Mice\G30\image registration debugging\9_23_2014 - sesh 2\ICmovie_min_proj.tif'));

% file1 = 'I:\GCamp Mice\G27\image registration debugging\7_11_2014\homecage\ICmovie_min_proj.tif';
% file2 = 'I:\GCamp Mice\G27\image registration debugging\7_11_2014\rectangle\ICmovie_min_proj.tif';

% file1 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangle\ICmovie_min_proj.tif';
% file2 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangular plastic tub\ICmovie_min_proj.tif';

file1 = 'I:\GCamp Mice\G30\9_23_2014\1 - triangle track 201B\ICmovie_min_proj.tif';
file2 = 'I:\GCamp Mice\G30\10_7_2014\1 - triangle track 201B\IC700-Objects\Obj_1\ICmovie_min_proj.tif';

% file1_trace = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangle\SignalTrace.mat';
% file2_trace = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangular plastic tub\SignalTrace.mat';
% reginfo_file = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangle\RegistrationInfo.mat';

file1_trace = 'I:\GCamp Mice\G30\9_23_2014\1 - triangle track 201B\FinalTraces.mat';
file2_trace = 'I:\GCamp Mice\G30\10_7_2014\1 - triangle track 201B\IC700-Objects\Obj_1\FinalTraces.mat';


image1 = im2double(imread(file1));
image2 = im2double(imread(file2));

clip_value = 4113;

image1_gray = uint16(image1);
image2_gray = uint16(image2);

image1c_gray = imcomplement(image1_gray);
image2c_gray = imcomplement(image2_gray);

image1_adj = imadjust(image1_gray);
image2_adj = imadjust(image2_gray);

figure
subplot(2,2,1)
imagesc(image1_gray); colormap(gray)
subplot(2,2,2)
imagesc(image2_gray); colormap(gray)
subplot(2,2,3)
imagesc(image1_adj); colormap(gray)
subplot(2,2,4)
imagesc(image2_adj); colormap(gray)

if size(image1) == size(image2)
figure
subplot(2,2,1)
imagesc(abs(image1_gray-image2_gray)); colormap(gray); colorbar
subplot(2,2,2)
imagesc(abs(image1_adj-image2_adj)); colormap(gray); colorbar
subplot(2,2,3)
hist(double(abs(image1_gray(:)-image2_gray(:))),50);
subplot(2,2,4)
hist(double(abs(image1_adj(:)-image2_adj(:))),50);
else
end

bg1 = imopen(image1_gray,strel('disk',15));
image1_gray = image1_gray - bg1;
image1_gray = imadjust(image1_gray);
level = graythresh(image1_gray);
image1_bw = im2bw(image1_gray,level);
image1_bw = bwareaopen(image1_bw,1000,8);

cc1 = bwconncomp(image1_bw,8);
labeled1 = labelmatrix(cc1);
rgb_label1 = label2rgb(labeled1,@spring,'c','shuffle');

bg1c = imopen(image1c_gray,strel('disk',15));
image1c_gray = image1c_gray - bg1c;
image1c_gray = imadjust(image1c_gray);
level = graythresh(image1c_gray);
image1c_bw = im2bw(image1c_gray,level);
image1c_bw = bwareaopen(image1c_bw,1000,8);


bg2 = imopen(image2_gray,strel('disk',15));
image2_gray = image2_gray - bg2;
image2_gray = imadjust(image2_gray);
level = graythresh(image2_gray);
image2_bw = im2bw(image2_gray,level);
image2_bw = bwareaopen(image2_bw,1000,8);

bg2c = imopen(image2c_gray,strel('disk',15));
image2c_gray = image2c_gray - bg2c;
image2c_gray = imadjust(image2c_gray);
level = graythresh(image2c_gray);
image2c_bw = im2bw(image2c_gray,level);
image2c_bw = bwareaopen(image2c_bw,1000,8);

figure
subplot(2,2,1); imshow(image1_bw);
subplot(2,2,2); imshow(image1c_bw);
subplot(2,2,3); imshow(image2_bw);
subplot(2,2,4); imshow(image2c_bw);

figure
subplot(2,2,1)
imagesc(image1); colormap(gray)
subplot(2,2,2)
imagesc(image2); colormap(gray)
subplot(2,2,3); imagesc(image1_bw);
subplot(2,2,4); imagesc(image2_bw);

%% MAGIC VARIABLES
configname = 'monomodal'; % For images taken with similar contrasts, e.g. from the same device, same gain, etc.
regtype = 'similarity'; % Similarity = Translation, Rotation, Scale

% Adjust registration algorithm values:
% MONOMODAL
mono_max_iterations = 1000; % optimizer.MaximumIterations = 100 default
mono_max_step = 1e-3;% optimizer.MaximumStepLength = 0.0625 default
mono_min_step = 1e-5; % optimizer.MinimumStepLength = 1e-5 default
mono_relax = 0.5; %optimizer.RelaxationFactor = 0.5 default
mono_gradient_tol = 1e-6; % optimizer.GradientMagnitudeTolerance = 1e-4 default
% MULTIMODAL
multi_max_iterations = 10000; % optimizer.MaximumIterations = 100 default
multi_growth = 1.05; % optimizer.GrowthFactor = 1.05 default
multi_epsilon = 1.05e-6; % optimizer.Epsilon = 1.05e-6 default
multi_init_rad = 6.25e-4; % optimizer.InitialRadius = 6.25e-3 default

[optimizer, metric] = imregconfig(configname);
if strcmp(configname,'monomodal') % Adjust defaults if desired.
    optimizer.MaximumIterations = mono_max_iterations;
    optimizer.MaximumStepLength = mono_max_step;
    optimizer.MinimumStepLength = mono_min_step;
    optimizer.RelaxationFactor = mono_relax;
    optimizer.GradientMagnitudeTolerance = mono_gradient_tol;
    
elseif strcmp(configname,'multimodal')
    optimizer.MaximumIterations = multi_max_iterations;
    optimizer.GrowthFactor = multi_growth;
    optimizer.Epsilon = multi_epsilon;
    optimizer.InitialRadius = multi_init_rad;
    
end

%% COMPARE IMAGE REG

% Reginfo = importdata(reginfo_file);

tform_current = imregtform(image2, image1, regtype, optimizer, metric);
moving_reg_current = imwarp(image2,tform_current,'OutputView',imref2d(size(image1)));

tform_new = imregtform(double(image2_bw), double(image1_bw), regtype, optimizer, metric);
moving_reg_new = imwarp(image2,tform_new,'OutputView',imref2d(size(image1)));
moving_reg_bw = imwarp(image2_bw,tform_new,'OutputView',imref2d(size(image1)));

tformc_new = imregtform(double(image2c_bw), double(image1c_bw), regtype, optimizer, metric);
movingc_reg_new = imwarp(image2,tformc_new,'OutputView',imref2d(size(image1)));


figure
subplot(2,2,1)
imagesc(abs(image1-moving_reg_current)); colormap(gray); colorbar
subplot(2,2,2)
imagesc(abs(image1-moving_reg_new)); colormap(gray); colorbar
subplot(2,2,3)
imagesc(abs(image1-movingc_reg_new)); colormap(gray); colorbar

figure
subplot(2,2,1)
imagesc(image1); colormap(gray)
subplot(2,2,2)
imagesc(moving_reg_new); colormap(gray)
subplot(2,2,3)
imagesc(abs(image1-moving_reg_new)); colormap(gray);
subplot(2,2,4)
imagesc(abs(image1_bw-moving_reg_bw)); colormap(gray);


%% Create AllIC masks and compare

trace1 = importdata(file1_trace);
trace2 = importdata(file2_trace);

AllIC1 = create_AllICmask2(trace1.IC,trace1.ICnz);
AllIC2 = create_AllICmask2(trace2.IC,trace2.ICnz);

AllIC2_reg_new = imwarp(AllIC2,tform_new,'OutputView',imref2d(size(AllIC1)));
% AllIC2_reg_manual = imwarp(AllIC2,Reginfo.tform_manual,'OutputView',imref2d(size(AllIC1)));
AllIC2_regc_new = imwarp(AllIC2,tformc_new,'OutputView',imref2d(size(AllIC1)));

figure
subplot(2,2,1)
imagesc(AllIC1 + 2*AllIC2_reg_new); colorbar
subplot(2,2,2)
% imagesc(AllIC1 + 2*AllIC2_reg_manual); colorbar
subplot(2,2,3)
imagesc(AllIC1 + 2*AllIC2_regc_new); colorbar


