function [Image]=gray2rgb(Image)
%Gives a grayscale image an extra dimension
%in order to use color within it
clc;
close all;
clear all;
I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
figure,imshow(I)
J=imnoise(I,'salt & pepper',0.065);
figure,imshow(J)
K=rgb2gray(J);
figure,imshow(K)
mask1=1/9*[1 1 1,1 1 1,1 1 1];
NI=uint8(conv2(double(K),mask1));
figure
imshow(NI);
[m n]=size(NI);
rgb=zeros(m,n,3);
rgb(:,:,1)=NI;
rgb(:,:,2)=rgb(:,:,1);
rgb(:,:,3)=rgb(:,:,1);
NI=rgb/255;
figure,imshow(NI)
end
