
function[X]=radix2hfd(x,M)
if nargin ==2 
 N=M; 
else 
 N=length(x); 
end 
%global M; 
N=length(x); 
L=log2(N); 
if L==1 
 X=[x(1)+x(2) x(1)-x(2)] 
end 
if L>1 
 WN=exp(-j*2*pi/N); 
 W(1,:)=WN.^([0:1:N/2-1]); 
 x0(1,:)=x(1:2:end); 
 x1(1,:)=x(2:2:end); 
 X0(1,:)= radix2hfd(x0)+W.* radix2hfd(x1); 
 X1(1,:)= radix2hfd(x0)-W.* radix2hfd(x1); 
 X=[X0 X1]; 
end 
