function pixels = Lvvtilde(inpic, t, shape)
%

% Initialize the kernels:
kernel_dx = zeros(5,5);
kernel_dy = zeros(5,5);
kernel_dxx = zeros(5,5);
kernel_dyy = zeros(5,5);
kernel_dxy = zeros(5,5);

% Define the kernels:
[kernel_dx(3,2:4), kernel_dy(2:4,3)] = deriv(1, 'conv2');
[kernel_dxx(3,2:4), kernel_dyy(2:4,3)] = deriv(2, 'conv2');
kernel_dxy = conv2(kernel_dx, kernel_dy,shape);

% smooth with Gaussian LPF
inpic = discgaussfft(inpic,t);

% compute gradients in x and y direction
Lx = filter2(kernel_dx, inpic, shape);
Ly = filter2(kernel_dy, inpic, shape);
Lxx = filter2(kernel_dxx, inpic, shape);
Lyy = filter2(kernel_dyy, inpic, shape);
Lxy = filter2(kernel_dxy, inpic, shape);

% compute and return the partial derivatives
pixels = Lx.^2.*Lxx + 2*Lx.*Ly.*Lxy + Ly.^2.*Lyy;

end