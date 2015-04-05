% Script to plot out split, separately registered sessions when compared to
% a combined session.

file2_reginfo = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangular plastic tub\RegistrationInfo.mat';
file1_reginfo = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\rectangle\RegistrationInfo.mat';
file_combined_reginfo = 'C:\Users\kinsky.AD\Documents\Lab\Imaging\GCamp Mice\GCamp6f_27\7_15_2014\combined\IC300-Objects\Obj_1\RegistrationInfo.mat';

AllIC_split = reginfo_split.AllIC_reg_manual | reginfo_split.AllIC_base;
AllIC_split_reg = imwarp(AllIC_split,reginfo_combined.tform,'OutputView',imref2d(size(reginfo_combined.AllIC_base)));
AllIC_session1_reg = imwarp(reginfo_split.AllIC_base,reginfo_combined.tform,'OutputView',imref2d(size(reginfo_combined.AllIC_base)));
AllIC_session2_reg = imwarp(reginfo_split.AllIC_reg,reginfo_combined.tform,'OutputView',imref2d(size(reginfo_combined.AllIC_base)));

figure
subplot(2,2,1)
imagesc(AllIC_session1_reg); title('Split Session 1 Cell Masks - Registered')
subplot(2,2,2)
imagesc(AllIC_session2_reg); title('Split Session 2 Cell Masks - Registered')
subplot(2,2,3)
imagesc(reginfo_combined.AllIC_base); title('Combined Session Cell Masks')
subplot(2,2,4)
imagesc(AllIC_split_reg); title('Split Session Merged Cell Masks - Registered')

figure
imagesc(2*AllIC_split_reg + reginfo_combined.AllIC_base);
h = colorbar('YTick',[0 1 2 3],'YTickLabel', {'','Combined Image Cells','Split Image Cells','Overlapping Cells'});
