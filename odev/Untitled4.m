x=[1 2 3]
N=4;
w=exp(1)^-((sqrt(-1))*(2*pi/N))
m=0;
k=0;
for n=1:N-1
    k=n;
    x(k)=x(n)*w^(n*k)+m
    m=x(k);
end