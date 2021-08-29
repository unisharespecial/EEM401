clc
clear all

% Giris dizisi
input = [523 176 912 349 277];

% Sonuclarin daha belirgin olmasi icin
% giris dizisini 2 periyot yapalým
input = [input input];

% Giris dizisinin boyutunu bul
N = length(input);

% Giris dizisiyle ayni boyutta "0" dolu dizi olustur
X = zeros(1,N);

% DFT hesaplanan bolum
for k = 0:N-1
    for n = 0:N-1
        X(k+1) = X(k+1) +  input(n+1) * exp((-i)*2*pi*k*(n)/N);      
    end 
end
X
% DFT yi cizdirelim
subplot(2,1,1)
manual_ft = fftshift(abs(X));
plot(manual_ft);


% Karsilastirmak icin, bilgisayar tarafýndan hesaplanan
% Fourier Donusumunu de kendi grafigimizin hemen
% altina cizdirelim
automatic_ft = fftshift(abs(fft(input)));    
subplot(2,1,2)
plot(automatic_ft);