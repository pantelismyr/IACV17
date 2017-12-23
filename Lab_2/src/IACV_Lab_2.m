clc; clear all; close all;
% add paths
addpath('Functions','Images','Images-m','Images-mat');
% create results folder
mkdir results

%% 1 Difference operators

% Load the image
tools = few256;

% compute discrete derivation approximations
dxtools = conv2(tools, deltax('conv2'), 'valid');
dytools = conv2(tools, deltay('conv2'), 'valid');

% plot results
figure(1)
maximizeSubFigs()
subplot(1,3,1)
showgrey(tools)
title('tools')
subplot(1,3,2)
showgrey(dxtools)
title('dxtools')
subplot(1,3,3)
showgrey(dytools)
title('dytools')
saveas(gcf, fullfile('results', sprintf('1.png')));


%% 2 Point{wise thresholding of gradient magnitudes

% compute an approximation of the gradient magnitude
gradmagntools = sqrt(dxtools .^2 + dytools .^2);

% Set theshold and apply it to gradmagtools
threshold = 150;
th_gradmagntools = (gradmagntools - threshold) > 0;

figure(2)
maximizeSubFigs()
subplot(2,3,1)
showgrey(tools);
subplot(2,3,4)
histogram(tools,255);
subplot(2,3,2)
showgrey(gradmagntools);
subplot(2,3,5)
histogram(gradmagntools);
subplot(2,3,3)
showgrey(th_gradmagntools);
subplot(2,3,6)
histogram(th_gradmagntools,2);
saveas(gcf, fullfile('results', sprintf('2_tools.png')));

% Load godthem256
god = godthem256;
% compute gradient magnitude (no smoothing)
gradmagod = Lv(god, 0, 'same');
% do thresholding
threshold = 100;
th_gradmagod = (gradmagod - threshold) > 0;

% smooth the image and compute gradient magnitude
gradmagod_sm = Lv(god,1, 'same');
% do thresholding
threshold = 100;
th_gradmagod_sm = (gradmagod_sm - threshold) > 0;

figure(3)
maximizeSubFigs()
subplot(2,3,1)
showgrey(god);
subplot(2,3,4)
histogram(god,255);
subplot(2,3,2)
showgrey(gradmagod);
subplot(2,3,5)
histogram(gradmagod);
subplot(2,3,3)
showgrey(th_gradmagod);
subplot(2,3,6)
histogram(th_gradmagod,2);
saveas(gcf, fullfile('results', sprintf('2_godthem.png')));
figure(4)
maximizeSubFigs()
subplot(2,3,1)
showgrey(god);
subplot(2,3,4)
histogram(god,255);
subplot(2,3,2)
showgrey(gradmagod_sm);
subplot(2,3,5)
histogram(gradmagod_sm);
subplot(2,3,3)
showgrey(th_gradmagod_sm);
subplot(2,3,6)
histogram(th_gradmagod_sm,2);
saveas(gcf, fullfile('results', sprintf('2_godthem_sm.png')));

%% 4 Computing differential geometry descriptors

% Testing masks

% Initialize the kernels:
kernel_dx = zeros(5,5);
kernel_dy = zeros(5,5);
kernel_dxx = zeros(5,5);
kernel_dyy = zeros(5,5);

% Define the kernels:
[kernel_dx(3,2:4), kernel_dy(2:4,3)] = deriv(1, 'conv2');
[kernel_dxx(3,2:4), kernel_dyy(2:4,3)] = deriv(2, 'conv2');
kernel_dxxx = conv2(kernel_dx, kernel_dxx, 'same');
kernel_dyyy = conv2(kernel_dy, kernel_dyy, 'same');
kernel_dxxy = conv2(kernel_dxx, kernel_dy, 'same');
kernel_dxyy = conv2(kernel_dx, kernel_dyy, 'same');

[x y] = meshgrid(-5:5, -5:5);
dx = filter2(kernel_dx, x .^3, 'valid');
dxx = filter2(kernel_dxx, x .^3, 'valid');
dxxx = filter2(kernel_dxxx, x .^3, 'valid');
dxxy = filter2(kernel_dxxy, x .^2 .* y, 'valid');


% Load image
house = godthem256;
% define the defferent scales (smoothig)
scale = [0.0001 1.0  4.0 16.0 64.0];
figure(10)
maximizeSubFigs()
subplot(2,3,1)
contour(Lvvvtilde(house, 0, 'same'), [0 0])
colormap(gray)
axis('image')
axis('ij')
title('Original')
for i=1:length(scale)
    subplot(2,3,i+1)
    contour(Lvvvtilde(house, scale(i), 'same'), [0 0])
    colormap(gray)
    axis('image')
    axis('ij')
    title(['scale = ' num2str(scale(i))])
end
suptitle('Zero crossings of the second order derivative')
saveas(gcf, fullfile('results', sprintf('s04_q4.png')));

% Load image
tools = few256;
figure(11)
maximizeSubFigs()
subplot(2,3,1)
contour(Lvvvtilde(tools, 0, 'same'), [0 0])
colormap(gray)
axis('image')
axis('ij')
title('Original')
for i=1:length(scale)
    subplot(2,3,i+1)
    contour(Lvvvtilde(tools, scale(i), 'same'), [0 0])
    colormap(gray)
    axis('image')
    axis('ij')
    title(['scale = ' num2str(scale(i))])
end
suptitle('Sign of the third order derivative in the gradient direction')
saveas(gcf, fullfile('results', sprintf('s04_q6.png')));
%% 5 Extraction of edge segments

figure(12)
maximizeSubFigs()
subplot(1,2,1)
% load house
image = godthem256;
% extract curves
curves = extractedge(image, 2, 50);
% overlay curves in image
overlaycurves(image, curves);

subplot(1,2,2)
% maximizeSubFigs()
% load tools
image = few256;
% extract curves
curves = extractedge(image, 8, 40);
% overlay curves in image
overlaycurves(image, curves);
saveas(gcf, fullfile('results', sprintf('s05_e01.png')));
%% 6 Hough transform

% Test triangle-->
pic = triangle128;
% houghedgeline(pic, scale, gradmagnthreshold,
% nrho, ntheta, nlines, smothBin, acc_inc, verbose)
[linepar acc] = houghedgeline(pic, 0.5, 40, ...
    500, 300, 3, 0.1, 1, 2);
figure(13)
PlotLines(pic,linepar)
saveas(gcf, fullfile('results', sprintf('s06_e01.png')));
%%
%Test polygon-->
pic = houghtest256;
% houghedgeline(pic, scale, gradmagnthreshold,
% nrho, ntheta, nlines, smothBin, acc_inc, verbose)
[linepar acc] = houghedgeline(pic, 0.5, 60, ...
    700, 500, 7, 0.7, 1, 2);
figure(14)
PlotLines(pic,linepar)
saveas(gcf, fullfile('results', sprintf('s06_e02.png')));

%%
figure(15)
maximizeSubFigs()

pic = few256;
% houghedgeline(pic, scale, gradmagnthreshold,
% nrho, ntheta, nlines, smothBin, acc_inc, verbose)
[linepar acc] = houghedgeline(pic, 1, 100, ...
    1000, 50, 12, 0, 0, 0);
subplot(1,3,1)
PlotLines(pic,linepar)
% 
pic = phonecalc256;
% houghedgeline(pic, scale, gradmagnthreshold,
% nrho, ntheta, nlines, smothBin, acc_inc, verbose)
[linepar acc] = houghedgeline(pic, 8, 50, ...
    1000, 50, 7, 0, 1, 0);
subplot(1,3,2)
PlotLines(pic,linepar)

pic = godthem256;
% houghedgeline(pic, scale, gradmagnthreshold,
% nrho, ntheta, nlines, smothBin, acc_inc, verbose)
[linepar acc] = houghedgeline(pic, 5, 40, ...
    1000, 50, 15, 0, 0, 0);
subplot(1,3,3)
PlotLines(pic,linepar)
saveas(gcf, fullfile('results', sprintf('s06_e03.png')));


