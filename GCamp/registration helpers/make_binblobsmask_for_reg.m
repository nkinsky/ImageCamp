function [  ] = make_binblobsmask_for_reg( session_struct, num_trans_per_10min )
%make_binblobsmask_for_reg( session_struct, num_trans_per_10min )
% Makes a mask of all neurons that are highly active (i.e. have above
% num_trans_per_10min) transients in a 10 minute session for later
% registration in turboreg

SR = 20; % Sample rate of imaging in fps

currdir = cd;
for j = 1:length(session_struct)
   ChangeDirectory_NK(session_struct(j));
   load('MeanBlobs.mat','BinBlobs');
   load('ProcOut.mat','NumTransients','NumFrames')
   trans_thresh = round(num_trans_per_10min*NumFrames/SR/60/10,0);
   allmask = create_AllICmask(BinBlobs(NumTransients > trans_thresh));
   imwrite(allmask,['BinBlobsMask_ ' num2str(num_trans_per_10min) 'thresh.tif'],...
       'Compression','None')
end

cd(currdir)

end

