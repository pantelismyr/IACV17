function [ kernel ] = deltay(nextOpp)
% SOBEL operator that approximate the 1st order partial derivatives
% in y-direction


% NOTE: in case we do not use conv2 but filter2 we need to double flip
% the kernel ! ! !

kernel = [-1 0 1; -2 0 2; -1 0 1];

if strcmpi('conv2',nextOpp)
    kernel = kernel;
    
else
    kernel = flip(flip(kernel,1),2);
end

end

