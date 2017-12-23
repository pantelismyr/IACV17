function [linepar acc] = ...
    houghline(curves, magnitude, ...
    nrho, ntheta, threshold, nlines, smothBin, acc_inc, verbose)



% Get image dimensions
[y_max,x_max] = size(magnitude);
% calculate maximum distance from the center
D = sqrt(x_max^2 + y_max^2);

% create theta discretization
thetas = linspace(-pi/2, pi/2, ntheta);
% create rho discretization
rhos = linspace(-D, D, nrho);

% Clear the accumulator array
acc = zeros(nrho,ntheta);

% looping though the curves, perform the hough transform and compute acc:
insize = size(curves, 2);
trypointer = 1;
while trypointer <= insize
    
    % get the edgels from the curve
    polylength = curves(2, trypointer);
    x = curves(2, (trypointer+1):(trypointer+polylength));
    y = curves(1, (trypointer+1):(trypointer+polylength));
    cursize = size(x, 2);
    
    for i = 1:cursize
        % get eggel's cartesian coordinates
        x_edgel = x(i);
        y_edgel = y(i);
        
        % for these coordinates loop though all thetas
        j=1;
        for theta = thetas
            
            % compute normal representation
            rho = x_edgel.*cos(theta) + y_edgel.*sin(theta);
            rho_idx = find((rho < rhos), 1);
            % basted on the gradient at the point
            % Note 1: for acc_inc=0 the increment is +1
            % Note 2: since magnitude is by deff >=0
            % we can use all monotonically increasing functions
            % in the definite positive quarter
            acc(rho_idx,j) = acc(rho_idx,j) + ...
                magnitude(round(x_edgel),round(y_edgel))^acc_inc;
            j = j+1;
        end
    end
    trypointer = trypointer + 1 + polylength;
end


% smooth the bins (optional)
if smothBin > 0
    acc = binsepsmoothiter(acc, smothBin, 10);
end

if verbose >= 1
    figure(1000)
%     subplot(1,2,1)
%     showgrey((acc > 0))
%     subplot(1,2,2)
    showgrey(acc)
    axis('equal')
    suptitle('Hough Space')
    axis on
    yticks([1 round(nrho/2) nrho])
    yticklabels({num2str(-round(D/2)),'0',num2str(round(D/2))})
    ylabel('\rho')
    xticks([1 round(ntheta/2) ntheta])
    xticklabels({'-90', '0', '90'})
    axis('ij')
    xlabel('\theta')
    hold on
    
    
end

% get local maxima index
[pos value Anms] = locmax8(acc);
% short local maxima index based on acc value
[dummy indexvector] = sort(value);
% get max lenght so we can sort in descend
nmaxima = size(value, 1);

% Initialize linepar
linepar = [];
% loop through the nlines
for idx = 1:nlines
    % get rho best idx (descending)
    rhoidxacc = pos(indexvector(nmaxima - idx + 1), 1);
    % get theta best idx (descending)
    thetaidxacc = pos(indexvector(nmaxima - idx + 1), 2);
    % get rho best values
    rho = rhos(rhoidxacc);
    % get theta best values
    theta = thetas(thetaidxacc);
    % append to linepar
    linepar = [linepar [rho theta]'];
    if verbose >= 1
        scatter(thetaidxacc,rhoidxacc, '*')
        hold on
    end
    
end

if verbose > 1
    saveas(gcf, fullfile('results', sprintf('s06_e02_hough.png')));
end
hold off
end