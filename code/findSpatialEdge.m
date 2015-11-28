function spatialEdge=findSpatialEdge(objectImages,processPixelThresh)
if nargin<2
    processPixelThresh=30;
end
[differenceImage,processPixelMask]=findDifferenceImage(objectImages,processPixelThresh);
spatialEdge1=((abs(differenceImage)<2)&repmat(processPixelMask,[1,1,size(objectImages,3)]));
for i=2:size(objectImages,3)-1
    spatialEdge2(:,:,i)=(differenceImage(:,:,i-1)>0 & differenceImage(:,:,i+1)<0);
end 
spatialEdge=(spatialEdge1(:,:,1:end-1) & spatialEdge2);
%spatialEdge=(spatialEdge & repmat(processPixelMask,[1,1,size(objectImages,3)-1]));
end

function [differenceImage, processPixelMask]=findDifferenceImage(objectImages,processPixelThresh)
num_images=size(objectImages,3);
ImageMin=double(min(objectImages,[],3));
ImageMax=double(max(objectImages,[],3));
processPixelMask=(ImageMax-ImageMin)>processPixelThresh;
ImageShadow=(ImageMin+ImageMax)/2;
differenceImage=double(objectImages)-double(repmat(ImageShadow,[1,1,num_images]));
end
