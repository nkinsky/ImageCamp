% obviously this is commented terribly.  Sorry.

load PlaceMaps.mat

xarena_out = [1 142 142 1 1]; yarena_out = [58 58 1 1 58];
xarena_in1 = [12 130 130 12 12]; yarena_in1 = [22 22 12 12 22];
xarena_in2 = [12 130 130 12 12]; yarena_in2 = [46 46 36 36 46];
goalx = [105 105]; goaly = [1 58];

field_index = find(ip == 1);
% field_index = [112 190 227 371 490 497 543 552];
h800 = figure(800);
set(h800,'Position',[10 350 900 600])
for k = 1:length(field_index)
fires = SP(field_index(k),:) > 0;
figure(800)
subplot(3,1,1)
plot(t,x,'b',t(fires),x(fires),'r.'); xlabel('Time(s)'); ylabel('X Position (cm)');
title(['Cell number ' num2str(field_index(k))]);
subplot(3,1,2)
plot(t,y,'b',t(fires),y(fires),'r.'); xlabel('Time(s)'); ylabel('Y Position (cm)');
subplot(3,1,3)
b = imagesc(TMap{field_index(k)}'); % set(b,'AlphaData',OccMap' ~= 0)
hold on; % patch(xarena_out,yarena_out,'w')
patch(xarena_in1,yarena_in1,'w')
patch(xarena_in2,yarena_in2,'w')
if field_index(k) == 190
    subplot(3,1,1); xlim([150 450])
    subplot(3,1,2); xlim([150 450])
elseif field_index(k) == 552
    subplot(3,1,1); xlim([50 400])
    subplot(3,1,2); xlim([50 400])
end
% hold on; plot(goalx,goaly,'g*')
% subplot(4,1,4)
% imagesc(TMap{field_index(k)}')
% waitforbuttonpress
pause
end