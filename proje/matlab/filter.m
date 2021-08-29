I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
figure,imshow(I);
J=imnoise(I,'salt & pepper',0.130);
figure,imshow(J);
K=rgb2gray(J);
figure,imshow(K);
function [Image]=gray2rgb(Image)
%Gives a grayscale image an extra dimension
%in order to use color within it
[m n]=size(Image);
rgb=zeros(m,n,3);
rgb(:,:,1)=Image;
rgb(:,:,2)=rgb(:,:,1);
rgb(:,:,3)=rgb(:,:,1);
Image=rgb/255;
end