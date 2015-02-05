im1 = imread('../samples/5.jpg');
im2 = imread('../samples/12.jpg');
im3 = imread('../samples/20.jpg');
im4 = imread('../samples/40.jpg');
im5 = imread('../samples/80.jpg');

figure(1);
imshow(im1);
I1 = imcrop;
imwrite(I1, '../samples/crop-5.jpg');

figure(2);
imshow(im2);
I2 = imcrop;
imwrite(I2, '../samples/crop-12.jpg');

figure(3);
imshow(im3);
I3 = imcrop;
imwrite(I3, '../samples/crop-20.jpg');

figure(4);
imshow(im4);
I4 = imcrop;
imwrite(I4, '../samples/crop-40.jpg');

figure(5);
imshow(im5);
I5 = imcrop;
imwrite(I5, '../samples/crop-80.jpg');

