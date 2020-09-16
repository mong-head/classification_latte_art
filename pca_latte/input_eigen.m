I = 'wrong_heart.jpeg';
I = imread(I);
I = imresize(I,[150 150]);
img = double(rgb2gray(I)); 
latte = zeros(150,150); %초기화
latte(:) = (img(:))'; 

%pca
c = cov(latte);
[v, d] = eig(c);

load heart_v.mat;

imwrite(uint8(latte/max(latte(:))*255), 'test_eigen.jpg');

n = 20;
x = zeros(n, 150*150); 
for k=1:n,
    I = 'wrong_heart.jpeg';
    I = imread(I);
    I = imresize(I,[150 150]);
    I = imresize(I,[150 150]); %224X224로 바꿈
    img = double(rgb2gray(I));%이진으로 바꾸고, double형으로 바꿈
    x(k,:) = (img(:))'; %처리한 이미지 행렬을 x행렬의 요소로 넣는다.
end;

cnt = 2;
for k=cnt,
    % K-L transform
    v_k = heart_v(:,150*150-k+1:150*150);
    y_k = x*v_k;
    % reconstruction
    x_recons = v_k*y_k';
    for i=1:n,
        fname = sprintf('%s%dres%d.jpg','reconstruct_new_heart\',i,k);
        latte(:) = x_recons(:,i);
        imwrite(uint8(latte), fname);
    end;
end;