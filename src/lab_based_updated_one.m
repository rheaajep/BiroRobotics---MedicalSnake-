clc
clear all
location = 'C:\Users\rheap\Documents\CMU\Robotics lab\medical snake\Images\set_4\*.jpg';   
ds = imageDatastore(location);
while hasdata(ds) 
    rgbImage = read(ds);  
    im_blur = imgaussfilt(rgbImage, 0.5);
    lab_rgbImage=rgb2lab(im_blur);
%     figure
    imshow(lab_rgbImage);
%     figure
    gray_image=rgb2gray(lab_rgbImage);
%     imshow(gray_image);
    bw=gray_image<1;
    %figure
    %imshow(bw);
    ch=bwconvhull(bw,'objects');
%     figure
%     imshow(ch);
    imshow(rgbImage);
    stats=regionprops('table',ch,'Centroid','MajorAxisLength','MinorAxisLength');
    centers=stats.Centroid;
    Size = size(centers);
    num = 1;
    idx = [0];
    len=Size(1);
    if len==1
        x=centers(:,1);
        y=centers(:,2);
        hold on
        plot(x,y,'r.','MarkerSize',20);
        pause(0.1)
        hold off
    else
        for i = 1: len - 1
        p_1 = centers(i, :);
        p_2 = centers(i+1,:);
        d = norm(p_2 - p_1);
        if d > 100
            idx = [idx, i];
            num = num + 1;
        end
        end
        idx = [idx, len];
        areas = [0, 0];
        if num == 1
            x1=centers(1:len, 1);
            y1=centers(1:len, 2);
            x1_mean=mean(x1);
            y1_mean=mean(y1);
            hold on 
            plot(x1_mean,y1_mean,'r.','MarkerSize',20);
        else
            for i = 1: num
            idx_1 = idx(i) + 1;
            idx_2 = idx(i + 1);
            if idx_2 - idx_1 > 10
                x = centers(idx_1: idx_2, 1);
                y = centers(idx_1: idx_2, 2);
                x_mean = mean(x);
                y_mean = mean(y);
                hold on
                plot(x_mean,y_mean,'r.','MarkerSize',20);
            end
        end

        end
    end

    pause(0.1);
    hold off
end