% EEM401 proje �devi // serkut kaya (21094109) 
clear all;
% program resmi okuyor
resimorg = imread('serkut.jpg');  
% resim siyah-beyaz yap�ld�
resimsiyahbeyaz = rgb2gray(resimorg); 
% Standart sapmas� 0.029 / ��renci numaras�: 21094109
resimgaus = imnoise(resimsiyahbeyaz,'gaussian',0,0.029);  
% s�zge�ler 
cf=fftshift(fft2(resimgaus)); 
% butterworth 1
[x,y]=meshgrid(-128:127,-128:127);
bl1=1./(1+((x.^2+y.^2)/15).^5);
cfbl1=cf.*bl1;
bt1=ifft2(cfbl1);
bt1=uint8(abs(bt1));
% butterworth 2
[x,y]=meshgrid(-128:127,-128:127);
bl2=1./(1+((x.^2+y.^2)/15).^2);
cfbl2=cf.*bl2;
bt2=ifft2(cfbl2);
bt2=uint8(abs(bt2));
% butterworth 3
[x,y]=meshgrid(-128:127,-128:127);
bl3=1./(1+((x.^2+y.^2)/15).^0.25);
cfbl3=cf.*bl3;
bt3=ifft2(cfbl3);
bt3=uint8(abs(bt3));
% ��kt�lar
figure;
subplot(2,3,1), imshow(resimorg), title('Orijinal Resim');
subplot(2,3,2), imshow(resimsiyahbeyaz), title('Siyah Beyaz Resim');
subplot(2,3,3), imshow(resimgaus), title('G�r�lt� Eklenmi� Resim');
subplot(2,3,4), imshow(bt1), title('Birinci S�zge� ��k��� Resim');
subplot(2,3,5), imshow(bt2), title('�kinci S�zge� ��k��� Resim');
subplot(2,3,6), imshow(bt3), title('���nc� S�zge� ��k��� Resim');

