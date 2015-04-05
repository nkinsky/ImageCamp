clear
close all

file1 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangle\ICmovie_min_proj.tif';
file2 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangular platic tub\ICmovie_min_proj.tif';

configname = 'monomodal'; % For images taken with similar contrasts, e.g. from the same device, same gain, etc.
regtype = 'similarity'; % Similarity = Translation, Rotation, Skewing

base_image = im2double(imread(base_file));
reg_image = im2double(imread(register_file));

[optimizer, metric] = imregconfig(configname);
[moving_reg r_reg] = imregister(reg_image, base_image, regtype, optimizer, metric);
tform = imregtform(reg_image, base_image, regtype, optimizer, metric);

% rotation = -180; % degrees (+ = CCW, - = CW)
% manual_tform = affine2d([cosd(rotation) -sind(rotation) 0 ; ...
%     sind(rotation) cosd(rotation) 0; 0 0 1]);
% manual_tform45 = affine2d([cosd(45) -sind(45) 0 ; ...
%     sind(45) cosd(45) 0; 0 0 1]);
% manual_tform90 = affine2d([cosd(90) -sind(90) 0 ; ...
%     sind(90) cosd(90) 0; 0 0 1]);
% 
% 
% file1 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_25\7_2_2014\homecage\IC300-Objects\Obj_1\ICmovie_min_proj.tif';
% file2 = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_25\7_3_2014\triangle\IC300-Objects\Obj_1\ICmovie_min_proj.tif';
% image1 = im2double(imread(file1));
% image2 = im2double(imread(file2));
% 
% image2_90 = imwarp(image2,manual_tform90,'OutputView',imref2d(size(image1)));
% image2_45 = imwarp(image2,manual_tform45); %,'OutputView',imref2d(size(image2)));
% image2_rot = imwarp(image2,manual_tform);
% 
% figure(1)
% subplot(1,3,1); imagesc(image2); colormap(gray); title('Base Image')
% subplot(1,3,2); imagesc(image2_45); colormap(gray); title('Rotated 45 degrees')
% subplot(1,3,3); imagesc(image2_90); colormap(gray); title('Rotated 90 degrees')
% 
% figure(2);
% subplot(2,2,1); imagesc(image1); colormap(gray); title('Image 1')
% subplot(2,2,2); imagesc(image2); colormap(gray); title('Image 2')
% subplot(2,2,3); imagesc(image2_rot); colormap(gray); 
% title(['Image 2 rotated ' num2str(rotation) ' degrees'])
% 
% 
% configname = 'monomodal'; % For images taken with similar contrasts, e.g. from the same device, same gain, etc.
% regtype = 'similarity';
% [optimizer, metric] = imregconfig(configname);
% 
% [moving_reg r_reg] = imregister(image2_rot, image1, regtype, optimizer, metric);
% tform = imregtform(image2_rot, image1, regtype, optimizer, metric);
% 
% image2_reg = imwarp(image2_rot,tform,'OutputView',imref2d(size(image1)));
% 
% tform_comb = affine2d(tform.T*manual_tform.T);
% image2_comb_reg = imwarp(image2,tform_comb); %,'OutputView',imref2d(size(image1)));
% 
% tform_comb2 = affine2d(manual_tform.T*tform.T); % This should be correct...
% image2_comb_reg2 = imwarp(image2,tform_comb2); %,'OutputView',imref2d(size(image1)));
% 
% 
% figure(3)
% subplot(2,2,1); imagesc(image1); colormap(gray); title('Image1 (Fixed)')
% subplot(2,2,2); imagesc(image2_rot); colormap(gray); title('Image2 rot')
% subplot(2,2,3); imagesc(image2_reg); colormap(gray); title('Image2 rot imwarp')
% subplot(2,2,4); imagesc(moving_reg); colormap(gray); title('Image2 rot imregister')
% 
% figure(4)
% subplot(1,2,1); imagesc(abs(moving_reg-image2_reg)); colormap(gray)
% subplot(1,2,2); imagesc(abs(image1-image2_reg)); colormap(gray); colorbar
% 
% figure(5)
% subplot(2,2,1); imagesc(image2_reg); colormap(gray);
% subplot(2,2,2); imagesc(image2_comb_reg); colormap(gray);
% subplot(2,2,3); imagesc(image2_comb_reg2); colormap(gray);
% subplot(2,2,4); imagesc(abs(image2_comb_reg - image2_comb_reg2)); colormap(gray)