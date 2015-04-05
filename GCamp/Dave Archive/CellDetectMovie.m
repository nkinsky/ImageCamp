function [] = CellDetectMovie(FT,x,y)

figure;
aviobj = VideoWriter('temp3.avi');
open(aviobj);

for i = 1:200%size(FT,2)
  temp = h5read('FLmovie.h5','/Object',[1 1 i*4 1],[490 520 1 1]);
  a = find(FT(:,i*4) > 0);
  imshow(temp);caxis([0 0.2]);
  
  for j = 1:length(x)
      hold on;
      plot(x{j},y{j},'-b','LineWidth',0.5);
  end
  
  for j = 1:length(a)
      hold on;
      plot(x{a(j)},y{a(j)},'-r','LineWidth',3);
  end
  F = getframe;
  writeVideo(aviobj,F)
end
close(gcf);
close(aviobj);
end