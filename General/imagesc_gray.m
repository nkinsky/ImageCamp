function [] = imagesc_gray(A)
%imagesc_gray - simple function to run imagesc with colormap(gray) and
%colorbar enabled

imagesc(A); colormap(gca,gray); colorbar


end

