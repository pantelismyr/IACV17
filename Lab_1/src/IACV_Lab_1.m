clc; clear all; close all;
% add paths
addpath('Functions','Images','Images-m','Images-mat');
% create results folder
mkdir results

%% 1.3 Basis functions

% Notes:
% the fast Fourier transform (FFT) is implemented using a factor
% 1 in the FFT-routine, and factor 1=N2 in the inverse.

% example 1:
% Fourier transform of an
% image ^ F, that is zero
% everywhere except for a single point (p; q) at which the value is one.

p = [5 9 17 17 5 125];
q = [9 5 9 121 1 1];
sz = 128;


for i=1:length(p)
    figure(i)
    fftwave( p(i), q(i), sz );
    saveas(gcf, fullfile('results', sprintf('1.3.%d.png', i)));
end
fig_count = i;
%% 1.4 Linearity

F = [ zeros(56, 128); ones(16, 128); zeros(56, 128)];
% G = zeros(128);G(:,60:70)=1;showgrey(G)
G = F';
H = F + 2 * G;
Fhat = fft2(F);
Ghat = fft2(G);
Hhat = fft2(H);

% Take the logarithm of the Fourier sperctum
Fhatlog=log(1 + abs(Fhat));
Ghatlog=log(1 + abs(Ghat));
Hhatlog=log(1 + abs(Hhat));

%  Shift zero-frequency component to center of spectrum. Then take the log
%  of that + 1 to take in count the exponetial energy decay. This way the
%  oucome is in some sense normalized and the fine details are not
%  overpowered by the DC component. Note that we take +1 to start from 0.

FhatlogShift=log(1 + abs(fftshift(Fhat)));
GhatlogShift=log(1 + abs(fftshift(Ghat)));
HhatlogShift=log(1 + abs(fftshift(Hhat)));


% Visualize results for F
figure(fig_count+1)
title('Visualize results for F')
subplot(1, 3, 1);
showgrey(F)
subplot(1, 3, 2);
showgrey(Fhatlog);
subplot(1, 3, 3);
showgrey(FhatlogShift);
saveas(gcf, fullfile('results', sprintf('1.4.%d.png', fig_count+1)));
% Visualize results for G
figure(fig_count+2)
title('Visualize results for G')
subplot(1, 3, 1);
showgrey(G)
subplot(1, 3, 2);
showgrey(Ghatlog);
subplot(1, 3, 3);
showgrey(GhatlogShift);
saveas(gcf, fullfile('results', sprintf('1.4.%d.png', fig_count+2)));
% Visualize results for H
figure(fig_count+3)
title('Visualize results for H')
subplot(1, 3, 1);
showgrey(H)
subplot(1, 3, 2);
showgrey(Hhatlog)
subplot(1, 3, 3);
showgrey(HhatlogShift);
saveas(gcf, fullfile('results', sprintf('1.4.%d.png', fig_count+3)));


%% 1.5 Multiplication
fig_count=fig_count+4;
% create the 2 images
F = [ zeros(56, 128); ones(16, 128); zeros(56, 128)];
G = zeros(128)
G(:,62:68)=1
figure(fig_count)
subplot(1, 2, 1);
% multiply them elementwise
showgrey(F .* G);
subplot(1, 2, 2);
% take the Fourier transform of the element-wise multiplication
showfs(fft2(F .* G));
saveas(gcf, fullfile('results', sprintf('1.5.%d.png', fig_count)));
return
% applyin gthe convolution theorem:
% going F and G to the frequency domain
% **Note that we need to take into count the fact that fft2 in matlab does
% not use the normalization factor 1/MN
Fhat=fft2(F);
Ghat=fft2(G);
% Convolve the Fhat with Ghat
FGconv=Fhat*Ghat./(size(F,1)*size(F,2));
figure(fig_count+1)
subplot(1, 2, 1);
showfs(FGconv);
subplot(1, 2, 2);
% do the inverse transform of the convolution
showgrey(ifft2(FGconv));
saveas(gcf, fullfile('results', sprintf('1.5.%d.png', fig_count+1)));

%% 1.6 Scaling
fig_count=fig_count+2;

% create the image
F = [zeros(60, 128); ones(8, 128); zeros(60, 128)] .* ...
    [zeros(128, 48) ones(128, 32) zeros(128, 48)];
