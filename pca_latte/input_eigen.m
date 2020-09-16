I = 'wrong_heart.jpeg';
I = imread(I);
I = imresize(I,[150 150]);
img = double(rgb2gray(I)); 
latte = zeros(150,150); %�ʱ�ȭ
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
    I = imresize(I,[150 150]); %224X224�� �ٲ�
    img = double(rgb2gray(I));%�������� �ٲٰ�, double������ �ٲ�
    x(k,:) = (img(:))'; %ó���� �̹��� ����� x����� ��ҷ� �ִ´�.
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