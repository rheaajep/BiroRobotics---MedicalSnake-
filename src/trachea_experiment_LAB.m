import us.hebi.sdk.matlab.*;
% cam = webcam(1);
preview(cam);
dx = 100;
dy = 100;
x_prev = 190;
y_prev = 200;
hole = 0;

%% follow the pattern
while(1)
    while(1)
        img = snapshot(cam);
        imshow(img);
        [dx, dy, x, y] = img_process_LAB(img, x_prev, y_prev, hole);
        x_prev = x;
        y_prev = y;
        if abs(dx) <= 20 && abs(dy) <= 20
            break;
        end
            
        alpha = atan2(dy, dx);
%         d_phi = (pi / 4) * sqrt(dx^2 + dy^2)/sqrt(190^2 + 200^2);
        d_phi = pi / 36;
            
%         motion_prev = [alpha, d_phi];
%         disp([dx dy]);
%         disp(motion_prev);
        snake_steerHeadAngle(group, alpha, d_phi, 0);
        pause(0.1);

        hold off
        pause(0.1);
    end
    snake_advance(group,1);
    pause(1);
    disp('Snake forward');
    
    
end



% while(1)
%     while(1)
%         img = snapshot(cam);
%         imshow(img);
%         lab_img = rgb2lab(img);
%         im_gray = rgb2gray(lab_img);
% %         im_gray = rgb2gray(img);
% %         im_gray = im_ori(10: 370, 10: 390);
%         x_c = size(im_gray, 2) / 2;
%         y_c = size(im_gray, 1) / 2 + 20;
%         %         bw = imbinarize(im_gray, 'adaptive','ForegroundPolarity','dark','Sensitivity',0.7);
% %         bw = imbinarize(im_gray, 0.1);
%         bw = im_gray < 1;
%         ero = imerode(bw, strel('square',2));
%         dil = imdilate(ero, strel('square',25));
%         img_bw = dil;
% %         img_bw = imcomplement(dil);
%         %         figure
% %         imshow(img_bw);
%         areas = bwconncomp(img_bw);
%         numPixels = cellfun(@numel,areas.PixelIdxList);
%         idx = find(numPixels > 12000);
%         
%         if ~isempty(idx)
%             %             disp('move again')
%             %             break;
%             frame = [];
%             for i = 1: length(idx)
%                 pixel = areas.PixelIdxList{idx(i)};
%                 [r, c] = ind2sub(size(im_gray), pixel);
%                 r_min = min(r) + 10;
%                 r_max = max(r) + 10;
%                 c_min = min(c) + 10;
%                 c_max = max(c) + 10;
%                 x = (c_min + c_max) / 2;
%                 y = (r_min + r_max) / 2;
%                 frame = [frame, x, y];
%             end
%             if length(frame) < 4
%                 x = frame(1);
%                 y = frame(2);
%                 hold on
%                 plot(x, y, 'Marker', 'o','MarkerFaceColor','red', 'MarkerSize', 9);
%                 dx = -(x - x_c);
%                 dy = y - y_c;
%             else
%                 x1 = frame(1);
%                 y1 = frame(2);
%                 x2 = frame(3);
%                 y2 = frame(4);
%                 hold on
%                 plot(x1, y1, 'Marker', 'o','MarkerFaceColor','red', 'MarkerSize', 9);
%                 hold on
%                 plot(x2, y2, 'Marker', 'o','MarkerFaceColor','red', 'MarkerSize', 9);
%                 if hole == 0
%                     prompt = 'CHOOSE ONE HOLE (L for left, R for right) L/R: \n';
%                     str = input(prompt,'s');
%                     if str == 'L'
%                         hole = 1;
%                     else
%                         hole = 2;
%                     end
%                 end
%                 if hole == 1
%                     if x1 < x2
%                         x = x1;
%                         y = y1;
%                     else
%                         x = x2;
%                         y = y2;
%                     end
%                     dx = -(x - x_c);
%                     dy = y - y_c;
%                 elseif hole == 2
%                     if x1 > x2
%                         x = x1;
%                         y = y1;
%                     else
%                         x = x2;
%                         y = y2;
%                     end
%                     dx = -(x - x_c);
%                     dy = y - y_c;
%                 end            
%             end
%            
%             if abs(dx) <= 20 && abs(dy) <= 20
%                 break;
%             end
%             
%             alpha = atan2(dy, dx);
%             %             d_phi = (pi / 4) * sqrt(dx^2 + dy^2)/sqrt(190^2 + 200^2);
%             d_phi = pi / 36;
%             
%             motion_prev = [alpha, d_phi];
%             disp([dx dy]);
%             disp(motion_prev);
%             snake_steerHeadAngle(group, alpha, d_phi, 0);
%             pause(0.1);
% %         else
% %             disp('continue');
% %             snake_advance(group,1);
%         end
%         hold off
%         pause(0.1);
%     end
%     %     disp('continue2');
%     snake_advance(group,1);
%     pause(1);
%     disp('Snake forward');
%     
% end