% Messing around with Naive Bayes Classifier / Decoder

 % indices to use for training data - could use 1st half, odd minutes, etc.
 %  Could ALSO use only times when he is running and only decode times when
 %  he isn't to look at replays.  In fact, this is what we should probably
 %  do...
train_ind = 1:round(size(FT,2)/2);

%% Get X and Y bins
Xrange = max(x)-min(x);
Yrange = max(y)-min(y);

NumXBins = ceil(Xrange/cmperbin);
NumYBins = ceil(Yrange/cmperbin);

Xedges = (0:NumXBins)*cmperbin+min(x);
Yedges = (0:NumYBins)*cmperbin+min(y);

[~,Xbin] = histc(x,Xedges);
[~,Ybin] = histc(y,Yedges);

Xbin(find(Xbin == (NumXBins+1))) = NumXBins;
Ybin(find(Ybin == (NumYBins+1))) = NumYBins;

Xbin(find(Xbin == 0)) = 1;
Ybin(find(Ybin == 0)) = 1;

%% Fit the data - is multivariate multinomial appropriate?

nbx = fitNaiveBayes(FT(train_ind)',Xbin(train_ind)','dist','mvmn');
nby = fitNaiveBayes(FT(train_ind)',Ybin(train_ind)','dist','mvmn');

predict_x = nbx.predict(FT');
predict_y = nby.predict(FT');

%% Scroll through and look at true position data versus predicted position data

figure(100);
frame_increment = 100;
for j = 1:round(size(FT,2)/frame_increment); 
    range_use = (j-1)*frame_increment+1:j*frame_increment; 
    plot(Xbin(range_use),Ybin(range_use),'b*',...
        predict_x(range_use),predict_y(range_use),'ro'); 
    waitforbuttonpress; 
end
