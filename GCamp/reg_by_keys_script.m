%% Script to manually move around images

%% Step 1: LOAD FILES
file1 = 'I:\GCamp Mice\G27\7_11_2014\homecage\ICmovie_min_proj.tif';
file2 = 'I:\GCamp Mice\G27\7_11_2014\rectangle\ICmovie_min_proj.tif';

image1 = im2double(imread(file1));
image2 = im2double(imread(file2));

%% Step 2: Set Registration variables

configname = 'multimodal'; % For images taken with similar contrasts, e.g. from the same device, same gain, etc.
regtype = 'similarity';

%% Step 3: Register image2 to image1

[optimizer, metric] = imregconfig(configname);
tform = imregtform(image1, image2, regtype, optimizer, metric);
image2_reg = imwarp(image2,tform,'OutputView',imref2d(size(image1)));

figure
subplot(1,3,1)
imagesc(image1); colormap(gray)
subplot(1,3,2)
imagesc(image2); colormap(gray)
subplot(1,3,3)
imagesc(image1-image2_reg); colormap(gray)

%% Step 4: Manually adjust with keyboard
% Use "ginput' function to move up, down, left, right, or rotate in
% combination with imregtform.
% up = 30 or 56, down = 31 or 50, left = 28 or 52, right = 29 or 54
% + = 43, - = 45, r = 114, g = 103

figure(2)
imagesc(image1-image2_reg); colormap(gray)

tform2 = tform;

button = 1;
while button ~= 103
    figure(2)
    [x y button] = ginput(1);
    switch button
        case {30 56} % up
            tform2.T(3,2) = tform.T(3,2) + 1;
        case {31 50} % down
            tform2.T(3,2) = tform.T(3,2) - 1;
        case {28 52} % left
            tform2.T(3,1) = tform.T(3,1) - 1;
        case {29 54} % right
            tform2.T(3,1) = tform.T(3,1) + 1;
        case 43
            phi = phi + 1;
            tform2.T(1:2,1:2) = []; % Adjust by increasing phi. See manual_reg script.
        case 114 % redraw
        otherwise
            disp('you are done')
    end

    image2_keyreg =  imwarp(image2,tform2,'OutputView',imref2d(size(image1)));    
    
    figure(2)
    imagesc(image1-image2_keyreg); colormap(gray)
end