% Do fourier transform
Fhat=fft2(F);
% Visualize results
figure(fig_count)
subplot(1, 2, 1);
showgrey(F);
subplot(1, 2, 2);
showfs(Fhat);
saveas(gcf, fullfile('results', sprintf('1.6.%d.png', fig_count)));

%% 1.7 Rotation
fig_count=fig_count+1;



% create the same image as in section 1.6
F = [zeros(60, 128); ones(8, 128); zeros(60, 128)] .* ...
    [zeros(128, 48) ones(128, 32) zeros(128, 48)];

% define angles of rotation
alfa = [30 45 60 90];

% for the given angles do the following

for a=alfa
    
    % rotate it
    figure(fig_count)
    subplot(1, 3, 1);
    G = rot(F, a );
    showgrey(G)
    axis on
    
    % calculate the discrete Fourier transform of the rotated image with
    Ghat = fft2(G);
    subplot(1, 3, 2);
    showfs(Ghat);
    
    % rotate the spectrum back by the same angle
    Hhat = rot(fftshift(Ghat), -a );
    %
    subplot(1, 3, 3);
    showgrey(log(1 + abs(Hhat)))
    
    suptitle(['Rotation of F by : ' num2str(a) ' deg'])
    saveas(gcf, fullfile('results', sprintf('1.7.%d.png', fig_count)));
    
    fig_count=fig_count+1;
end

%% 1.8 Information in Fourier phase and magnitude

% load images
img = {phonecalc128 few128 nallo128};
% set a parameter
a = 1e-10;

% for all of the images
for i=1:length(img)
    
    fig_count=fig_count+1;
    figure(fig_count);
    set(gcf, 'Position', get(0, 'Screensize'));
    subplot(1, 3, 1);
    
    % plot original
    showgrey(img{i})
    title('original')
    
    % plot pow2image: replace the power spectrum for a given image f with a
    % non linear function i.e.|Fourier|^2 \sim 1/(a + |omega|^2)
    subplot(1, 3, 2);
    pow_img = pow2image(img{i}, a);
    showgrey(pow_img)
    title('pow2image')
    
    % plot randphaseimage: keeps the magnitude of the Fourier transform
    % but replaces the phase information with a random distribution
    
    subplot(1, 3, 3);
    rand_img = randphaseimage(img{i});
    showgrey(rand_img)
    title('randphaseimage')
    saveas(gcf, fullfile('results', sprintf('1.8.%d.png', fig_count)));
    
end


%% 2.3 Filtering procedure

fig_count=fig_count+1;
figure(fig_count)
set(gcf, 'Position', get(0, 'Screensize'));

% PART 1: Impulse Response

% define t i.e. variance of the Gaussian kernel
T = [0.1 0.3 1.4 10.0  100.0];

% Create impulse
pic = deltafcn(128, 128);
subplot(1, length(T)+1, 1);
showgrey(pic);
title('impulse')
maximizeSubFigs()

count = 2;
for t=T
    % applying the Gaussian filtering using FFT
    psf = gaussfft(pic, t);
    subplot(1, length(T)+1, count)
    showgrey(psf);
    title(['t = ' num2str(t)])
    maximizeSubFigs()
    
    % computing the variances using gaussfft
    Var = variance(psf)
    % computing the variances using discgaussfft
    Test_Var = variance(discgaussfft(pic, t))
    
    count = count +1;
end

saveas(gcf, fullfile('results', sprintf('2.3.%d.png', fig_count)));


% PART 2: Images

% load images
img = {phonecalc128 few128 nallo128};

% define t i.e. variance of the Gaussian kernel
T = [1.0 4.0 16.0 64.0  256.0];

for i=1:length(img)
    
    fig_count=fig_count+1;
    figure(fig_count);
    set(gcf, 'Position', get(0, 'Screensize'));
    subplot(1, length(T)+1, 1);
    
    % plot original
    showgrey(img{i})
    title('original')
    maximizeSubFigs()
    
    count = 2;
    for t=T
        % applying the Gaussian filtering using FFT
        psf = gaussfft(img{i}, t);
        subplot(1, length(T)+1, count)
        showgrey(psf);
        title(['t = ' num2str(t)])
        maximizeSubFigs()
        count = count +1;
    end
    saveas(gcf, fullfile('results', sprintf('2.3.%d.png', fig_count)));
end

fig_count=fig_count+1;

%% 3.1 Smoothing of noisy data

% load image
office = office256;

% Gaussian NOISE

% Plot original
figure(fig_count);
set(gcf, 'Position', get(0, 'Screensize'));
subplot(2, 5, 1);
showgrey(office)
title('original')
maximizeSubFigs()

