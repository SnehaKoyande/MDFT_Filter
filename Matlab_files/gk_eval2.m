function [gk,gk_bar] = gk_eval2(h0)

%evaluates the filter response of gk(analysis) and gk_bar(synthesis)

n=length(h0);
buffer=zeros(64,3*n);
for i=1:64
    buffer(i,n+1:2*n)=h0;
    buffer(i,1:n)=h0;
    buffer(i,2*n+1:3*n)=h0;
end

gk=zeros(64,((n-1)/64)+1);
size(gk);
gk_bar=zeros(64,((n-1)/64)+1);
size(gk_bar);

%creating the analsis and syntesis filters
for i=1:64
    %hi=zeros(1,len);
    hi=buffer(i,i+n:i+2*n-1);
    gk(i,:)=downsample(hi,64);
end

for i=1:64
    %hi=zeros(1,len+63);
    hi=buffer(i,n-i+2:2*n-i+2);
    gk_bar(i,:)=downsample(hi,64);
end
%size(gk_bar(:,1:end-1))
%size(gk(:,2:end))

%gk_bar(:,1:end-1)=gk(:,2:end);