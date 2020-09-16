img = 'wrong_heart.jpeg';
img_name = extractBefore(img,".");
img_tif = sprintf('%s.tif',img_name);
A = imread(img);
A = imresize(A,[150 150]);
B = imread('avg_heart.jpg');
C = imread('avg_rosetta.jpg');
D = imread('avg_tulip.jpg');

% figure;
% imshow(A);
% figure;
% imshow(B);

imwrite(A,img_tif);
A = imread(img_tif);
imwrite(B,'avg_heart.tif');
B = imread('avg_heart.tif');
imwrite(C,'avg_rosetta.tif');
C = imread('avg_rosetta.tif');
imwrite(D,'avg_tulip.tif');
D = imread('avg_tulip.tif');
% 
% A = im2double(A);
% B = im2double(B);
% C = im2double(C);
% D = im2double(D);

% d1 = A-B;
% d1 = abs(d1);
% d1 = var(d1);
% M = mean(d1,'all');
% disp(M);
% 
% d2 = A-C;
% d2 = abs(d2);
% d2 = var(d2);
% M = mean(d2,'all');
% disp(M);
% 
% d3 = A-D;
% d3 = abs(d3);
% d3 = var(d3);
% M = mean(d3,'all');
% disp(M);

figure;
imshowpair(A,B,'diff');
figure;
imshowpair(A,C,'diff');
figure;
imshowpair(A,D,'diff');