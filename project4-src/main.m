N = 490;
ldr1 = imresize(im2double(imread('../samples/crop-5.jpg')), [N, N], 'bilinear');
ldr2 = imresize(im2double(imread('../samples/crop-12.jpg')), [N, N], 'bilinear');
ldr3 = imresize(im2double(imread('../samples/crop-20.jpg')), [N, N], 'bilinear');
ldr4 = imresize(im2double(imread('../samples/crop-40.jpg')), [N, N], 'bilinear');
ldr5 = imresize(im2double(imread('../samples/crop-80.jpg')), [N, N], 'bilinear');

figure(1);
imshow(ldr1);
figure(2);
imshow(ldr2);
figure(3);
imshow(ldr3);
figure(4);
imshow(ldr4);
figure(5);
imshow(ldr5);

ldrs = cat(4, ldr1, ldr2, ldr3, ldr4, ldr5);

exposures = [1 / 5, 1 / 12, 1 / 20, 1 / 40, 1 / 80];

hdr_naive = makehdr_naive(ldrs, exposures);
hdrwrite(hdr_naive, '../samples/naive.hdr');
hdr_naive_disp = normalize(hdr_naive);
figure(6);
imshow(hdr_naive_disp);

hdr_improved = makehdr_improved(ldrs, exposures);
hdrwrite(hdr_improved, '../samples/improved.hdr');
hdr_improved_disp = normalize(hdr_improved);
figure(7);
imshow(hdr_improved_disp);

hdr_gsolve = makehdr_gsolve(ldrs, exposures);
hdrwrite(hdr_gsolve, '../samples/gsolve.hdr');
hdr_gsolve_disp = normalize(log(hdr_gsolve));
figure(8);
imshow(hdr_gsolve_disp);

hdr_panoramic = panoramic_transform(log(hdr_gsolve));
hdrwrite(hdr_panoramic, '../samples/panoramic.hdr');
hdr_panoramic_disp = normalize(hdr_panoramic);
figure(10);
imshow(hdr_panoramic_disp);

R = im2double(imread('../samples/rendered1.png'));
E = im2double(imread('../samples/rendered2.png'));
M = im2double(imread('../samples/rendered3.png'));

[imh, imw, dim] = size(M);

I = imresize(im2double(imread('../samples/empty.jpg')), [imh, imw], 'bilinear');
O = ones(imh, imw, dim);

c = 5;

figure(11);
imshow(R);
figure(12);
imshow(E);
figure(13);
imshow(M);

composite = M.*R + (O - M).*I + (O - M).*(R - E).*c;
figure(14);
imshow(composite);
figure(15);
imshow(I);
