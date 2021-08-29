I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
J=imnoise(I,'salt & pepper',0.065);
RGB2 = imresize(J, [512 512]);
A=RGB2;% S&P Filtrelenmiþ hali
for x=3:1:510
for y=3:1:510
for c=1:3
a=[A(x-1,y,c) A(x-2,y,c)  A(x+1,y,c) A(x+2,y,c)  A(x,y+1,c) A(x,y+2,c)  A(x,y-1,c) A(x,y-2,c ) ];

A(x,y,c)=median(a);
end
end
end
figure, imshow(RGB2);
figure, imshow( A);