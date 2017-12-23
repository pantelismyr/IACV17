function fftwave( u, v, sz )
% Creates a zero matrix (image) with dimensions [sz x sz] and sets the
% pixel in the place [u,v] to 1. Then it computes the inverse Fourier
% transform of it and get ant plots it's specs.
% if sz is not given it takes the value of 128

if (nargin < 2)
error('Requires at least two input arguments.')
end
if (nargin == 2)
sz = 128;
end

% Creating a zero matrix [sz x sx] (default [128x128])
Fhat = zeros(sz);
% Seting one element equal to 1
Fhat(u, v) = 2;
% compute Fhat's inverse discrete Fourier transform
F = ifft2(Fhat);
Fabsmax = max(abs(F(:)));
subplot(3, 2, 1);
% Visualize it
showgrey(Fhat);
title(sprintf('Fhat: (u, v) = (%d, %d)', u, v));
% If the nonzero pixel is in the 1st quarter of the image, then the uc and vc 
% are the same (-1 to go to the center). Otherwise, it also subtracts the 
% length of horizontal or and the vertical dimension from it. This happens 
% because to do the centering operation this function uses the circshift 
% function which shifts positions of elements circularly. From a more 
% mathematical point of view, this centering operation will move the center 
% by pi (or -pi). Note though that the Fourier and the spatial domain are 
% continuous periodical and we only capture only one full period. Thus, if 
% we split the area in 4 quarters with alignment ABCD (clockwise) the 
% centering operation (shift) will cause alignment DCBA. Thus, we need to 
% take that into consideration when printing the new center.

if (u <= sz/2)
uc = u - 1;
else
uc = u - 1 - sz;
end
if (v <= sz/2)
vc = v - 1;
else
vc = v - 1 - sz;
end

subplot(3, 2, 2);
% Shift zero-frequency component to center of spectrum
% the origin of the Fourier transform can be moved to
% the center by multiplying the original function by (-1)^(m+n)
% in the spatial domain this is equal to the original a  function that
%   is multiplied with an exponential
Fhat_Cent = fftshift(Fhat);
% Visualize it
showgrey(Fhat_Cent);
title(sprintf('centered Fhat: (uc, vc) = (%d, %d)', uc, vc))


% Get the real part
F_real = real(F);
% Get the imaginary part
F_imag = imag(F);
% Get the phase angle
F_angle = angle(F);
% Get the amplitude (Fourier spectrum - modulus of complex number)
F_mag = abs(F);


% w1 = angular frequency in x direction
% w2 = angular frequency in y direction
% Angular frequency w = (w1 w2)'
% Compute wavelength as lamba = 2*pi/|w|
wavelength = 2*pi./norm(F_angle);
% Compute Amplitude as sqrt(Re^2 +Im^2)
amplitude = norm(F_mag); % Replace by correct expression

subplot(3, 2, 3);
% visualize the Real part
showgrey(F_real, 64, -Fabsmax, Fabsmax);
title('real(F)')
subplot(3, 2, 4);
% visualize the Imaginary part i.e. angular frequency
showgrey(F_imag, 64, -Fabsmax, Fabsmax);
title('imag(F)')
subplot(3, 2, 5);
showgrey(F_mag, 64, -Fabsmax, Fabsmax);
title(sprintf('abs(F) (amplitude %f)', amplitude))
subplot(3, 2, 6);
showgrey(angle(F), 64, -pi, pi);
title(sprintf('angle(F) (wavelength %f)', wavelength))

end

