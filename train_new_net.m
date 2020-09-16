%���ο� �̹��� �з� : https://kr.mathworks.com/help/deeplearning/examples/train-deep-learning-network-to-classify-new-images.html
%https://m.blog.naver.com/PostView.nhn?blogId=matlablove&logNo=220948866959&proxyReferer=https%3A%2F%2Fwww.google.com%2F

%%image����
%image�� matlab���� �ҷ����� ���� imageDatastore�Լ��� ����. ������ ���Ͻý��� �̹����鵵 �о�� �� �ִ�.
all_images = imageDatastore('latte_image','IncludeSubfolders',true, 'LabelSource', 'foldernames');

%�н������͸� 2��Ʈ�� ����. 70%�� �н�, 30%�� �׽�Ʈ����.
[training_images, test_images] = splitEachLabel(all_images,0.7);


%�����н� ��Ʈ��ũ load
net = googlenet;

%analyzeNetwork(net);
%net.Layers(1); %layer�� �� ù ��Ҵ� �̹��� �Է°�����.

inputSize = net.Layers(1).InputSize;

%������ ������ �ٲ۴�.
%������ ������ �н������� ������ ������ �з� ������ �̹��� �з��ϴµ� ����ϴ� �̹��� Ư¡�� �����Ѵ�.
%GoogleNet�� �� ������ 'loss3-classifier'�� 'output'�� ��Ʈ��ũ�� �����ϴ� Ư¡�� Ŭ���� Ȯ��, �ս� ��
%�� ������ ���̺�� �����ϴ� ����� ���� ������ �����Ѵ�.
%���� �Ʒõ� ��Ʈ��ũ�� ���ο� �̹����� �з��ϵ��� �ٽ� �Ʒý�Ű����
%�� �� ������ �� ����Ʈ ��Ʈ�� �°� ������ ���ο� �������� �ٲپ�� �Ѵ�.

%�Ʒõ� ��Ʈ��ũ���� ���� �׷����� �����ϴ� ����
%SeriesNetWork ��ü��� net.Layers�� ���� ����� ���� �׷����� ��ȯ�Ѵ�.
%�� ��ü�δ� AlexNet, VGG-16/19���� �ִ�.
if isa(net, 'SeriesNetWork')
    lgraph = layerGraph(net.Layers);
else
    lgraph = layerGraph(net);
end

%�ٲ� �� ������ �̸��� ã�´�.
%�������� �� ���������� ���� �Լ��� ����� �ڵ����� ���� ã�� ���� �ִ�.
[learnableLayer, classLayer] = findLayersToReplace(lgraph);
%[learnableLayer, classLayer]

%���� ���� ������ ������ ������ �н� ������ ����ġ�� ���´�.
%�� ���� ���� ������ ��°��� ������ �� ������ ��Ʈ�� Ŭ���� ������ ���� ���ο� ���� ���� �������� �ٲ۴�.
%���̵� �������� ���ο� �������� �� ������ �н� ��Ű���� ������ �н��� ���� ���� ���̸� �ȴ�.

numClasses = numel(categories(training_images.Labels));

if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', 'WeightLearnRateFactor',10,'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv','WeightLearnRateFactor','BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);

%�з������� ��Ʈ��ũ�� ��� Ŭ������ �����Ѵ�.
%�з������� Ŭ���� label�� ���� ���ο� �������� �ٲ۴�.
%trainNetwork�� �Ʒ��� �����, ������ ��� Ŭ������ �ڵ����� �����Ѵ�.
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

%�� ������ �ùٷ� ����Ǿ����� Ȯ���Ϸ��� ���ο� ���� �׷����� �÷����ϰ�, ������ ������ Ȯ����Ѻ��� ��.
figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])

%���� ���� �� �̹��� ��Ʈ�� ����� ��Ʈ��ũ�� �ٽ� �Ʒý�ų �غ� ��

%%�ʱ���� �����ϱ�
%�ʱ� ������ ���� ����ġ�� ������, ��Ʈ��ũ �Ʒ� �ӵ��� ���� ���� �� �ִ�.
%��Ʈ�� ũ�Ⱑ ������, ���� ��Ʈ��ũ ������ �����ؼ�, �ش� ������ ���ο� ������ ��Ʈ�� �����յ��� �ʵ��� �� �� �ִ�.

%���� �׷����� ������, ������ �����ϰ�, ���� ������ ������ �����Ѵ�.
%GoogleNet������ ó�� 10�� ������ ��Ʈ��ũ �ʱ� '�ٱ�'�� �ȴ�.
%freezeWeights : �Ű������� ���� layer ���� �н��� 0���� �����Ѵ�.
%createLgraphUsingConnetions : ��� ������ ���� ������� �ٽ� ����
%���ο� ���� �׷����� ������ ������ ����������, ���� ������ �н����� 0���� �����Ѱ���
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);

%%��Ʈ��ũ �Ʒý�Ű��
%�̹����� ��Ȯ�� ���������� ������ �ʵ��� ��ó���� �� ���� �ִ�. 
%��ó��
pixelRange = [-30 30];
scaleRange = [0.9 1.1];
imageAugmenter = imageDataAugmenter( ...
    'RandXReflection',true, ...
    'RandXTranslation',pixelRange, ...
    'RandYTranslation',pixelRange, ...
    'RandXScale',scaleRange, ...
    'RandYScale',scaleRange);
augimdsTrain = augmentedImageDatastore(inputSize(1:2),training_images, ...
    'DataAugmentation',imageAugmenter);

augimdsValidation = augmentedImageDatastore(inputSize(1:2),test_images);

%�Ʒÿɼ��� ����
%InitialLearnRate�� ���� ������ ���� : ���� �����ȵ� ���̵� ������ �н��� ���߱� ����
%������ ���ο� ������ ������ �н� �ӵ� ���̷��� �н������� ���� �÷Ⱦ���.
%-->���ο� ������ �н� ����, �߰� ������ �н� ������, ������ ������ �н�����

%�Ʒ��� ������ EpochȽ�� : �����н����� ���� Ƚ�����ص���.
%�Ʒ����� validationFrequency�� �ݺ����� ��Ʈ��ũ ������.
options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');
%�Ʒ��� ���� CPU�� GPU�� ����Ѵ�. 
latte_net = trainNetwork(augimdsTrain,lgraph,options);

save latte_net;

%%���� �̹��� �з��ϱ�
%�̼� ������ ��Ʈ��ũ�� ����ؼ� �����̹��� �з��� ���� �з���Ȯ���� ����Ѵ�.
[YPred,probs] = classify(latte_net,augimdsValidation);
accuracy = mean(YPred == test_images.Labels);

%4���� ���� �����̹����� ������ ���̺� �� �� ���̺��� ���� �̹����� ������ Ȯ���� �Բ� ǥ���Ѵ�.
% idx = randperm(numel(test_images.Files),4);
% figure
% for i = 1:4
%     subplot(2,2,i)
%     I = readimage(test_images,idx(i));
%     imshow(I)
%     label = YPred(idx(i));
%     title(string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
% end
