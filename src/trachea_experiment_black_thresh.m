import us.hebi.sdk.matlab.*;
% cam = webcam(1);
preview(cam);
dx = 100;
dy = 100;
hole = 0;

%% follow the pattern
while(1)
    while(1)
        rgb = snapshot(cam);
        imshow(rgb);
        x_c = size(rgb, 2) / 2;
        y_c = size(rgb, 1) / 2 + 20;
        sz=size(rgb);
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
            idx_1 = idx(1, 2);
            x = centers(idx_1, 1);
            y = centers(idx_1, 2);
            hold on
            plot(x, y, 'Marker', 'o','MarkerFaceColor','red', 'MarkerSize', 9);
            dx = -(x - x_c);
            dy = y - y_c;
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

            x1=centers(radii_one_index,1);
            y1=centers(radii_one_index,2);
            x2=centers(radii_two_index,1);
            y2=centers(radii_two_index,2);

            hold on
            plot(x1, y1, 'Marker', 'o','MarkerFaceColor','red', 'MarkerSize', 9);
            hold on
            plot(x2, y2, 'Marker', 'o','MarkerFaceColor','red', 'MarkerSize', 9);
            if hole == 0
                prompt = 'CHOOSE ONE HOLE (L for left, R for right) L/R: \n';
                str = input(prompt,'s');
                if str == 'L'
                    hole = 1;
                else
                    hole = 2;
                end
            end
            if hole == 1
                if x1 < x2
                    x = x1;
                    y = y1;
                else
                    x = x2;
                    y = y2;
                end
                dx = -(x - x_c);
                dy = y - y_c;
            elseif hole == 2
                if x1 > x2
                    x = x1;
                    y = y1;
                else
                    x = x2;
                    y = y2;
                end
                dx = -(x - x_c);
                dy = y - y_c;
            end            
        end
           
        if abs(dx) <= 20 && abs(dy) <= 20
            break;
        end

        alpha = atan2(dy, dx);
        d_phi = pi / 36;

        motion_prev = [alpha, d_phi];
        disp([dx dy]);
        disp(motion_prev);
        steerHead(group, alpha, d_phi, 0);
        pause(0.1);
        hold off
        pause(0.1);
    end
    snake_advance(group,1);
    pause(1);
    disp('Snake forward');
    
end