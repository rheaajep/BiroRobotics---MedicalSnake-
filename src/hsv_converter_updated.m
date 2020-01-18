clc
clear all
location = 'C:\Users\rheap\Documents\CMU\Robotics lab\medical snake\Images\set_4\image_0139.jpg';
rgb = imread(location);
%imshow(rgb);
sz = size(rgb);

hsv = rgb2hsv(rgb);
vsh(:,:,1)= hsv(:,:,3);
vsh(:,:,2) = hsv(:,:,2);
vsh(:,:,3) = hsv(:,:,1);
%figure 
%imshow(vsh);


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
%figure
%imshow(RGB);

RGB = imgaussfilt(RGB,2,'FilterSize',3);
%figure
%imshow(RGB);
RGB = imgaussfilt(RGB,2,'FilterSize',3);
%figure
%imshow(RGB);


red_thr = ((vsh(:,:,1) >= 0.595) & (vsh(:,:,1) <= 0.898) & (vsh(:,:,2) >= 0.757) & (vsh(:,:,2) <= 1) & (vsh(:,:,3) >= 0) & (vsh(:,:,3) <= 1));
binary_red_thr = red_thr;
RGB_red_thr = RGB; 
RGB_red_thr(repmat(~binary_red_thr,[1 1 3])) = 0;
%figure
imshow(binary_red_thr)
%figure
%imshow(RGB_red_thr);

blk_thr = ((RGB(:,:,1) >= 0) & (RGB(:,:,1) <= 110) & (RGB(:,:,2) >= 0) & (RGB(:,:,2) <= 110) & (RGB(:,:,3) >= 0) & (RGB(:,:,3) <= 20));
binary_blk_thr = blk_thr;
RGB_blk_thr = RGB;
RGB_blk_thr(repmat(~binary_blk_thr,[1 1 3])) = 0;
figure
imshow(binary_blk_thr)
%figure
%imshow(RGB_blk_thr);

wht_thr = ((RGB(:,:,1) >= 81) & (RGB(:,:,1) <= 255) & (RGB(:,:,2) >= 57) & (RGB(:,:,2) <= 255) & (RGB(:,:,3) >= 7) & (RGB(:,:,3) <= 255));
binary_wht_thr = wht_thr;
RGB_wht_thr = RGB;
RGB_wht_thr(repmat(~binary_wht_thr,[1 1 3])) = 0;
figure
imshow(binary_wht_thr)
%imshow(RGB_wht_thr);

pO = bitor(binary_wht_thr,binary_red_thr);
high_prob = pO;
for i=1:sz(1)
    for j=sz(2)
        if pO(i,j)==1
            high_prob(i,j)=0;
        elseif pO(i,j)==0
            high_prob(i,j)=1;
        end
    end
end
%figure 
%imshow(pO);
%figure
%imshow(high_prob);
required = bitand(high_prob,binary_blk_thr);
%figure
%imshow(required);

required = imerode(required,[1 1 1;1 1 1;1 1 1]);
required = imdilate(required,[1 1 1 1 1;1 1 1 1 1;1 1 1 1 1]);

required = imgaussfilt(uint8(required),2,'FilterSize',3);
required = imgaussfilt(uint8(required),2,'FilterSize',3);
required = imgaussfilt(uint8(required),2,'FilterSize',3);

%required = imbinarize(required);
%disp(isa(required,'logical'))

%figure
%imshow(required);