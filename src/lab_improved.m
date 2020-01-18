clc
clear all 
location = 'C:\Users\rheap\Documents\CMU\Robotics lab\medical snake\Images\test_images_new_trachea\set_3\*.jpg';   
ds = imageDatastore(location);
while hasdata(ds)
    rgb=read(ds);
    sz=size(rgb);
    lab=rgb2lab(rgb);
    grayImage=rgb2gray(lab);
    bw=grayImage<1;
    imshow(bw);
    bw_new=bw;
    se=strel('disk',6);
    j=imdilate(bw,se);
    ch=bwconvhull(j,'objects');
    imshow(ch);
    stats=regionprops('table',ch,'Centroid','MajorAxisLength','MinorAxisLength');
    centers=stats.Centroid;
    len=size(centers);
    for i=1:len(1)
        x_center=centers(i,1);
        y_center=centers(i,2);
        hold on
        plot(x_center,y_center,'r.','MarkerSize',10);
    end
    pause(0.1)
    hold off

    
end
