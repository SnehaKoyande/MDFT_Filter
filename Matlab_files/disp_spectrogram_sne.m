%STFT
function [] = disp_spectrogram(stft_width,starwars_distorted.wav,starwars_distorted.wav)

%displays the spectrogram and its surface plot

curr_dir = pwd;
cd 'C:\Users\adim\Desktop\Sneha UMCP\SEM-1\603_DSP\Term_Project_Files';

x = audioread(starwars_distorted.wav);
figure();
subplot(2,1,1);
hold on;
spectrogram(x,stft_width);
view(24,31);
hold off;

% z = spectrogram(x,stft_width);
% subplot(2,2,2);
% hold on;
% h=surf(abs(z));
% set(h,'LineStyle','none');
% view(-64,-62);
% hold off;

x2 = audioread(starwars_distorted.wav);
subplot(2,1,2);
hold on;
spectrogram(x2,stft_width);
view(24,31);
hold off;

% subplot(2,2,4);
% hold on;
% z2 = spectrogram(x,stft_width);
% h2=surf(abs(z2));
% set(h2,'LineStyle','none');
% view(-64,-62);
% hold off;

cd (curr_dir);