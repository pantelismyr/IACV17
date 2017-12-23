function [ Conv ] = gaussfft(pic, t)

% Using the fast Fourier transform, convolves the image pic with a
% two-dimensional Gaussian function of arbitrary variance t via a
% discretization of the Gaussian function in the spatial domain.

% Creation of mesh grid (for the cases of add and even # of pixels)
[sx,sy] = size(pic);
half_x = floor(sx/2);
half_y = floor(sy/2);

if mod(sx,2)
    x = [-half_x : half_x];
else
    x = [-half_x : half_x-1];
end
if mod(sy,2)
    y = [-half_y : half_y];
else
    y = [-half_y : half_y-1];
end

[X Y] = meshgrid(x, y);


% creation of a descrete Gaussian filter in the spatial domain
G = (1/ (2*pi*t)) * exp(- (X.^2 + Y.^2) / (2*t));

% Transformation of the Gaussian filter to the frequency domain
Ghat = fft2(G);

% Transformation of the pic to the frequency domain
Phat = fft2(pic);

% Element-wise multiplication on the frequency domain
ConvHat = Ghat.* Phat;

% Inverse FT to the spatial domain and shift
Conv = fftshift(ifft2(ConvHat));

end