% Create noisy images
add = gaussnoise(office, 16); % adding Gaussian noise (white)
subplot(2, 5, 2);
showgrey(add)
title('Gaussian noise')
maximizeSubFigs()

% Set filtering parameters
t =3; % for Gaussian
boxcar = 5; % for Median
cutoff = 0.20; % for Ideal LPF

gaus1 = gaussfft(add, t); % Gaussian filtering
subplot(2, 5, 3);
showgrey(gaus1)
title('gaussfft')
maximizeSubFigs()
med1 = medfilt(add, boxcar); % Median filtering
subplot(2, 5, 4);
showgrey(med1)
title('medfilt')
maximizeSubFigs()
ide1 = ideal(add, cutoff, 'l'); % Ideal low-pass filtering
subplot(2, 5, 5);
showgrey(ide1)
title('ideal')
maximizeSubFigs()

% Salt-and-pepper NOISE

% Plot original
% figure(fig_count +1);
subplot(2, 5, 6);
showgrey(office)
title('original')
maximizeSubFigs()

% Create noisy images
sap = sapnoise(office, 0.1, 255); % adding salt-and-pepper noise
subplot(2, 5, 7);
showgrey(sap)
title('salt-and-pepper')
maximizeSubFigs()

% Set filtering parameters
t =6; % for Gaussian
boxcar = 3; % for Median
cutoff = 0.125; % for Ideal LPF

gaus2 = gaussfft(sap, t); % Gaussian filtering
subplot(2, 5, 8);
showgrey(gaus2)
title('gaussfft')
maximizeSubFigs()
med2 = medfilt(sap, boxcar); % Median filtering
subplot(2, 5, 9);
showgrey(med2)
title('medfilt')
maximizeSubFigs()
ide2 = ideal(sap, cutoff, 'l'); % Ideal low-pass filtering
subplot(2, 5, 10);
showgrey(ide2)
title('ideal')
maximizeSubFigs()

saveas(gcf, fullfile('results', sprintf('3.1.%d.png', fig_count)));

fig_count=fig_count+1;

%% 3.2 Smoothing and subsampling

% rawsubsample:
% reduces the size of an image by a factor of two in each dimension by raw
% subsampling, i.e., by picking out every second pixel along each dimension.

% Smoothing before subsampling with GAUSSIAN filter

% Load image
img = phonecalc256;
figure(fig_count);
set(gcf, 'Position', get(0, 'Screensize'));
smoothimg = img;
N=5;
factor =1 ;

% Define variance of Gaussian LPF
t=2;
for i=1:N
    if i>1 % generate subsampled versions
        smoothimg = gaussfft(img, t); % Gaussian filtering
        img = rawsubsample(img); % subsampling without presmoothing
        smoothimg = rawsubsample(smoothimg); % subsampling with presmoothing
    end
    % visualize subsampling without presmoothing
    subplot(2, N, i)
    showgrey(img)
    maximizeSubFigs()
    title(['pic/' num2str(factor)])
    % visualize subsampling with presmoothing
    subplot(2, N, i+N)
    showgrey(smoothimg)
    maximizeSubFigs()
    title(['pic/' num2str(factor)])
    factor = factor * 2;
end
saveas(gcf, fullfile('results', sprintf('3.2.%d.png', fig_count)));


% Smoothing before subsampling with IDEAL LPF

% Load image
img = phonecalc256;
figure(fig_count+1);
set(gcf, 'Position', get(0, 'Screensize'));
smoothimg = img;
N=5;
factor =1 ;

% Set cutoff for ILPF
cutoff = 0.25;
for i=1:N
    if i>1 % generate subsampled versions
        smoothimg = ideal(img, cutoff, 'l'); % Ideal low-pass filtering
        img = rawsubsample(img); % subsampling without presmoothing
        smoothimg = rawsubsample(smoothimg); % subsampling with presmoothing
    end
    % visualize subsampling without presmoothing
    subplot(2, N, i)
    showgrey(img)
    maximizeSubFigs()
    title(['pic/' num2str(factor)])
    % visualize subsampling with presmoothing
    subplot(2, N, i+N)
    showgrey(smoothimg)
    maximizeSubFigs()
    title(['pic/' num2str(factor)])
    factor = factor * 2;
end
saveas(gcf, fullfile('results', sprintf('3.2.%d.png', fig_count+1)));

