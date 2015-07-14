sm = fspecial('disk',15); 

figure;
for i=1:10
    test = BayesFlat(:,:,i);
    test(isnan(test)) = 0;
    filtered = imfilter(test,sm);
    filtered(isnan(BayesFlat(:,:,i))) = nan; 
    subplot(5,2,i);
    imagesc_nan(filtered);
end

figure;
for i=1:10
    subplot(5,2,i);
    imagesc_nan(TMap{i});
end
