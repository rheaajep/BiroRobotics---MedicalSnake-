clc 
clear all 
location='C:\Users\rheap\Documents\CMU\Robotics lab\medical snake\Images\test_images_new_trachea\set_3\image_0041.jpg';
ds=imageDatastore(location);
image_nos=1;
while hasdata(ds)
    rgbImage=read(ds);
    imshow(rgbImage);
    rgbImage=imgaussfilt(rgbImage,0.5);
    RGB = rgbImage;
    sz=size(RGB);
    for i=1:sz(1)
        for j=1:sz(2)
            RGB(i,j,1) = round(3.6.*rgbImage(i,j,1)-100);
            RGB(i,j,2) = round(3.6.*rgbImage(i,j,2)-100);
            RGB(i,j,3) = round(3.6.*rgbImage(i,j,3)-100);
            if RGB(i,j,1) < 0 
                RGB(i,j,1) = 0;
            end
            if RGB(i,j,2) < 0 
                RGB(i,j,2) = 0;
            end
            if RGB(i,j,3) < 0 
               RGB(i,j,3) = 0;
            end
            if RGB(i,j,1) > 255 
                RGB(i,j,1) = 255;
            end
            if RGB(i,j,2) > 255 
                RGB(i,j,2) = 255;
            end
            if RGB(i,j,3) > 255 
               RGB(i,j,3) = 255;
            end
        end
    end
    [H S V]=rgb2hsv(RGB);
    v_image=[V];
    v_image=imgaussfilt(v_image,0.7);
    new_vimage=v_image;
    lab_image=rgb2lab(rgbImage);
    lab_image=lab_image(:,:,1);
    new_lab=lab_image;
    labv_image=[];
    for i=1:sz(1)
        for j=1:sz(2)
            if v_image(i,j)>0.02
                new_vimage(i,j)=1;
            else
                new_vimage(i,j)=0;
            end
            
        end
    end

    for i=1:sz(1)
        for j=1:sz(2)
            if lab_image(i,j)>1
                new_lab(i,j)=1;
            else
                new_lab(i,j)=0;
            end
        end
    end
    
    new_lab=~new_lab;
    new_vimage=~new_vimage;
    labv_image=bitor(new_lab,new_vimage);
    %imshow([new_lab,new_vimage,labv_image]);

    se=strel('disk',6);
    labv_image=imdilate(labv_image,se);
    %imshow(labv_image);
    ch_image=bwconvhull(labv_image,'objects');
    imshow(ch_image);
    stats=regionprops('table',ch_image,'Centroid','MajorAxisLength','MinorAxisLength');
    centers=stats.Centroid;
    len=size(centers);
    diam=mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    [maxone_diam,index_maxone]=max(diam);
    if len(1)>1
        [maxtwo_diam,index_maxtwo]=max(diam(diam~=max(diam)));
    end
        
    
    centerone_x=centers(index_maxone,1);
    centerone_y=centers(index_maxone,2);
    centertwo_x=centers(index_maxtwo,1);
    centertwo_y=centers(index_maxtwo,2);
    hold on 
    plot(centerone_x,centerone_y,'r.','MarkerSize',10);
    plot(centertwo_x,centertwo_y,'r.','MarkerSize',10);
    title(image_nos)
    pause(0.1)
    hold off
    image_nos=image_nos+1;
    
    
    
            
end


