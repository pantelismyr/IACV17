function [ segmentation, centers, evolution, covar ] = ...
    kmeans_segm(image, K, L, init, ShowProc, covOn, VecType);

Iback = image;
covar={};
% The K-means clustering algorithms -->
% inputs: an image, the number of cluster centers K, number of iterations
% L and a seed for initializing randomization
% outputs: a segmentation (with a colour index per pixel), the centers
% of all clusters in 3D colour space and the normalized Distortion Measure

% convert image to to double in the interval [0,1]
image = mat2gray(image);

if strcmpi('img',VecType)
    % Get the sizes of the image
    [x_size, y_size, col] = size(image);
    % reshape the image
    Ivec = reshape(image, x_size*y_size, col);
    % define the segmentation matrix
    segmentation = reshape(image(:,:,1), x_size*y_size,1)*0;
    
elseif strcmpi('vec',VecType)
    % Get the sizes of the image
    [x_size, y_size, col] = size(image);
    % reshape the image
    Ivec = image;
    segmentation = reshape(image(:,1), x_size,1)*0;
    
end
% Let X be a set of pixels and V be a set of K cluster centers in 3D (R,G,B).

% initialize clusters:
if strcmpi('random',init)
    % Randomly initialize the K cluster centers
    centers = rand(K,col);
elseif strcmpi('forgy',init)
    % Initialize clusters with Forgy method
    centers = datasample(Ivec,K,'Replace',false);
else
    disp('Please Set Method for Cluster Initialization')
end

% define total distance
evolution = zeros(1,L+1);

% Compute all distances between pixels and cluster centers
distances = pdist2(centers,Ivec,'euclidean');

% Iterate L times
% Assign each pixel to the cluster center for which the distance is minimum
% Recompute each cluster center by taking the mean of all pixels assigned to it
% Recompute all distances between pixels and cluster centers
for i=1:L
    % Assign each pixel to the cluster center for which the distance is minimum
    [value,idx] = min(distances);
    evolution(i) = sum(value(:));
    cluster={};
    if ShowProc
        figure(1000)
        for class=1:K
            segm(idx==class,:)=class;
        end
        Inew = mean_segments(Iback, segm);
        imshow(Inew)
        pause(1/i);
    end
    for class=1:K
        % define 1-of-K coding scheme
        % (expectation step)
        cluster{class} =  Ivec(idx==class,:);
        % set defferent values for the coding scheme
        %         segmentation(idx==class,:)=class;
        % Recompute each cluster center by taking the mean of all pixels
        % assigned to it
        centers(class,:) = mean(cluster{class});
        if covOn && i==L
            covar{class} = cov(cluster{class});
        end
    end
    % Recompute all distances between pixels and cluster centers
    % (maximization step)
    distances = pdist2(centers,Ivec,'euclidean');
    
    
    
end
[value,idx] = min(distances);
evolution(i+1) = sum(value(:));
evolution = evolution./max(evolution(:));
% Compute the segmentation
% by setting defferent values for the coding scheme
for class=1:K
    segmentation(idx==class,:)=class;
end
if strcmpi('img',VecType)
    % reshape segmentation
    segmentation = reshape(segmentation,[x_size,y_size]);
end
end
