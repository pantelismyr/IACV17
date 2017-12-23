clc; clear all; close all;
% add paths
addpath('Functions','Images','Images-m','Images-mat');
% create results folder
mkdir results

%% 2 K-means clustering

% Orange example:
K = 2;               % number of clusters used
L = 15;              % number of iterations
scale_factor = 1.0;  % image downscale factor
image_sigma = 5.0;   % image preblurring scale

% I = imread('orange.jpg');
I = imread('tiger1.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

% Do K means segmentation
% [ segm, centers ,evolution,~] = kmeans_segm(I, K, L, 'forgy',1,0,'img');
% Do Optimal k-Means segmentation
Nruns = 2;
[ segm, centers, evolution ] = kmeans_opt(I, K, L, 'forgy', Nruns);

figure(1)
plot([0:L],evolution, 'LineWidth', 2)
xlabel('Iterations');
ylabel('Distortion Measure (Normalized)');
title('Evolution of the Distortion Measure')
Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);

% Visualize segmentation results
figure(2)
maximizeSubFigs()
subplot(1,3,1)
imshow(Iback)
title('Original');
subplot(1,3,2)
imshow(I)
title('Overlay Bounds');
subplot(1,3,3)
imshow(Inew)
title('Segmentation');
saveas(gcf, fullfile('results', sprintf('k-means_1.png')));

% Visualize distribution
figure(3)
VisImgDis(Iback,segm,'Lab')
saveas(gcf, fullfile('results', sprintf('k-means_1_dist.png')));
% save results
imwrite(Inew,'result/kmeans1.png')
imwrite(I,'result/kmeans2.png')


%% 3 Mean-shift segmentation

scale_factor = 0.5;       % image downscale factor
spatial_bandwidth = 6.5;  % spatial bandwidth
colour_bandwidth = 30.0;  % colour bandwidth
num_iterations = 200;      % number of mean-shift iterations
image_sigma = 1.;        % image preblurring scale

I = imread('tiger1.jpg');
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

segm = mean_shift_segm(I, spatial_bandwidth, colour_bandwidth,...
    num_iterations, 'opt');
Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);

% Visualize segmentation results
figure(4)
maximizeSubFigs()
subplot(1,3,1)
imshow(Iback)
title('Original');
subplot(1,3,2)
imshow(I)
title('Overlay Bounds');
subplot(1,3,3)
imshow(Inew)
title('Segmentation');
saveas(gcf, fullfile('results', sprintf('meanShift_1.png')));

% Visualize distribution
figure(5)
VisImgDis(Iback,segm,'Lab')
saveas(gcf, fullfile('results', sprintf('meanShift_1_dist.png')));
% save results
imwrite(Inew,'result/meanshift1.png')
imwrite(I,'result/meanshift2.png')

%% 4 Normalized Cut

clear all;close all; clc;
colour_bandwidth = 60.0; % color bandwidth; % smaller 'image_sigma' needs 
% broader 'colour_bandwidth' in order to get more details of the object
radius = 4;              % maximum neighbourhood distance
ncuts_thresh = 50;      % cutting threshold; the largest Ncut(A,B) value 
% for which we will allow a segment to be partitioned more. This makes sure
% that our algorithm will not try to partition a segment that is highly 
% likely to be one object in the image.
min_area = 500;         % minimum area of segment; The smallest number of 
% points that a segment is allowed to have. This makes sure that each piece
% we get is not too small.
max_depth = 20;           % maximum splitting depth
scale_factor = 0.4;      % image downscale factor
image_sigma = 0.00001;       % image preblurring scale
% If 'image_sigma' is chosen too small compared with ?X, then the algorithm 
% will tend to focus on details more, namely, a big object is more likely 
% to be cut into small pieces.
im = 'tiger3.jpg';
I = imread(im);
I = imresize(I, scale_factor);
Iback = I;
d = 2*ceil(image_sigma*2) + 1;
h = fspecial('gaussian', [d d], image_sigma);
I = imfilter(I, h);

segm = norm_cuts_segm(I, colour_bandwidth, radius, ncuts_thresh, min_area, max_depth);
Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);

