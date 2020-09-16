%pca�̿� eigen_tulip//(2��)�ϴ°���
%https://darkpgmr.tistory.com/110
% training images
n = 20;
x = zeros(n, 150*150); 
for k=1:n,
    fname = sprintf('%s%d.jpg','cut_image\tulip\',k);
    I = imread(fname);
    I = imresize(I,[150 150]); %224X224�� �ٲ�
    img = double(rgb2gray(I));%�������� �ٲٰ�, double������ �ٲ�
    x(k,:) = (img(:))'; %ó���� �̹��� ����� x����� ��ҷ� �ִ´�.
end;

% pca
c = cov(x);
[tulip_v, tulip_d] = eig(c);
load tulip_v;
load tulip_d;

% % average tulip
% latte = zeros(150,150);
% latte(:) = mean(x);
% imwrite(uint8(latte), 'avg_tulip.jpg');
% 
% % eigen tulip (first 20 tulip)
% for k=1:20,
%     fname = sprintf('%seig%d.jpg','eigen_tulip_image\',k);
%     latte(:) = v(:,150*150-k+1);
%     imwrite(uint8(latte/max(latte(:))*255), fname);
% end;
% 
% % reconstruction using only k eigen tulip
% cnt = [20, 10, 5, 2];
% for k=cnt,
%     % K-L transform
%     v_k = v(:,150*150-k+1:150*150);
%     y_k = x*v_k;
%     % reconstruction
%     x_recons = v_k*y_k';
%     for i=1:n,
%         fname = sprintf('%s%dres%d.jpg','reconstruct_tulip_image\',i,k);
%         latte(:) = x_recons(:,i);
%         imwrite(uint8(latte), fname);
%     end;
% end;
