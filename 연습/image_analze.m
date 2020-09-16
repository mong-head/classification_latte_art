%threshold
%https://giantpark197cm.tistory.com/48
b = imread('heart.jpg');
imwrite(b, 'r.tif');
b = imread('r.tif');
[x,map] = imread('r.tif');
figure;
imshow(b);
%figure;
%imshow(b>100);
%figure;
BW = im2bw(b,0.73);
%s = uint8(ind2gray(x,map));
%figure;
%imshow(s);
%BW = imread('r.jpg');

%https://kr.mathworks.com/help/images/ref/bwtraceboundary.html
%경계선 검출 - 잘안됨
% imshow(BW);
% r1 = 3;
% c1 = 2;
% contour = bwtraceboundary(BW,[r1 c1],'W',8);
% hold on
% plot(contour(:,2),contour(:,1),'g','LineWidth',2);

%원 경계선 찾기(컵) -ok
%https://kr.mathworks.com/help/images/detect-and-measure-circular-objects-in-an-image.html
d = imdistline; %133.50
delete(d);
gray_image = rgb2gray(b);
%imshow(gray_image);
[centers,radii] = imfindcircles(b,[68 73],'ObjectPolarity','bright',...
    'Sensitivity',0.95);
%length(centers)
%h = viscircles(centers,radii,'Color','b');

%경계찾기 - edge
%https://kr.mathworks.com/help/images/ref/edge.html
% I = imread('heart.jpg');
% I = im2bw(I,0.73);
% imwrite(I, 'heart.tif');
% I = imread('heart.tif');
% imshow(I);
% 
% BW1 = edge(I,'Canny'); %이게 더 나은듯.근데 잡음제거도해야하나.
% BW2 = edge(I,'Prewitt');
% imshowpair(BW1,BW2,'montage');

I = imread('heart.jpg');
I = im2bw(I,0.73);
I = int32(I);
figure;
imshow(I);
%imwrite(I, 'heart.tif');
BW = imbinarize(I);
figure;
imshow(BW);


