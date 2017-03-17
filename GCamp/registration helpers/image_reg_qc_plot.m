function [ ] = image_reg_qc_plot( Animal, base_date, base_session, reg_date, reg_session, name_append )
% image_reg_qc_plot( Animal, base_date, base_session, reg_date, reg_session, name_append )
%   Produces image registration plots between base_session and reg_session.
%    Uses file:
%    RegistrationInfo-Animal-reg_date-reg_session_name_append.mat.

if nargin < 6
    name_append = '';
end

base_dir = ChangeDirectory(Animal, base_date, base_session, 0);
reg_dir = ChangeDirectory(Animal, reg_date, reg_session, 0);
base_image_file = fullfile(base_dir,'ICmovie_min_proj.tif');
register_image_file = fullfile(reg_dir,'ICmovie_min_proj.tif');

reginfo_file= fullfile(base_dir, ['RegistrationInfo-' Animal '-' ...
    reg_date '-session' num2str(reg_session) name_append '.mat']);
load(reginfo_file);
tform = RegistrationInfoX.tform;

% Magic numbers
disk_size = 15;
pixel_thresh = 100;

base_image_gray = uint16(imread(base_image_file));
reg_image_gray = uint16(imread(register_image_file));

bg_base = imopen(base_image_gray,strel('disk',disk_size)); % remove noise/smooth via morphological opening
base_image_gray = base_image_gray - bg_base; % create image emphasizing contrast between blood vessels and areas of high expression
base_image_gray = imadjust(base_image_gray); % re-adjust pixel intensity values
base_image_bw = imbinarize(base_image_gray); % threshold it
base_image_bw = bwareaopen(base_image_bw,pixel_thresh,8); % eliminate noise / isolated pixels above threshold
base_image = double(base_image_bw);

bg_reg = imopen(reg_image_gray,strel('disk',disk_size));
reg_image_gray = reg_image_gray - bg_reg;
reg_image_gray = imadjust(reg_image_gray);
reg_image_bw = imbinarize(reg_image_gray);
reg_image_bw = bwareaopen(reg_image_bw,pixel_thresh,8);
reg_image = double(reg_image_bw);

tform_noreg = tform;
tform_noreg.T = eye(3);

%% Apply registration to 2nd session
base_ref = imref2d(size(base_image_gray));
moving_reg = imwarp(reg_image,tform,'OutputView',imref2d(size(base_image)),...
    'InterpolationMethod','nearest');

% Plot it out for comparison
figure
ax(1) = subplot(2,2,1);
imagesc(base_image); colormap(gray); colorbar
title(['Base Image: ' mouse_name_title(Animal) '-' mouse_name_title(base_date)...
    ' - Session ' num2str(base_session)]);
ax(2) = subplot(2,2,2);
imagesc(reg_image); colormap(gray); colorbar
title(['Image to Register:' mouse_name_title(Animal) '-' mouse_name_title(reg_date)...
    ' - Session ' num2str(reg_session)]);
ax(3) = subplot(2,2,3);
imagesc(moving_reg); colormap(gray); colorbar
title('Registered Image')
ax(4) = subplot(2,2,4);
imagesc((moving_reg - base_image)); colormap(gray); colorbar
title('Registered Image - Base Image')

linkaxes(ax)

end

