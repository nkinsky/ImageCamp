% Plot std proj with neurons overlaid

load('T2output.mat', 'NeuronImage')
std_proj = imread('ICmovie_std_proj.tif');
figure(5); 
imagesc_gray(std_proj); 
for j = 1:length(NeuronImage)
    hold on
    bb = bwboundaries(NeuronImage{j});
    plot(bb{1}(:,2),bb{1}(:,1),'r-'); 
end