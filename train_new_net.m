%새로운 이미지 분류 : https://kr.mathworks.com/help/deeplearning/examples/train-deep-learning-network-to-classify-new-images.html
%https://m.blog.naver.com/PostView.nhn?blogId=matlablove&logNo=220948866959&proxyReferer=https%3A%2F%2Fwww.google.com%2F

%%image관련
%image를 matlab으로 불러오기 위해 imageDatastore함수를 쓴다. 빅데이터 파일시스템 이미지들도 읽어올 수 있다.
all_images = imageDatastore('latte_image','IncludeSubfolders',true, 'LabelSource', 'foldernames');

%학습데이터를 2세트로 나눔. 70%는 학습, 30%는 테스트위함.
[training_images, test_images] = splitEachLabel(all_images,0.7);


%선행학습 네트워크 load
net = googlenet;

%analyzeNetwork(net);
%net.Layers(1); %layer의 젤 첫 요소는 이미지 입력계층임.

inputSize = net.Layers(1).InputSize;

%마지막 계층을 바꾼다.
%마지막 계층은 학습가능한 계층과 마지막 분류 계층이 이미지 분류하는데 사용하는 이미지 특징을 추출한다.
%GoogleNet의 두 계층인 'loss3-classifier'와 'output'은 네트워크가 추출하는 특징을 클래스 확률, 손실 값
%및 예측된 레이블로 조합하는 방법에 대한 정보를 포함한다.
%사전 훈련된 네트워크를 새로운 이미지를 분류하도록 다시 훈련시키려면
%이 두 계층을 새 데이트 세트에 맞게 조정된 새로운 계층으로 바꾸어야 한다.

%훈련된 네트워크에서 계층 그래프를 추출하는 과정
%SeriesNetWork 객체라면 net.Layers의 계층 목록을 계층 그래프로 변환한다.
%그 객체로는 AlexNet, VGG-16/19등이 있다.
if isa(net, 'SeriesNetWork')
    lgraph = layerGraph(net.Layers);
else
    lgraph = layerGraph(net);
end

%바꿀 두 계층의 이름을 찾는다.
%수동으로 할 수는있지만 밑의 함수를 사용해 자동으로 계층 찾을 수도 있다.
[learnableLayer, classLayer] = findLayersToReplace(lgraph);
%[learnableLayer, classLayer]

%완전 연결 계층인 마지막 계층이 학습 가능한 가중치를 갖는다.
%이 완전 연결 계층을 출력값의 개수가 새 데이터 세트의 클래스 개수와 같은 새로운 완전 연결 계층으로 바꾼다.
%전이된 계층보다 새로운 계층에서 더 빠르게 학습 시키려면 계층의 학습률 인자 값을 높이면 된다.

numClasses = numel(categories(training_images.Labels));

if isa(learnableLayer,'nnet.cnn.layer.FullyConnectedLayer')
    newLearnableLayer = fullyConnectedLayer(numClasses, ...
        'Name','new_fc', 'WeightLearnRateFactor',10,'BiasLearnRateFactor',10);
    
elseif isa(learnableLayer,'nnet.cnn.layer.Convolution2DLayer')
    newLearnableLayer = convolution2dLayer(1,numClasses, ...
        'Name','new_conv','WeightLearnRateFactor','BiasLearnRateFactor',10);
end

lgraph = replaceLayer(lgraph,learnableLayer.Name,newLearnableLayer);

%분류계층은 네트워크의 출력 클래스를 지정한다.
%분류계층을 클래스 label이 없는 새로운 계층으로 바꾼다.
%trainNetwork는 훈련을 진행시, 계층의 출력 클래스를 자동으로 설정한다.
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,classLayer.Name,newClassLayer);

%새 계층이 올바로 연결되었는지 확인하려면 새로운 계층 그래프를 플로팅하고, 마지막 계층을 확대시켜보면 됨.
figure('Units','normalized','Position',[0.3 0.3 0.4 0.4]);
plot(lgraph)
ylim([0,10])

%여기 까지 새 이미지 세트를 사용해 네트워크를 다시 훈련시킬 준비를 함

%%초기계층 고정하기
%초기 계층의 여러 가중치를 고정시, 네트워크 훈련 속도를 대폭 높일 수 있다.
%세트의 크기가 작을때, 이전 네트워크 계층을 고정해서, 해당 계층이 새로운 데이터 세트에 과적합되지 않도록 할 수 있다.

%계층 그래프의 계층과, 연결을 추출하고, 다음 고정할 계층을 선택한다.
%GoogleNet에서는 처음 10개 계층이 네트워크 초기 '줄기'가 된다.
%freezeWeights : 매개변수로 들어온 layer 계층 학습률 0으로 설정한다.
%createLgraphUsingConnetions : 모든 계층을 원래 순서대로 다시 연결
%새로운 계층 그래프는 동일한 계층을 포함하지만, 앞쪽 계층의 학습률은 0으로 설정한거임
layers = lgraph.Layers;
connections = lgraph.Connections;

layers(1:10) = freezeWeights(layers(1:10));
lgraph = createLgraphUsingConnections(layers,connections);

%%네트워크 훈련시키기
%이미지의 정확한 세부정보가 기억되지 않도록 전처리를 할 수는 있다. 
%전처리
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

%훈련옵션의 지정
%InitialLearnRate를 작은 값으로 설정 : 아직 고정안된 전이된 계층의 학습을 늦추기 위함
%위에서 새로운 마지막 계층의 학습 속도 높이려고 학습률인자 값을 늘렸었다.
%-->새로운 계층은 학습 빠록, 중간 계층은 학습 느리며, 고정된 앞쪽은 학습안함

%훈련을 진행할 Epoch횟수 : 전이학습때는 많은 횟수안해도됨.
%훈련중의 validationFrequency번 반복마다 네트워크 검증함.
options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',3e-4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',augimdsValidation, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');
%훈련할 때에 CPU나 GPU를 사용한다. 
latte_net = trainNetwork(augimdsTrain,lgraph,options);

save latte_net;

%%검증 이미지 분류하기
%미세 조정된 네트워크를 사용해서 검증이미지 분류한 다음 분류정확도를 계산한다.
[YPred,probs] = classify(latte_net,augimdsValidation);
accuracy = mean(YPred == test_images.Labels);

%4개의 샘플 검증이미지를 예측된 레이블 및 이 레이블을 갖는 이미지의 예측된 확률과 함께 표시한다.
% idx = randperm(numel(test_images.Files),4);
% figure
% for i = 1:4
%     subplot(2,2,i)
%     I = readimage(test_images,idx(i));
%     imshow(I)
%     label = YPred(idx(i));
%     title(string(label) + ", " + num2str(100*max(probs(idx(i),:)),3) + "%");
% end
