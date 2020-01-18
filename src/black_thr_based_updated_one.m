clc
clear all
location = 'C:\Users\rheap\Documents\CMU\Robotics lab\medical snake\Images\set_1\*.jpg';
ds=imageDatastore(location);
while hasdata(ds)
    rgb = read(ds);
    imshow(rgb);
    sz=size(rgb);

    hsv = rgb2hsv(rgb);
    vsh(:,:,1)= hsv(:,:,3);
    vsh(:,:,2) = hsv(:,:,2);
    vsh(:,:,3) = hsv(:,:,1);



    RGB = rgb;
    for i=1:sz(1)
        for j=1:sz(2)
            RGB(i,j,1) = round(3.6.*rgb(i,j,1)-100);
            RGB(i,j,2) = round(3.6.*rgb(i,j,2)-100);
            RGB(i,j,3) = round(3.6.*rgb(i,j,3)-100);
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

    RGB = imgaussfilt(RGB,2,'FilterSize',3);
    RGB = imgaussfilt(RGB,2,'FilterSize',3);


    blk_thr = ((RGB(:,:,1) >= 0) & (RGB(:,:,1) <= 110) & (RGB(:,:,2) >= 0) & (RGB(:,:,2) <= 110) & (RGB(:,:,3) >= 0) & (RGB(:,:,3) <= 20));
    binary_blk_thr = blk_thr;
    RGB_blk_thr = RGB;
    RGB_blk_thr(repmat(~binary_blk_thr,[1 1 3])) = 0;


    bw=bwconvhull(binary_blk_thr,'objects');
    stats=regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength');
    centers=stats.Centroid;
    Size=size(centers);
    len=Size(1);
    diameters=mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii=diameters/2;
    idx=[0];

    for i=1:len
        if radii(i,1)>=29
            idx=[idx,i];
        end
    end

    len_idx=length(idx);
 
    if len_idx == 2
        idx_1=idx(1,2);
        center_x=centers(idx_1,1);
        center_y=centers(idx_1,2);
        hold on 
        plot(center_x,center_y,'r.','MarkerSize',20)
    else
        radii_one=radii(idx(1,2),1);
        radii_one_index=0;
        radii_two_index=0;
        radii_i=0;
        for i=2:len_idx
            if radii_one<=radii(idx(1,i),1)
                radii_one=radii(idx(1,i),1);
                radii_one_index=idx(1,i);
                radii_i=i;
            end
        end
        radii_two=radii_one;
        for i=2:len_idx
            if i~=radii_i
                if radii(idx(1,i),1)< radii_two
                    radii_two=radii(idx(1,i),1);
                    radii_two_index=idx(1,i);
                elseif radii_two<radii(idx(1,i),1)
                    radii_two=radii(idx(1,i),1);
                    radii_two_index=idx(1,i);
                end
            end
        end
        
        center_x_one=centers(radii_one_index,1);
        center_y_one=centers(radii_one_index,2);
        center_x_two=centers(radii_two_index,1);
        center_y_two=centers(radii_two_index,2);
        hold on
        plot(center_x_one,center_y_one,'r.','MarkerSize',20)
        plot(center_x_two,center_y_two,'r.','MarkerSize',20)
    end
    pause(0.1)
    hold off
end
        
            
                
         
                
               
                
            
            
            
            


    

