I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
figure,imshow(I)
J=imnoise(I,'salt & pepper',0.065);
figure,imshow(J)
