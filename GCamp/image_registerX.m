function [] = image_registerX(base_file, register_file)
% image_registerX(base_file, register_file)
% Image Registration Function - THIS FUNCTION ONLY REGISTERS ONE IMAGE TO ANOTHER
% AND DOES NOT DEAL WITH ANY INDIVIDUAL CELLS.
% this fuction allows you to register a given
% recording session (the registered session) to a previous sesison ( the
% base session) to track neuronal activity from session to session.  It
% also outputs a combined set of ICs so that you can register a given
% session to multiple previous sessions.  Note that you must enter an
% approximate rotation if you used a different focuse for the registered
% file, or else the in-house MATLAB image registration funcRtions won't
% work...
%
% INPUT VARIABLES
% base_file:    .tif file for the minimimum projection of the motion
%               corrected ICmovie for the base image.  Needs to be in the
%               same directory as SignalTrace.mat (or CellRegisterBase.mat
%               for multiple sessions) to work
% register_file:.tif file (min projection of the motion corrected ICmovie)
%               for the image/recording you wish to register to the base
%               image. Needs to be in the same directory as SignalTrace.mat
%               to work.  Enter the same file as the base_file if you want
%               to do a base mapping.
% cell_merge:   How you deal with cell overlap for future registrations:
%               'base' = keep the base IC (recommended)
%               'merge' = merge the base and registered file ICs (not
%               recommended - cell will eventually grow into monster cell!)
%               'reg' = overwrite base IC with registered file IC (ok, but
%               you need to manually verify that cell IC doesn't drift over
%               time!)
%
% OUTPUTS
% cell_map:     cell array with each row corresponding to a given neuron,
%               and each column corresponding to a recording session.  The value
%               corresponds to the GoodICf number from that session for that neuron.
% cell_map_header: contains info for each column in cell_map
% GoocICf_comb: combines ICs from the base file and the registered file.
%               Use this file as the base file for future registrations of
%               a file to multiple previous sessions.
% RegistrationInfo : saves the location of the base file, the registered
%                file, the transform applied, and the Base and registered 
%                AllIC masks

% To do:

% - Try this out for images that are significantly different, e.g. rotated
% 180 degrees...
% - Automatically fill in expected neuron for base mapping

% - Need way to cycle through different cells (only one at a time) where
% there is multiple overlap (e.g. 57% with one cell and 63% with another
% cell) - e.g. for the cell immediately after that which gets mapped to
% cell 88 (G30, base session 9/23 1st session, registered session 9/24 1st
% session)
% - Need to number cells in reg image in case you need to make
% corrections later on 
% - Automatically plot blow up of area?
% - Error checking - Need check to make sure that, in cases where there are lots of cells that
% I don't accidentally assign two different cells to the same cell and thus
% overwrite a previous mapping.
% - Error checking - don't let person advance if they don't hit one of the
% possible IC numbers or enter! Also, make them hit the same thing twice in
% a row to advance...
% - Error checking - check if largest percentage is not selected
% - **** Add try-catch statement to prevent running all the time-intensive imreg
% functions if we already have a good image reg and just want to run
% through the mapping portion - maybe search for 'register_file' in RegInfo
% and if it is already there, skip all the registration stuff? (DONE)
% - Make imagesc ALWAYS use the same scale when stepping through... (DONE)
% - Need to think through how to re-do a session more carefully.  It only
% really works if it is the last session run, otherwise previously mapped
% cells will get lost or indexed in the wrong place in the cell_map
% variable...(DONE)
% - **** Need section to check for double counted cell mappings, and then
% resolve them.  This will be complicated but necessary.  If this happens,
% we should either a)only keep the chosen cell mapping, and toss the other
% cell, or b) toss all of them because they are a cluster we can't resolve.
% (DONE kind of)
% *** - No error checking for cells with <50% overlap - only need to hit
% enter once!!!
% - AUTOMATIC MAPPING - a)> 65%? (unless more than 2...) b)< 35% 
% - Ability to discard a cell!!! Both in base mapping and later mapping?
% - IF more than one cell gets assigned to previous cell, only use the
% higher percentage overlap and discard the other?
% - Clean everything up!  Too many lines, too many places to bomb out!

