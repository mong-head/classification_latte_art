net = googlenet;

inputSize = net.Layers(1).InputSize;

classNames = net.Layers(end).ClassNames;
numClasses = numel(classNames);
%disp(classNames(randperm(numClasses,10)))

I = imread('heart.jpg');
figure
imshow(I)

I = imresize(I,inputSize(1:2));
figure
imshow(I)

[label, scores] = classify(net,I);
label;

figure
imshow(I)
title(string(label) + "," +num2str(100*scores(classNames == label),3) + "%");

%도표
[~,idx] = sort(scores,'descend');
idx = idx(5:-1:1);
classNamesTop = net.Layers(end).ClassNames(idx);
scoresTop = scores(idx);
figure
barh(scoresTop)
xlim([0 1])
title('Top 5 Predictions')
xlabel('Probability')
yticklabels(classNamesTop)

%참조 : https://kr.mathworks.com/help/deeplearning/examples/classify-image-using-googlenet.html?searchHighlight=%EC%9D%B4%EB%AF%B8%EC%A7%80%20%ED%95%99%EC%8A%B5&s_tid=doc_srchtitle#d117e2937
%새로운 이미지 분류 : https://kr.mathworks.com/help/deeplearning/examples/train-deep-learning-network-to-classify-new-images.html