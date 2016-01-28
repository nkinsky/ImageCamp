function [ ] = plot_FTonpos(t,x,y,FT )
% plot_FTonpos(t,x,y,FT ) - plots transient firing on position data.  Will
% scroll through all the neurons indicated in FT with a buttonpress

figure(gcf)
for j = 1:size(FT,1)
   trans_index = logical(FT(j,:)); % Make transient times logical array
   
   subplot(2,1,1); 
   plot(t,x,'b',t(trans_index),x(trans_index),'r*'); 
   title(['Neuron ' num2str(j)]); 
   xlabel('time (s)'); ylabel('x position (cm)');
   
   subplot(2,1,2); 
   plot(t,y,'b',t(trans_index),y(trans_index),'r*');
   title(num2str(j)); xlabel('time (s)'); ylabel('y position (cm)');
   
   waitforbuttonpress;
   
end




end

