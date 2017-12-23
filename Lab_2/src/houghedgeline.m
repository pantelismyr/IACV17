function [linepar acc] = ...
    houghedgeline(pic, scale, gradmagnthreshold, ...
    nrho, ntheta, nlines, smothBin, acc_inc, verbose)

% extract edges
curves = extractedge(pic, scale, gradmagnthreshold);

%compute gradient magnitude
magnitude = Lv(pic, scale, 'same');

% compute the Hough transform
[linepar acc] = houghline(curves, magnitude, ...
    nrho, ntheta, gradmagnthreshold, nlines, smothBin, acc_inc, verbose);

end