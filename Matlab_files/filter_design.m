%designing prototype filter
%we took a time shifted prototype filter h
%which is derived from pk which is zero phase real valued raised cosine
%filter. This has been shifted 63 times to cover the entire spectrum
clc;
%clear all;

figure(1);
hold on;
h=rcosdesign(0.25,16,64,'normal');
%hx = designfilt('lowpassfir','PassbandFrequency',0.015,'StopbandFrequency',0.02,'DesignMethod','kaiserwin');
%h=impz(hx,513);
%h=h';
subplot(1,2,1);
plot(h);
subplot(1,2,2);
plot(abs(fft(h)));
hold off;
fvtool(h,'magnitude');

% h2=rcosdesign(0.25,64,8);
% subplot(2,2,2);
% stem(h2);
% subplot(2,2,4);
% stem(abs(fft(h2)));

h3=zeros(64,length(h));
ew0=exp(1i*(2*pi/64));

for i=1:64
    for j=1:length(h)
        h3(i,j)=h(1,j)*(ew0^((i-1)*(j-1)));
    end
end

figure()
hold on;
for i=1:64
    plot(abs(fft(h3(i,:))));
end
hold off;