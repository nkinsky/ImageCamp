% Compare IC masks delivered from different ways of creating the FLmovie
% (1 - using min projection, 2 - using mean projection, 3 - default)

file{1} = 'I:\GCamp Mice\G30\11_13_2014\IC800_DFmin-Objects\Obj_1\ICAoutlines.mat';
file{2} = 'I:\GCamp Mice\G30\11_13_2014\IC800_DFmean2-Objects\Obj_1\ICAoutlines.mat';
file{3} = 'I:\GCamp Mice\G30\11_13_2014\IC800_DFdefault-Objects\Obj_1\ICAoutlines.mat';

names = {'Min Projection' 'Mean Projection' 'Default'};

ICAdata = cell(1,3);
All_ICmask = cell(1,3);
ICnz_mask = cell(1,3);
for j = 1:3
   ICAdata{j} = importdata(file{j});
   [ All_ICmask{j}, ICnz_mask{j} ] = create_AllICmask2( ICAdata{j}.IC,...
       ICAdata{j}.ICnz );
end

clear ICAdata

figure
imagesc(All_ICmask{1} + All_ICmask{2} + All_ICmask{3})

m = 1;
figure
for j = 1:2
   for k = j+1:3
      subplot(1,3,m)
      imagesc(All_ICmask{j} + All_ICmask{k}*2); colorbar;
      title([names{j} ' + ' names{k}]);
      m = m + 1;
   end
end
