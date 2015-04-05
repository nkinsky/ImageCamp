avi_obj = VideoReader('G37_2015FEB26_3xzoom_1xtime_smoothDF.avi');

num_Frames = avi_obj.Duration*avi_obj.FrameRate;

avi_out = VideoWriter('G37_out.avi');

open(avi_out)
figure
for j = 1:num_Frames
    avi_obj.CurrentTime = (j-1)/avi_obj.FrameRate;
    pFrame = readFrame(avi_obj);
    
    imagesc_gray(pFrame);
    hold on;
    plot([x1; x1(1)], [y1; y1(1)],'r',[x2; x2(1)], [y2; y2(1)],'g')
    hold off
    
    frameout = getframe;
    writeVideo(avi_out,frameout)
    
end

close(avi_out)