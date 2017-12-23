function [ xkernel, ykernel ] = deriv(order, nextOpp)
%

% Note: in case we do not use conv2 but filter2
% we need to double flip the kernel
% if order is 1 compute the 1st derivative
if order == 1
    xkernel = [-1/2 0 1/2];
    ykernel = xkernel';
    
    % if order is 2 compute the 2nd derivative
elseif order ==2
    xkernel = [1 -2 1];
    ykernel = xkernel';
    
    % if order > 3 : raise error
else
    disp('Error: Please set the differential order equal to 1 or 2')
end

% if we'll use these opperators in conv2 function let them as are
if strcmpi('conv2',nextOpp)
    xkernel = xkernel;
    ykernel = ykernel;
    
    % otherwise double flip the kernel
else
        xkernel = flip(flip(xkernel,1),2);
        ykernel = flip(flip(ykernel,1),2);
    
end

end