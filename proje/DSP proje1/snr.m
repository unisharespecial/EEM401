I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
J=imnoise(I,'salt & pepper',0.130);
snrdB = 10;
I.sig = sqrt(2)*sin(2*pi*[0:1/64:100]);
J.noise = 10^(-snrdB/20)*randn(size(I.sig));
sig_plus_noise = sig + noise;
I.sigPowerdB = 10*log10((I.sig*(I.sig)')/length(I.sig));
J.noisePowerdB = 10*log10((J.noise*(J.noise)')/length(J.noise));
SNR = 10*log10(I.sigPowerdB/J.noisePowerdB)

%----------------------------------------------------------------------

I=imread('C:\Documents and Settings\Administrator\Desktop\DSP proje\31.jpg');
J=imnoise(I,'gaussian',1,5);
snrdB = 10;
I.sig = sqrt(2)*sin(2*pi*[0:1/64:100]);
J.noise = 10^(-snrdB/20)*randn(size(I.sig));
sig_plus_noise = sig + noise;
I.sigPowerdB = 10*log10((I.sig*(I.sig)')/length(I.sig));
J.noisePowerdB = 10*log10((J.noise*(J.noise)')/length(J.noise));
SNR = 10*log10(I.sigPowerdB/J.noisePowerdB)

%----------------------------------------------------------------------