close all;
 
%% User inputs - if set the same the function should run without any user input during the mapping portion


%% MAGIC VARIABLES
configname = 'multimodal'; % For images taken with similar contrasts, e.g. from the same device, same gain, etc.
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

FigNum = 1; % Start off figures at this number

%% Step 1: Select images to compare and import the images

if nargin == 0
[base_filename, base_path, filterindexbase] = uigetfile('*.tif',...
    'Pick the base image file: ');
base_file = [base_path base_filename];

[reg_filename, reg_path, filterindexbase] = uigetfile('*.tif',...
    'Pick the image file to register with the base file: ',[base_path base_filename]);
register_file = [reg_path reg_filename];
cell_merge = 'base';
elseif nargin == 1
    error('Please input both a base image and image to register to base file')
elseif nargin == 2
   
    base_filename = base_file(max(regexp(base_file,'\','end'))+1:end);
    base_path = base_file(1:max(regexp(base_file,'\','end')));
    reg_filename = register_file(max(regexp(register_file,'\','end'))+1:end);
    reg_path = register_file(1:max(regexp(register_file,'\','end')));
   
end

%% Step 2a: Get Images and pre-process - Note that this step is vital as it helps
% correct for differences in overall illumination or contrast between
% sessions.

% Magic numbers
disk_size = 15;
pixel_thresh = 100;

base_image_gray = uint16(imread(base_file));
base_image_untouch = base_image_gray;
reg_image_gray = uint16(imread(register_file));
reg_image_untouch = reg_image_gray;

bg_base = imopen(base_image_gray,strel('disk',disk_size));
base_image_gray = base_image_gray - bg_base;
base_image_gray = imadjust(base_image_gray);
level = graythresh(base_image_gray);
base_image_bw = im2bw(base_image_gray,level);
base_image_bw = bwareaopen(base_image_bw,pixel_thresh,8);
base_image = double(base_image_bw);

bg_reg = imopen(reg_image_gray,strel('disk',disk_size));
reg_image_gray = reg_image_gray - bg_reg;
reg_image_gray = imadjust(reg_image_gray);
level = graythresh(reg_image_gray);
reg_image_bw = im2bw(reg_image_gray,level);
reg_image_bw = bwareaopen(reg_image_bw,pixel_thresh,8);
reg_image = double(reg_image_bw);


%% Step 2b: Run Registration Functions, get transform

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

% Run registration
disp('Running Registration...');
tform = imregtform(reg_image, base_image, regtype, optimizer, metric);

% Create no registration variable
tform_noreg = tform;
tform_noreg.T = eye(3);

% Apply registration to 2nd session
moving_reg = imwarp(reg_image,tform,'OutputView',imref2d(size(base_image)),...
    'InterpolationMethod','nearest');
moving_reg_gray = imwarp(reg_image_gray,tform,'OutputView',...
    imref2d(size(base_image_gray)),'InterpolationMethod','nearest');

% Apply NO registrtion to 2nd session for comparison
moving_noreg = imwarp(reg_image,tform_noreg,'OutputView',imref2d(size(base_image)),...
    'InterpolationMethod','nearest');
moving_gray_noreg = imwarp(reg_image_gray,tform_noreg,'OutputView',...
    imref2d(size(base_image_gray)),'InterpolationMethod','nearest');

% Plot it out for comparison
h_base_landmark = subplot(2,2,1);
imagesc(base_image); colormap(gray); colorbar
title('Base Image');
h_reg_landmark = subplot(2,2,2);
imagesc(reg_image); colormap(gray); colorbar
title('Image to Register');
subplot(2,2,3)
imagesc(moving_reg); colormap(gray); colorbar
title('Registered Image')
subplot(2,2,4)
imagesc(abs(moving_reg - base_image)); colormap(gray); colorbar
title('Registered Image - Base Image')

figure
subplot(1,2,1)
imagesc_gray(base_image_gray - moving_gray_noreg);
title('Base Image - Unregistered 2nd image');
subplot(1,2,2)
imagesc_gray(base_image_gray - moving_reg_gray);
title('Base Image - Registered Image');


% FigNum = FigNum + 1;

%% Step 3: Take Good ICs from registered image and overlay them onto base image


%% Step 3A: Give option to adjust manually if this doesn't work...
disp('Registration Stats:')
disp(['X translation = ' num2str(tform.T(3,1)) ' pixels.'])
disp(['Y translation = ' num2str(tform.T(3,2)) ' pixels.'])
disp(['Rotation = ' num2str(mean([asind(tform.T(1,2)) acosd(tform.T(1,1))])) ' degrees.'])

manual_flag = input('Do you wish to manually adjust this registration? (y/n): ','s');
if strcmpi(manual_flag,'n')
    use_manual_adjust = 0;
end
while strcmpi(manual_flag,'y')
    manual_type = input('Do you wish to adjust by landmarks or none? (l/n): ','s');
    while ~(strcmpi(manual_type,'l') || strcmpi(manual_type,'n'))
        manual_type = input('Do you wish to adjust by landmarks or my cell masks or none? (l/n): ','s');
    end
    T_manual = [];
    while isempty(T_manual)
        if strcmpi(manual_type,'l')
            reg_type = 'landmark';
            figure(1)
            T_manual = manual_reg(h_base_landmark, h_reg_landmark, reg_type);
        elseif strcmpi(manual_type,'n')
            T_manual = eye(3);
        end
    end
    
    tform_manual = tform;
    tform_manual.T = T_manual;
    moving_reg_manual = imwarp(reg_image,tform_manual,'OutputView',imref2d(size(base_image)),'InterpolationMethod','nearest');
   
    FigNum = FigNum + 1;
    figure(FigNum)
    imagesc(abs(moving_reg_manual - base_image)); colormap(gray); colorbar
    title('Registered Image - Base Image after manual adjust')
    
    
    manual_flag = input('Do you wish to manually adjust again? (y/n)', 's');
    use_manual_adjust = 1;

    
end

% Get index to pixels that are zeroed out as a result of registration
moving_reg_untouch = imwarp(reg_image_untouch,tform,'OutputView',...
    imref2d(size(base_image_untouch)),'InterpolationMethod','nearest');
exclude_pixels = moving_reg_untouch(:) == 0;

regstats.base_2nd_diff_noreg = sum(abs(base_image_gray(:) - moving_gray_noreg(:)));
regstats.base_2nd_diff_reg = sum(abs(base_image_gray(:) - moving_reg_gray(:)));
regstats.base_2nd_bw_diff_noreg = sum(abs(base_image(:) - moving_noreg(:)));
regstats.base_2nd_bw_diff_reg = sum(abs(base_image(:) - moving_reg(:)));


% Determine if there are previously run versions of this registration
if exist([base_path 'RegistrationInfoX.mat'],'file') == 2
    load([base_path 'RegistrationInfoX.mat']);
        size_info = size(RegistrationInfoX,2)+1;
else
    size_info = 1;
end
FigNum = FigNum + 1;

% Save info into RegistrationInfo data structure.
RegistrationInfoX(size_info).base_file = base_file;
RegistrationInfoX(size_info).register_file = register_file;
RegistrationInfoX(size_info).tform = tform;
RegistrationInfoX(size_info).exclude_pixels = exclude_pixels;
RegistrationInfoX(size_info).regstats = regstats;

if exist('T_manual','var')
    RegistrationInfoX(size_info).tform_manual = tform_manual;
    regstats.base_2nd_bw_diff_reg_manual = sum(abs(base_image(:) - moving_reg_manual(:)));
end

save ([ base_path 'RegistrationInfoX.mat'],'RegistrationInfoX');

keyboard;
