function pixels = Lv(inpic, t, shape)
%



% smooth with Gaussian LPF
inpic = discgaussfft(inpic,t);

% compute gradients in x and y direction
Lx = filter2(deltax('filter2'), inpic, shape);
Ly = filter2(deltay('filter2'), inpic, shape);
% compute and return gradient mangitude
pixels = sqrt(Lx.^2 + Ly.^2);
% since we use Sobel filter we could just do:
% pixels = abs(Lx)+ abs(Ly);

end