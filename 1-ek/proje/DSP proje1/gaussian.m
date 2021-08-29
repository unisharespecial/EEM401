clc;
close all;
clear all;
I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
figure,imshow(I)
P=imnoise(I,'gaussian',1,5);
figure,imshow(P)
J = rgb2gray(P);
mask1=1/9*[1 1 1,1 1 1,1 1 1];
NI=uint8(conv2(double(J),mask1));
figure, imshow(NI);
