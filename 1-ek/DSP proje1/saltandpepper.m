clc;
close all;
clear all;
I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
figure,imshow(I)
J=imnoise(I,'salt & pepper',0.065);
figure,imshow(J)
mask1=1/9*[1 1 1,1 1 1,1 1 1];
NI=uint8(conv3(double(J),mask1));
figure
imshow(NI);
NI=double(NI);
n=gray2rgb(NI);
figure,imshow(n);
figure,imshow( label2rgb(n) )