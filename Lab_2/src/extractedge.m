function edgecurves = extractedge(inpic, scale, threshold)
% 
% compute gradient magnitude (optional: smooth the image)
DerMag = Lv(inpic,scale,'same');
%  compute 2nd derivative (optional: smooth the image)
SecOrder = Lvvtilde(inpic, scale, 'same');
%  compute 2nd derivative (optional: smooth the image)
thrdOrder = Lvvvtilde(inpic, scale, 'same');

% Create masks fo make sure that the functions will work properly:
% create a mask for the 2nd derivative to able the zerocrosscurves to get contours
% this should be the constrain of 3rd derivative to be negative
maskpic1 = (thrdOrder < 0) * 2 - 1;
% create mask for the grad magnitude
maskpic2 = (DerMag > threshold) * 2 - 1;


% extracts level curves in a given image
% and rejects points based on the sign of the second input argument
curves = zerocrosscurves(SecOrder, maskpic1);
% thresholds these curves with respect to the sign of another image.
edgecurves = thresholdcurves(curves, maskpic2);

end