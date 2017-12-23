function Inew = mean_segments(I, segm)

N = max(segm(:));
[h, w, c] = size(I);
Ic = single(reshape(I, [h*w*c, 1]));
sc = reshape(segm, [h*w,c]);
cols = zeros(N, c);
nums = zeros(N, 1);
for i=1:h*w*c
    s = sc(i);
    cols(s,:) = cols(s,:) + Ic(i,:);
    nums(s) = nums(s) + 1;
end
cols = bsxfun(@rdivide, cols, nums);
Inew = uint8(reshape(cols(sc,1), [h,w,c]));
