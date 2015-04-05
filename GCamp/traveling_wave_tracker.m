% Script to attempt to track COMs of traveling waves.
% This version only tracks one at a time!  Need to upgrade and track every
% wave occuring at a given time.

tic

close all

plot_flag = 0;

movie_file = 'I:\GCamp Mice\G19\FLmovie-Objects\Obj_1 - Concatenated Movie.h5';

info = h5info(movie_file,'/Object');
ChunkSize = info.ChunkSize;
movie_length = info.Dataspace.Size(3);

centroids = struct([]);
centroids2 = zeros(movie_length,2);
figure
for k = 1:movie_length
%     display(['Calculating F traces for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
    tempFrame = h5read(movie_file,'/Object',[1 1 k 1],ChunkSize);
    image_gray = tempFrame;
%     tempFrame = uint16(tempFrame);
    bg = imopen(tempFrame,strel('disk',10));
    tempFrame = tempFrame - bg;
    tempFrame = imadjust(tempFrame);
    level = graythresh(tempFrame);
%     level = 0.01;
    image_bw = im2bw(tempFrame,level);
    image_bw = bwareaopen(image_bw,5000,8);
    
    cc = bwconncomp(image_bw,8);
    labeled = labelmatrix(cc);
    rgb_label = label2rgb(labeled,@spring,'c','shuffle');
    s = regionprops(image_bw,'centroid');
    
    % Other try
    arb_thresh = 0.4;
    index_thresh = find(image_gray > arb_thresh);
    image_arbthresh = zeros(size(image_gray));
    image_arbthresh(index_thresh) = ones(size(index_thresh));
    image_arbthresh = bwareaopen(image_arbthresh,1000,8);
    
    cc2 = bwconncomp(image_arbthresh,8);
    s2 = regionprops(image_arbthresh,'centroid');
    
    if plot_flag == 1;
    subplot(1,3,1)
    imshow(image_gray)
    subplot(1,3,2)
    imshow(image_bw); title(['Frame ' num2str(k) ' of ' num2str(movie_length) '.'])
    % Put in way to plot traveling wave centroids here.
    hold on
    for j = 1:size(s,1)
        plot(s(j).Centroid(1),s(j).Centroid(2),'r*')
    end
    hold off
    subplot(1,3,3)
    imshow(image_arbthresh)
    hold on
    for j = 1:size(s2,1)
        plot(s2(j).Centroid(1),s2(j).Centroid(2),'g*')
    end
    else
    end
    
%     waitforbuttonpress

%     T = timer('TimerFcn',@(~,~)disp(''),'StartDelay',0.01);
%     start(T)
%     wait(T)

% Dump centroid data

% for k = 1:size(s2,1)
% centroids(k).number(i,:) = s2(k).Centroid;
% end
if size(s2,1) == 0
    centroids2(k,:) = [0 0];
elseif size(s2,1) >= 1
    centroids2(k,:) = s2(1).Centroid;
end

disp(['Reading Frame ' num2str(k) ' of ' num2str(movie_length) '.'])
    
save centroids1.mat centroids2
    
end
toc

% Print out a histogram of angles
diffs = diff(centroids2);
angles = atan2d(diffs(:,2),diffs(:,1));
nz_indices = ~(angles(:,1) == 0);
figure; hist(angles(nz_indices),20)