% Visualize segmentation results
% figname = sprintf(' colBand = %d, radius= %d, ncutsThr = %.3f, minAr= %d, maxDe = %d, Isigma =%.3f', colour_bandwidth,radius,ncuts_thresh,min_area,max_depth,image_sigma); 
% figure('Name',figname,'NumberTitle','off');
figure(6)
maximizeSubFigs()
subplot(1,3,1)
imshow(Iback)
title('Original');
subplot(1,3,2)
imshow(I)
title('Overlay Bounds');
subplot(1,3,3)
imshow(Inew)
title('Segmentation');
saveas(gcf, fullfile('results', sprintf('normCut_1.png')));
% Visualize distribution
% figure(7)
% VisImgDis(Iback,segm,'Lab')
saveas(gcf, fullfile('results', sprintf('normCut_1_dist.png')));
% save results
imwrite(Inew,'result/normcuts1.png')
imwrite(I,'result/normcuts2.png')



%% 5 Segmentation using graph cuts

% dbstop in graphcut_segm
scale_factor =0.5;          % image downscale factor
area = [ 105, 149, 536, 280 ]; % image region to train foreground with
K = 3;                      % number of mixture components
alpha = 40.0;                 % maximum edge cost
sigma = 5;                % edge cost decay factor
threshold =0.8;              % prior mask threshold

I = imread('tiger2.jpg');
I = imresize(I, scale_factor);
Iback = I;
area = int16(area*scale_factor);
[ segm, prior ] = graphcut_segm(I, area, K,...
    alpha, sigma,'std','poly',threshold, 'off');

Inew = mean_segments(Iback, segm);
I = overlay_bounds(Iback, segm);

% Visualize segmentation results
figure(8)
maximizeSubFigs()
subplot(2,2,1)
imshow(Iback)
title('Original');
subplot(2,2,2)
imshow(I)
title('Overlay Bounds');
subplot(2,2,3)
imshow(Inew)
title('Segmentation');
subplot(2,2,4); 
imshow(prior);
title('Prior');
saveas(gcf, fullfile('results', sprintf('energy_1.png')));
% Visualize distribution
figure(9)
VisImgDis(Iback,segm,'Lab')
saveas(gcf, fullfile('results', sprintf('energy_1_dist.png')));
% save results
imwrite(Inew,'result/graphcut1.png')
imwrite(I,'result/graphcut2.png')
imwrite(prior,'result/graphcut3.png')


%%
% some baeic functions--->
% maximizeSubFigs()

% saveas(gcf, fullfile('results', sprintf('e02_q01.png')));
%Convenient and frequently used image functions are imread for reading images from
% disk, imwrite for storing images and imresize for changing the size of an image.

%To keep the precision when you apply sequential filtering operations,
% the first thing to do is often to change all values to 
% oating points using either one of the commands
% double or single.

% % Since Matlab prefers operating on 2D arrays for maximum speed, it can 
% sometimes be practical
% % to reshape the image representation from a 3D array of size (H;W; 3) 
% to one with the size (WH; 3).
% % This you can do with the command
% Ivec = reshape(I, width*height, 3);
% and then use the same command to get 
% the image back the original original (H;W; 3)

% Convert the image to L*a*b* color space using makecform and applycform.
% cform = makecform('srgb2lab');
% lab_he = applycform(he,cform);


% It is also worth noting that the K-means algorithm
% itself is often used to initialize the parameters in a Gaussian mixture 
% model before applying the EM algorithm.

% K-Means Advantages :
% 
% 1) If variables are huge, then  K-Means most of the times computationally
% faster than hierarchical clustering, if we keep k smalls.
% 
% 2) K-Means produce tighter clusters than hierarchical clustering, 
% especially if the clusters are globular.
% 
% K-Means Disadvantages :
% 
% 1) Difficult to predict K-Value.
% 2) With global cluster, it didn't work well.
% 3) Different initial partitions can result in different final clusters.
% 4) It does not work well with clusters (in the original data) of Different
% size and Different density