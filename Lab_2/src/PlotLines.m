function PlotLines(pic, linepar)

% Get image dimensions
[y_max,x_max] = size(pic);
% calculate maximum distance
D = sqrt(x_max^2 + y_max^2);
% get number of lines to print out
nlines=size(linepar,2);
% initialize courves matrix (contour-wise)
outcurves = zeros(2,4*nlines);

% extract the lines which had the highest response in the accumulator
% space
for idx=1:nlines
    % Get rho from linepar
    rho = linepar(1,idx);
    % Get theta from linepar
    theta = linepar(2,idx);
    % compute central value at x0=0
    x0 = 0;
    % compute y value for the x0 (go back to cartesian)
    % go back to cartesian with: y=?/sin?-x*cos?/sin?
    y0 = rho /sin(theta) -x0* cos(theta)/ sin(theta);
    % set dx equal to max distance
    dx = D;
    % compute corresponding dy given dx
    % go back to cartesian with: y=?/sin?-x*cos?/sin?
    dy = rho /sin(theta) -dx* cos(theta)/ sin(theta);
    
    
    % set the curve as in contour i.e. 1st tuple is [lvl,npoints]
    outcurves(1, 4*(idx-1) + 1) = 0; % level, not significant
    outcurves(2, 4*(idx-1) + 1) = 3; % number of points in the curve
    % set the 1st point
    outcurves(2, 4*(idx-1) + 2) = -dx;
    outcurves(1, 4*(idx-1) + 2) = -dy;
    % set the 2st point
    outcurves(2, 4*(idx-1) + 3) = x0;
    outcurves(1, 4*(idx-1) + 3) = y0;
    % set the 3st point
    outcurves(2, 4*(idx-1) + 4) = dx;
    outcurves(1, 4*(idx-1) + 4) = dy;
end

% overlay lines to the picture
overlaycurves_colors(pic,outcurves);


end