function [ segmentation, centers, evolution ] = ...
    kmeans_opt(image, K, L, init, Nruns)
Nsegm={};
Ncenters={};
Nevolution={};
MinEvol = [];
for i=1:Nruns
    [ Nsegm{i}, Ncenters{i} ,Nevolution{i},~] = ...
        kmeans_segm(image, K, L, 'forgy',0,0,'img');
    MinEvol = [MinEvol Nevolution{i}(end)];
end

[~,BestIdx] =min(MinEvol);

segmentation = Nsegm{BestIdx};
centers =  Ncenters{BestIdx};
evolution = Nevolution{BestIdx};
end

