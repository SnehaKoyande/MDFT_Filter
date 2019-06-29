%MDFT implementation
clc;
close all;
cd 'C:\Users\nisha\OneDrive\Documents\work\MS\courses\enpm603\termproj';

%filename1='starwars_distorted.wav';
filename1='lotr_distorted.wav';
%filename2='starwars_filtered.wav';
filename2='lotr_filtered.wav';

%designing prototype filter
[filter_responses,h0] = design_my_filt(1);
%evaluating analysis and synthesis filter
[gk,gk_bar] = gk_eval2(h0);

%[input,Fs] = audioread('starwars_distorted.wav');
[input,Fs] = audioread(filename1);

%preparing input matrix
[x,x2]=prep_input(input);
xd=downsample(x,64);
x2d=downsample(x2,64);

xd=xd'*64;      %compensating for decimation
x2d=x2d'*64;    %compensating for decimation

%conv with gk
len_xdg=length(conv(xd(1,:),gk(1,:)));
xdg=zeros(64,len_xdg);
x2dg=zeros(64,len_xdg);

for i=1:64
    xdg(i,:)=conv(gk(i,:),xd(i,:));
end

for i=1:64
    x2dg(i,:)=conv(gk(i,:),x2d(i,:));
end

xdgi=ifft(xdg,64,1);%column wise 64 point ifft
x2dgi=ifft(x2dg,64,1);%column wise 64 point ifft


%evaluating W((N-1)/2)
Wn_1=exp(-sqrt(-1)*(pi/32)*512); %turns out 1 at all the values

xdgiw=zeros(size(xdgi));
x2dgiw=zeros(size(x2dgi));

for i=1:64
    xdgiw(i,:)=xdgi(i,:)*(Wn_1^(i-1));
    x2dgiw(i,:)=x2dgi(i,:)*(Wn_1^(i-1));
end

%taking real and imaginary parts
xdgiwri=zeros(size(xdgi));
x2dgiwri=zeros(size(x2dgi));

for i=1:64
    if mod(i,2)==1
        xdgiwri(i,:)=real(xdgiw(i,:));
        x2dgiwri(i,:)=imag(x2dgiw(i,:))*sqrt(-1);
    end
    
    if mod(i,2)==0
        xdgiwri(i,:)=imag(xdgiw(i,:))*sqrt(-1);
        x2dgiwri(i,:)=real(x2dgiw(i,:));
    end
end

%Filtering with windows of length 80

bands=xdgiwri+x2dgiwri;
len3=length(bands(1,:));
no_wins=floor((len3)/80);

sub_energy=zeros(64,no_wins); %calculated only for debugging

for pos=1:no_wins
    for band=1:64
        sub_energy(band,pos)=sqrt(sum(bands(band,((pos-1)*80)+1:((pos-1)*80)+80).*conj(bands(band,((pos-1)*80)+1:((pos-1)*80)+80)))/80);
        if sqrt(sum(bands(band,((pos-1)*80)+1:((pos-1)*80)+80).*conj(bands(band,((pos-1)*80)+1:((pos-1)*80)+80)))/80) > 0.1
            bands(band,((pos-1)*80)+1:((pos-1)*80)+80)=0;
        end
    end
end

%-----------------------------------------------

%seperating bands into real and imaginary parts
for i=1:64
    if mod(i,2)==1
        xdgiwri(i,:)=real(bands(i,:));
        x2dgiwri(i,:)=imag(bands(i,:))*sqrt(-1);
    end
    
    if mod(i,2)==0
        xdgiwri(i,:)=imag(bands(i,:))*sqrt(-1);
        x2dgiwri(i,:)=real(bands(i,:));
    end
end
%-----------------------------------------------

xdgiwri2=zeros(size(xdgi));
x2dgiwri2=zeros(size(x2dgi));

for i=1:64
    xdgiwri2(i,:)=xdgiwri(i,:)*(Wn_1^(i-1));
    x2dgiwri2(i,:)=x2dgiwri(i,:)*(Wn_1^(i-1));
end

%taking DFT
xdgiwri2f=fft(xdgiwri2,64,1);%column wise 64 point fft
x2dgiwri2f=fft(x2dgiwri2,64,1);%column wise 64 point fft

%conv with gk_bar
abc=length(conv(gk_bar(1,:),xdgiwri2f(1,:)));
xdgiwri2fgkb=zeros(64,abc);
x2dgiwri2fgkb=zeros(64,abc);

for i=1:64
    xdgiwri2fgkb(i,:)=conv(gk_bar(i,:),xdgiwri2f(i,:));
    x2dgiwri2fgkb(i,:)=conv(gk_bar(i,:),x2dgiwri2f(i,:));
end

%upsampling
xdgiwri2fgkbu=xdgiwri2fgkb';
x2dgiwri2fgkbu=x2dgiwri2fgkb';

xdgiwri2fgkbu=upsample(xdgiwri2fgkbu,64);
x2dgiwri2fgkbu=upsample(x2dgiwri2fgkbu,64);

xdgiwri2fgkbu=xdgiwri2fgkbu';
x2dgiwri2fgkbu=x2dgiwri2fgkbu';

%timeshifting and reconstructing the signal
len22=length(xdgiwri2fgkbu(1,:));

y1=zeros(64,len22+63+32);
y2=zeros(64,len22+63+32);
%output=zeros(1,len22+63+32);

for i=1:64
    y1(64-i+1,i+32:len22+i-1+32)=xdgiwri2fgkbu(64-i+1,:);
    y2(64-i+1,i:len22+i-1)=x2dgiwri2fgkbu(64-i+1,:);
end
output=sum(y1+y2);

%soundsc(abs(output),Fs);
%audiowrite(filename2,abs(output),Fs);
audiowrite(filename2,abs(output),Fs);

stft_window_width=256;
disp_spectrogram(stft_window_width,filename1,filename2);