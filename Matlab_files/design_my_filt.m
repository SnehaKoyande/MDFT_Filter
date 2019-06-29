function [filter_responses,h0] = design_my_filt(type)

%function to design filter response using designfilt or rcosdesign

if type==1
    
    %designing filter using designfilt function
    lpFilt = designfilt('lowpassfir','FilterOrder',1024,'CutoffFrequency',0.015625);
    fvtool(lpFilt);
    h=impz(lpFilt);
    %making energy of signal = 1
     energy = sum(sum(abs(h).^2));
    %energy
     h=h/sqrt(energy);
    %plot(h);
    h = h';
    
    peak=max(max(abs(fft(h))));
    
    h=h/peak;
    h0=h;
end

if type==2
    %designing filter using rcosdesign function
    h=rcosdesign(0.25,16,64,'normal');
    %selecting 1025 samples
    
end

filter_responses=zeros(64,length(h));
ew0=exp(1i*(2*pi/64));

for i=1:64
    for j=1:length(h)
        filter_responses(i,j)=h(1,j)*(ew0^((i-1)*(j-1)));
    end
end

figure()
hold on;
for i=1:64
    plot(abs(fft(filter_responses(i,:))));
end
hold off;