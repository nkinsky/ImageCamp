% plot familiar vs novel vs iso box sessions next to one another

%% load files
% file locations
familiar_folder = 'E:\Novelty\G30\9_3_2014_nb\1 - square track\ICmovie-Objects';
novel_folder = 'E:\Novelty\G30\9_3_2014_nb\2 - rectangularplastictub\ICmovie-Objects';
iso_folder = 'E:\Novelty\G30\9_3_2014_nb\2 - rectangularplastictub\ICmovie-Objects';

% load frames
frames = LoadFrames(fullfile(familiar_folder,'Obj_1 - Concatenated Movie.h5'),1:3000);
frames_novel = LoadFrames(fullfile(novel_folder,'Obj_1 - Concatenated Movie.h5'),1:3000);
frames_iso = LoadFrames(fullfile(iso_folder,'Obj_1 - Concatenated Movie.h5'),17598:20597);

%% plot stuff

% Set up figure
figure; 
set(gcf, 'Position', [7 42 820 640]); 

% Prepare the new file.
vidObj = VideoWriter('Fam v Novel v Iso.avi');
open(vidObj);

for j = 1:3000
    subplot(2,2,1); 
    imagesc_gray(squeeze(frames(:,:,j))); colorbar off;
    title(['Familiar - ' num2str(j/20, '%0.1f')]); 
     
    subplot(2,2,2); 
    imagesc_gray(squeeze(frames_novel(:,:,j))); colorbar off; 
    title('Novel'); 
    
    subplot(2,2,3); 
    imagesc_gray(squeeze(frames_iso(:,:,j))); 
    title('Iso'); 
    colorbar off; 
    
    % Write each frame to the file.
    currFrame = getframe(gcf);
    writeVideo(vidObj,currFrame);
end 
toc

close(vidObj);

%% write to AVI
% Prepare the new file.
    vidObj = VideoWriter('peaks.avi');
    open(vidObj);
 
    % Create an animation.
    Z = peaks; surf(Z);
    axis tight manual
    set(gca,'nextplot','replacechildren');
 
    for k = 1:20
       surf(sin(2*pi*k/20)*Z,Z)
 
       % Write each frame to the file.
       currFrame = getframe(gcf);
       writeVideo(vidObj,currFrame);
    end
  
    % Close the file.
    close(vidObj);