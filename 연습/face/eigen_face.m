%pca이용 eigen_face하는거임
%https://darkpgmr.tistory.com/110
% training images
n = 20;
x = zeros(n, 45*40); %얼굴들을 정규화하는 듯.
for k=1:n,
    fname = sprintf('%s%d.png','faces\',k); 
    img = double(rgb2gray(imread(fname)));%이진으로 바꾸고, double형으로 바꿈
    x(k,:) = (img(:))'; %처리한 이미지 행렬을 x행렬의 요소로 넣는다.
end;

% pca
c = cov(x);
[v, d] = eig(c);

% average face
face = zeros(45,40);
face(:) = mean(x);
imwrite(uint8(face), 'avg.png');

% eigenfaces (first 20 faces)
for k=1:20,
    fname = sprintf('%seig%d.png','eigen_faces\',k);
    face(:) = v(:,45*40-k+1);
    imwrite(uint8(face/max(face(:))*255), fname);
end;

% reconstruction using only k eigenfaces
cnt = [20, 10, 5, 2];
for k=cnt,
    % K-L transform
    v_k = v(:,45*40-k+1:45*40);
    y_k = x*v_k;
    % reconstruction
    x_recons = v_k*y_k';
    for i=1:n,
        fname = sprintf('%s%dres%d.png','reconstruct_faces\',i,k);
        face(:) = x_recons(:,i);
        imwrite(uint8(face), fname);
    end;
end;
