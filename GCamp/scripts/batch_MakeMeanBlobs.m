% Batch run MakeMeanBlobs

% Enter the data structure for the sessions you want to run here
struct_run = MD(23:27);

tic
currdir = cd;
for j = 1:length(struct_run)
   ChangeDirectory(struct_run(j).Animal, struct_run(j).Date, struct_run(j).Session);
   load('ProcOut.mat','c','cTon','GoodTrs');
   
   MakeMeanBlobs(c,cTon,GoodTrs, 'suppress_output',0);
end
cd(currdir)
toc