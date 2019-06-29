function [x,x2]=prep_input(in)

%prepares the delayed versions of input

len=length(in);

x=zeros(64,len+63+32);
x2=zeros(64,len+63+32);


for i=1:64
    x(i,i:len+i-1)=in;
end

for i=1:64
    x2(i,i+32:len+i-1+32)=in;
end

x=x';
x2=x2';