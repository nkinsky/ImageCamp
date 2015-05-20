thresh = [0.5:0.1:0.8, 0.85, 0.9];

figure;
hold on;
for i = 1:length(thresh)
    i
    [r,r_boot] = corr_cdfp(TMap_resized,[1,2],p,thresh(i),0);
    
    [rp,rx] = ecdf(r);
    
    plot(rx,rp);
end

labels = cell(1,length(thresh)); 
for i = 1:length(thresh)
    labels{i} = num2str(thresh(i)); 
end

legend(labels); 
title('Thresholding pval on CDF', 'fontsize', 12);
xlabel('Correlation Coefficients', 'fontsize', 12);
ylabel('Proportion', 'fontsize', 12); 