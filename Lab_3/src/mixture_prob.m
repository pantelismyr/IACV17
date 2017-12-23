function prob = mixture_prob(image, K, L, mask, CovIn)

% convert image to to double in the interval [0,1]
image = mat2gray(image);
% Get the sizes of the image
[x_size, y_size, col] = size(image);
Npixels = x_size*y_size;
% reshape the image
Ivec = reshape(image, Npixels, col);
% apply mask
activePix = bsxfun(@times, image, cast(mask, 'like', image));


% Let I be a set of pixels and V be a set of K Gaussian components in 3D (R,G,B).
% Store all pixels for which mask=1 in a Nx3 matrix
% reshape the mask
maskVec = reshape(mask, Npixels, 1);
activePixF = reshape(activePix, Npixels, col);
activePix = activePixF(find(maskVec),:);
sNpixels = size(activePix,1);

% Randomly initialize the K components using masked pixels

% initialize means and covariances
[ segmentation, Mu ,~,covar] = kmeans_segm(activePix, K, 10, 'forgy',0,1,'vec');
Mu = mat2cell(Mu,ones(1,size(Mu,1)));
if strcmpi('k-means',CovIn)
    covar = covar;
elseif strcmpi('std',CovIn)
    covar = cell(K,1);
    covar(:)={eye(col)+0.1};
end

% initialize wights
w = zeros(1,K);
% iitialize probabilities
p = zeros(sNpixels, K);

for class=1:K
    w(class) = sum(segmentation(:) == class)/(Npixels);
end
% Iterate L times
for i=1:L
    % Expectation: Compute probabilities P_ik using masked pixels
    for class=1:K
        p(:,class) = w(class)*mvnpdf(activePix,Mu{class},covar{class});
    end
    p = p./sum(p,2);
    % Maximization: Update weights, means and covariances using masked pixels
    % update weights
    ProbSum = sum(p,1);
    w = ProbSum/sNpixels;
    
    for class=1:K

        % update mean
        Mu{class} = sum(p(:,class).*activePix, 1)./ProbSum(class);
        % update covariance
        compDiff = activePix - Mu{class};
        covar{class} = (p(:,class).* compDiff)'*compDiff./ProbSum(class);
        [~,pIndex] = chol(covar{class},'lower');
        if pIndex~=0
            %             covar{class} = eye(col) + 1e-5;
            disp('Please lower the number of GMM components')
            disp('Or ADD (more) NOISE !!! ;) ')
            return
        end
        
        % check if covariance matrix is positive definite
        
    end
end
% Compute probabilities p(c_i) in Eq.(3) for all pixels I.
prob = zeros(Npixels, K);
for class=1:K
    prob(:,class) = w(class).*mvnpdf(Ivec,Mu{class},covar{class});
end
prob = sum(prob,2);
% pad = zeros(size(maskVec));
% pad(maskVec~=0) = prob;
% prob =  reshape(pad, x_size, y_size);

end