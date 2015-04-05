%% Efficient subpixel image registration by cross-correlation. 
% Registers two images (2-D rigid translation) within a  fraction 
% of a pixel specified by the user. Instead of computing a zero-padded FFT 
% (fast Fourier transform), this code uses selective upsampling by a
% matrix-multiply DFT (discrete FT) to dramatically reduce computation time and memory
% without sacrificing accuracy. With this procedure all the image points are used to
% compute the upsampled cross-correlation in a very small neighborhood around its peak. This 
% algorithm is referred to as the single-step DFT algorithm in [1].
%
% [1] Manuel Guizar-Sicairos, Samuel T. Thurman, and James R. Fienup, 
% "Efficient subpixel image registration algorithms," Opt. Lett. 33, 
% 156-158 (2008).

%% Syntax
% The code receives the FFT of the reference and the shifted images, and an
% (integer) upsampling factor. The code expects FFTs with DC in (1,1) so do not use
% fftshift.
%
%    output = dftregistration(fft2(f),fft2(g),usfac);
%
% The images are registered to within 1/usfac of a pixel.
%
% output(1) is the normalized root-mean-squared error (NRMSE) [1] between f and
% g. 
%
% output(2) is the global phase difference between the two images (should be
% zero if images are real-valued and non-negative).
%
% output(3) and output(4) are the row and column shifts between f and g respectively. 
%
%    [output Greg] = dftregistration(fft2(f),fft2(g),usfac);
%
% Greg is an optional output, it returns the Fourier transform of the registered version of g,
% where the global phase difference [output(2)] is also compensated.


%% Obtain a reference and shifted images
% To illustrate the use of the algorithm, lets obtain a reference and a
% shifted image. First we read the reference image f(x,y)
f1 = im2double(imread('C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_20\6_30_2014\square\ICmovie_minprojection_square.tif'));
% im2double(imread('C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_19\5_16_2014\square\G19_2014MAY16_square_min.tif'));
f2 = im2double(imread('C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_20\6_30_2014\triangle\ICmovie_min_triangle.tif'));

% %% Get images the same size - NOT NECESSARY
% f1_size = size(f1);
% f2_size = size(f2);
% size_use = [min([f1_size(1) f2_size(1)]) min([f1_size(2) f2_size(2)])];
% 
% % f1 adjust
% % if f1_size(1) > size_use(1)
% %     f1_mid = floor(f1_size(1)/2);
% %     f1_temp = f1(f1_mid-size_use(1)/2...
% % end 
% 
% f1_temp = f1(5:464,:);
% f2_temp = f2(:,22:492);
% f3 = f1_temp/(max(max(f1_temp))); % Normalize?
% f4 = f2_temp/(max(max(f2_temp))); % Normalize?

%% Test imreg function in MATLAB
fixed = f1; moving = f2;
[optimizer, metric] = imregconfig('monomodal');
[moving_reg r_reg] = imregister(moving, fixed, 'similarity', optimizer, metric);
tform = imregtform(moving, fixed, 'similarity', optimizer, metric);

figure(41)
% subplot(1,3,1); imshowpair(fixed,moving);
subplot(2,2,1); 
imagesc(fixed); colormap(gray); colorbar;
subplot(2,2,2);
imagesc(moving); colormap(gray); colorbar;
subplot(2,2,3)
imagesc(moving_reg); colormap(gray); colorbar;
subplot(2,2,4)
imagesc(fixed - moving_reg); colormap(gray); colorbar;




