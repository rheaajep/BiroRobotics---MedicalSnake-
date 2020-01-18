clc
clear all
rgbImage=imread('pipe5.jpg');
%imshow(rgbImage);
lab_rgbImage=rgb2lab(rgbImage);
%figure
%imshow(lab_rgbImage);
%figure
gray_image=rgb2gray(lab_rgbImage);
%imshow(gray_image);
bw=gray_image<1;
%figure
%imshow(bw);
ch=bwconvhull(bw,'objects');
figure
imshow(ch);
stats=regionprops('table',ch,'Centroid','MajorAxisLength','MinorAxisLength');
centers=stats.Centroid;
x1=centers(1:36,1);
y1=centers(1:36,2);
x2=centers(37:114,1);
y2=centers(37:114,2);
x1_mean=mean(x1);
y1_mean=mean(y1);
x2_mean=mean(x2);
y2_mean=mean(y2);
hold on 
plot(x1_mean,y1_mean,'r.',x2_mean,y2_mean,'r.','MarkerSize',20)
hold off

%diameters=mean([stats.MajorAxisLength stats.MinorAxisLength],2);
%radii=diameters/2;
%hold on
%viscircles(centers,radii);
%hold off