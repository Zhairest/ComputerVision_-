%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% HarrisΩ«µ„ºÏ≤‚À„∑® Matlab code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc ;tic;
 
img1 = imread('uttower1.jpg');
img2 = imread('uttower2.jpg');
[posc1,posr1]=Harris20220105(img1);
[posc2,posr2]=Harris20220105(img2);
   
figure;
imshow(img1);
hold on;
plot(posc1,posr1,'r*');
 hold off;

figure;
imshow(img2);
hold on;
plot(posc2,posr2,'r*');
 hold off;
toc;