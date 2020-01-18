clc 
clear all 
location='C:\Users\rheap\Documents\CMU\Robotics lab\medical snake\Images\set_4/*.jpg';
ds=imageDatastore(location);
while hasdata(ds)
    rgbImage=read(ds);
    %imshow(rgbImage)
    [H S V]=rgb2hsv(rgbImage);
    image1=[V];
    %imshow(image1)
    bw=[V]>0.22;
    %imshow(bw)
    bw= ~bw;
    bw2=bwareaopen(bw,800,6);
    %bw3=bwareaopen(bw2,200,26);
    %figure
    imshowpair(bw,bw2,'montage')
    %se=strel('arbitrary',8);
    %opened=imopen(bw2,se);
    %figure
    %imshow(opened)
    bwn=bwboundaries(bw2);
    %figure
    %imshowpair(bw2,bw3,'montage')
    cc=bwconncomp(bw2);
    ch=bwconvhull(bw2,'objects');
    %figure
    %imshow(ch)
    %stats=regionprops(ch,'Centroid');
    %hold on
    %plot(stats.Centroid(:,1),stats.Centroid(:,2),'r.','MarkerSize',20)
    %hold off
    
    
    %[s]=regionprops(cc,'Area')
    
    %figure
    %imshow(cc)
    
    %figure
    %imshow(ch)
    %boundary=bwn{6,1};
    %figure 
    %imshow(bw2)
    %hold on 
    %plot(boundary(:,2),boundary(:,1),'g','LineWidth',2)
    %hold off
    
end


