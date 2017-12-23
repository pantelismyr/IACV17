function VisImgDis( image ,segmentation, type)
%Color distribution visualization

% go to double
image = im2double(image);
% Get the sizes of the image
[x_size, y_size, col] = size(image);

% reshape the image
Ivec = reshape(image, x_size*y_size, col);
if strcmpi('xyz',type)
    Ivec = Ivec;
elseif strcmpi('Luv',type)
    % Go to Luv space
    cform = makecform('xyz2uvl');
    Ivec = applycform(Ivec,cform);
elseif strcmpi('Lab',type)
    % Go to Lab space
    cform = makecform('srgb2lab');
    Ivec = applycform(Ivec,cform);
end

color = reshape(segmentation, x_size*y_size, 1);
scatter3(Ivec(:,1),Ivec(:,2),Ivec(:,3),'.', 'CData',color)
colormap(jet)
view(-30,60)
title('Color distribution');
if strcmpi('xyz',type)
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
elseif strcmpi('Luv',type)
    xlabel('u');
    ylabel('v');
    zlabel('L');
elseif strcmpi('Lab',type)
    xlabel('L');
    ylabel('a');
    zlabel('b');
end

end

