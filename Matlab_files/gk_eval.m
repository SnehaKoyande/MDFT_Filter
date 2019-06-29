function [gk,gk_bar] = gk_eval(h0)

%evaluates the filter response of gk(analysis) and gk_bar(synthesis)

n=length(h0);
buffer=zeros(64,n+128);
for i=1:64
    buffer(i,65:65+n-1)=h0;
end

gk=zeros(64,((n-1)/64)+1);
size(gk);
gk_bar=zeros(64,((n-1)/64)+1);
size(gk_bar);

%creating the analsis and syntesis filters
for i=1:64
    %hi=zeros(1,len);
    hi=buffer(i,i+64:n+i+63);
    gk(i,:)=downsample(hi,64);
end

for i=1:64
    %hi=zeros(1,len+63);
    hi=buffer(i,66-i:n-i+65);
    gk_bar(i,:)=downsample(hi,64);
end
%size(gk_bar(:,1:end-1))
%size(gk(:,2:end))

%gk_bar(:,1:end-1)=gk(:,2:end);