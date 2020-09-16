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
%��輱 ���� - �߾ȵ�
% imshow(BW);
% r1 = 3;
% c1 = 2;
% contour = bwtraceboundary(BW,[r1 c1],'W',8);
% hold on
% plot(contour(:,2),contour(:,1),'g','LineWidth',2);

%�� ��輱 ã��(��) -ok
%https://kr.mathworks.com/help/images/detect-and-measure-circular-objects-in-an-image.html
d = imdistline; %133.50
delete(d);
gray_image = rgb2gray(b);
%imshow(gray_image);
[centers,radii] = imfindcircles(b,[68 73],'ObjectPolarity','bright',...
    'Sensitivity',0.95);
%length(centers)
%h = viscircles(centers,radii,'Color','b');

%���ã�� - edge
%https://kr.mathworks.com/help/images/ref/edge.html
% I = imread('heart.jpg');
% I = im2bw(I,0.73);
% imwrite(I, 'heart.tif');
% I = imread('heart.tif');
% imshow(I);
% 
% BW1 = edge(I,'Canny'); %�̰� �� ������.�ٵ� �������ŵ��ؾ��ϳ�.
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


