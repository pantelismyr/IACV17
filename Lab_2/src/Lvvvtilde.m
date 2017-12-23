function pixels = Lvvvtilde(inpic, t, shape)
%


% Initialize the kernels:
kernel_dx = zeros(5,5);
kernel_dy = zeros(5,5);
kernel_dxx = zeros(5,5);
kernel_dyy = zeros(5,5);

% Define the kernels:
[kernel_dx(3,2:4), kernel_dy(2:4,3)] = deriv(1, 'conv2');
[kernel_dxx(3,2:4), kernel_dyy(2:4,3)] = deriv(2, 'conv2');
kernel_dxxx = conv2(kernel_dx, kernel_dxx, shape);
kernel_dyyy = conv2(kernel_dy, kernel_dyy, shape);
kernel_dxxy = conv2(kernel_dxx, kernel_dy, shape);
kernel_dxyy = conv2(kernel_dx, kernel_dyy, shape);

% smooth with Gaussian LPF
inpic = discgaussfft(inpic,t);

% compute gradients in x and y direction
Lx = filter2(kernel_dx, inpic, shape);
Ly = filter2(kernel_dy, inpic, shape);
Lxxx = filter2(kernel_dxxx, inpic, shape);
Lyyy = filter2(kernel_dyyy, inpic, shape);
Lxxy = filter2(kernel_dxxy, inpic, shape);
Lxyy = filter2(kernel_dxyy, inpic, shape);

% compute and return the partial derivatives
pixels = Lx.^3.*Lxxx + 3*Lx.^2.*Ly.*Lxxy + 3*Lx.*Ly.^2.*Lxyy + Ly.^3.*Lyyy;

end

