function [spatialEdge] = findSpatialEdge(prevIm, curIm)
% Input:
%  prevIm: h x w image, the previous frame - middle value, masked
%  curIm: h x w image, the current frame - middle value, masked
%  
% Output:
%  spatialEdge: h x w double, non-zero value specifying the sub-frame time 
%               between previous and current image that the shadow edge hit
%               this pixel (0: no shadow, (0,1): sometime between previous
%               and current frame, 1: current frame)

if isinteger(prevIm)
    prevIm = im2double(prevIm);
end
if isinteger(curIm)
    curIm = im2double(curIm);
end
smallVal = 0.01;

activated = (prevIm > smallVal) & (curIm < -smallVal);
spatialEdge = activated.*(prevIm./(prevIm-curIm));
spatialEdge(isnan(spatialEdge)) = 0;
