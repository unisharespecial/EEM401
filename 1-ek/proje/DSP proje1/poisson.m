I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
figure,imshow(I)
J=imnoise(I,'poisson');
figure,imshow(J)