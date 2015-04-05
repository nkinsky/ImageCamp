function [] = TempSmoothMovie(infile,outfile,smoothfr);

% smoothfr:     size of smoothing window in frames

info = h5info(infile,'/Object');
NumFrames = info.Dataspace.Size(3);
XDim = info.Dataspace.Size(1);
YDim = info.Dataspace.Size(2);

h5create(outfile,'/Object',info.Dataspace.Size,'ChunkSize',[XDim YDim 1 1],'Datatype','single');

for i = 1:smoothfr-1
    F{i} = single(h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1])); % write first smoothfr-1 frames to cell F
    h5write(outfile,'/Object',single(F{i}),[1 1 i 1],[XDim YDim 1 1]); % write first smoothfr-1 frames to h5 outfile
end

for i = smoothfr:NumFrames
  display(['Calculating F traces for movie frame ',int2str(i),' out of ',int2str(NumFrames)]);
  F{smoothfr} = single(h5read(infile,'/Object',[1 1 i 1],[XDim YDim 1 1])); % write next frame to cell F
  Fout = zeros(size(F{1})); % initialize Fout
  for j = 1:smoothfr
    Fout = Fout+F{j}; % add up all the frames to be smoothed
  end
  Fout = Fout./smoothfr; % average out by dividing by smoothfr frames
  h5write(outfile,'/Object',single(Fout),[1 1 i 1],[XDim YDim 1 1]); % write

  for j = 1:smoothfr-1
      F{j} = F{j+1}; % shift all frames to be smoothed forward - this keeps memory use low by only keeping smoothfr frames in memory
  end
  
  update_indexfile(infile,outfile);
end

  