clc 
clear all 
location='C:\Users\rheap\Documents\CMU\Robotics lab\medical snake\Center detection\Images\test_images_new_trachea\set_3\image_0001.jpg';
ds=imageDatastore(location);
image_nos=1;
index_one=1;
idx=[];
while hasdata(ds)
    rgbImage=read(ds);
    %imshow(rgbImage);
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
    v_image=histeq(v_image);
    new_vimage=v_image;
    min_v=min(v_image);
    min_v=min(min_v);
    if min_v>0
        for i=1:sz(1)
            for j=1:sz(2)
                if v_image(i,j)>0.5
                    new_vimage(i,j)=1;
                else
                    new_vimage(i,j)=0;
                end
            
            end
        end
    else
        for i=1:sz(1)
            for j=1:sz(2)
                if v_image(i,j)>0.03
                    new_vimage(i,j)=1;
                else
                    new_vimage(i,j)=0;
                end
            end
        end
    end
    
   
   lab_image=rgb2lab(rgbImage);
   gray_image=rgb2gray(lab_image);
   lab_lumin=lab_image(:,:,1);
   new_lab=lab_lumin;
   labv_image=[];
                    
   for i=1:sz(1)
    for j=1:sz(2)
        if lab_lumin(i,j)>1
            new_lab(i,j)=1;
        else
            new_lab(i,j)=0;
        end
    end
   end
   
    new_lab=~new_lab;
    new_vimage=~new_vimage;
    labv_image=bitor(new_lab,new_vimage);
    imshow(labv_image);
    labv_image=bwareaopen(labv_image,200);


    se=strel('disk',6);
    labv_image=imdilate(labv_image,se);
    ch_image=bwconvhull(labv_image,'objects');
    stats=regionprops('table',ch_image,'Centroid','Area');
    centers=stats.Centroid;
    len=size(centers);
    num_center=0;
    if len(1)==1
        num_center=1;
    end
    area=stats.Area;
    [maxone_area,index_maxone]=max(area);
    if len(1)>1
        [maxtwo_area,index_maxtwo]=max(area(area~=max(area)));
        center_one=centers(index_maxone,:);
        center_two=centers(index_maxtwo,:);
        dist=norm(center_two - center_one);
    
        if dist > 150
            num_center=2;
        end
    end
    
    
      
        
  
    
    imshow(rgbImage);
    if num_center==1
        centerone_x=centers(index_maxone,1);
        centerone_y=centers(index_maxone,2);
        hold on 
        plot(centerone_x,centerone_y,'r.','MarkerSize',10);
    end
        
    
    
    if num_center==2
        centerone_x=centers(index_maxone,1);
        centerone_y=centers(index_maxone,2);
        hold on 
        plot(centerone_x,centerone_y,'r.','MarkerSize',10);
        centertwo_x=centers(index_maxtwo,1);
        centertwo_y=centers(index_maxtwo,2);
        plot(centertwo_x,centertwo_y,'r.','MarkerSize',10);
    end
    
    title(image_nos)
    pause(0.1)
    hold off
    image_nos=image_nos+1;
    
    
    
end


