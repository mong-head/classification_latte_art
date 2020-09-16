function[label,scores] = new_image_classify(image)
%load latte_net.mat;
load workspace.mat;

inputSize = latte_net.Layers(1).InputSize;

classNames = latte_net.Layers(end).ClassNames;
%numClasses = numel(classNames);

I = imread(image);
I = imresize(I,inputSize(1:2));
[label, scores] = classify(latte_net,I);
scores = 100*scores(classNames == label);
end
% figure
% imshow(I)
% title(string(label) + "," +num2str(100*scores(classNames == label),3) + "%");

