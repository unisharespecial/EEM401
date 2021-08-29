I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
J=imnoise(I,'speckle',0.130);
RGB2 = imresize(J, [512 512]);
