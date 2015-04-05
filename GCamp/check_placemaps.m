% Script to plug through and check place maps...
field_index = find(ip == 1);

for m = 1:length(r_starts)
    
end

for k = 1:length(field_index)
    
    fires = SP(field_index(k),:) > 0;
    
    figure(800)
    subplot(3,1,1) 
    plot(t,x,'b',t(fires),x(fires),'r.'); xlabel('Time(s)'); ylabel('X Position (cm)');
    title(['Cell number ' num2str(field_index(k))]);
    
    subplot(3,1,2)
    plot(t,y,'b',t(fires),y(fires),'r.'); xlabel('Time(s)'); ylabel('Y Position (cm)');
    
    subplot(3,1,3) 
    imagesc(TMap{field_index(k)}'); 
    
    waitforbuttonpress
    
end